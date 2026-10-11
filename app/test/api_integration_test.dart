import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:app/core/config/app_config.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/network/api_contract_mapper.dart';
import 'package:app/core/network/api_exception.dart';
import 'package:app/data/models/models.dart';
import 'package:app/data/repositories/api_gift_repository.dart';

/// Fake Connectivity for testing connectivity pre-check
class FakeConnectivity implements Connectivity {
  final List<ConnectivityResult> results;
  FakeConnectivity(this.results);

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => results;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream.value(results);
}

void main() {
  group('AppConfig & ApiClient Tests', () {
    tearDown(() {
      AppConfig.reset();
    });

    test('Default base URL is FastAPI cloud URL with 60s timeout', () {
      expect(AppConfig.baseUrl, 'https://ai-genius-backend.fastapicloud.dev');
      expect(AppConfig.timeoutSeconds, 60);
      expect(AppConfig.timeoutDuration, const Duration(seconds: 60));
    });

    test('Allows switching to Android emulator loopback and back', () {
      AppConfig.useEmulator();
      expect(AppConfig.baseUrl, 'http://10.0.2.2:8000');

      AppConfig.useProduction();
      expect(AppConfig.baseUrl, 'https://ai-genius-backend.fastapicloud.dev');

      AppConfig.setBaseUrl('http://192.168.1.100:8000/');
      expect(AppConfig.baseUrl, 'http://192.168.1.100:8000');
    });

    test('ApiClient configures 60s timeout and json headers', () {
      final client = ApiClient();
      expect(client.dio.options.connectTimeout, const Duration(seconds: 60));
      expect(client.dio.options.receiveTimeout, const Duration(seconds: 60));
      expect(client.dio.options.sendTimeout, const Duration(seconds: 60));
      expect(client.dio.options.headers['Content-Type'], 'application/json');
    });
  });

  group('ApiContractMapper Tests', () {
    test('Maps UI relationship labels to API snake_case and back', () {
      expect(ApiContractMapper.relationshipToApi('Mother'), 'mother');
      expect(ApiContractMapper.relationshipToApi('Best Friend'), 'best_friend');
      expect(ApiContractMapper.relationshipToApi('best_friend'), 'best_friend');

      expect(ApiContractMapper.relationshipToUi('mother'), 'Mother');
      expect(ApiContractMapper.relationshipToUi('best_friend'), 'Best Friend');
    });

    test('Maps UI age group labels to API snake_case and back', () {
      expect(ApiContractMapper.ageGroupToApi('40-49'), '40_49');
      expect(ApiContractMapper.ageGroupToApi('50+'), '50_plus');
      expect(ApiContractMapper.ageGroupToApi('5-9'), '5_9');

      expect(ApiContractMapper.ageGroupToUi('40_49'), '40-49');
      expect(ApiContractMapper.ageGroupToUi('50_plus'), '50+');
    });

    test('Maps UI gender labels to API values and handles nulls', () {
      expect(ApiContractMapper.genderToApi('Male'), 'male');
      expect(ApiContractMapper.genderToApi('Female'), 'female');
      expect(ApiContractMapper.genderToApi('Prefer not to say'), isNull);
      expect(ApiContractMapper.genderToApi(null), isNull);

      expect(ApiContractMapper.genderToUi('male'), 'Male');
      expect(ApiContractMapper.genderToUi('female'), 'Female');
      expect(ApiContractMapper.genderToUi('unspecified'), 'Prefer not to say');
    });

    test('Maps UI occasion labels to API snake_case and back', () {
      expect(ApiContractMapper.occasionToApi('Birthday'), 'birthday');
      expect(
        ApiContractMapper.occasionToApi("Valentine's Day"),
        'valentines_day',
      );
      expect(ApiContractMapper.occasionToApi('Thank You'), 'thank_you');

      expect(
        ApiContractMapper.occasionToUi('valentines_day'),
        "Valentine's Day",
      );
      expect(ApiContractMapper.occasionToUi('thank_you'), 'Thank You');
    });

    test('Maps UI interest labels to API snake_case and back', () {
      expect(ApiContractMapper.interestToApi('Beauty'), 'beauty');
      expect(
        ApiContractMapper.interestToApi('Home & Lifestyle'),
        'home_lifestyle',
      );
      expect(
        ApiContractMapper.interestToApi('Computer Gadgets'),
        'computer_gadgets',
      );

      expect(
        ApiContractMapper.interestToUi('home_lifestyle'),
        'Home & Lifestyle',
      );
      expect(
        ApiContractMapper.interestToUi('computer_gadgets'),
        'Computer Gadgets',
      );
    });

    test('Maps UI gift style labels to API snake_case and back', () {
      expect(
        ApiContractMapper.giftStyleToApi('Budget-Friendly'),
        'budget_friendly',
      );
      expect(ApiContractMapper.giftStyleToApi('Self-Care'), 'self_care');

      expect(
        ApiContractMapper.giftStyleToUi('budget_friendly'),
        'Budget-Friendly',
      );
      expect(ApiContractMapper.giftStyleToUi('self_care'), 'Self-Care');
    });
  });

  group('GiftRequest Contract Serialization Tests', () {
    test('toJson generates exact contract snake_case payload', () {
      final req = GiftRequest(
        relationship: 'Mother',
        ageGroup: '40-49',
        gender: 'Female',
        occasion: 'Birthday',
        budget: 3500.0,
        interests: ['Beauty', 'Skincare'],
        giftStyles: ['Elegant', 'Self-Care'],
        additionalDetails: 'Simple natural skincare products.',
      );

      final json = req.toJson();
      expect(json['relationship'], 'mother');
      expect(json['age_group'], '40_49');
      expect(json['gender'], 'female');
      expect(json['occasion'], 'birthday');
      expect(json['budget'], 3500); // Integer per contract
      expect(json['interests'], ['beauty', 'skincare']);
      expect(json['gift_styles'], ['elegant', 'self_care']);
      expect(json['additional_details'], 'Simple natural skincare products.');
    });

    test('fromJson parses API contract response format cleanly', () {
      final apiJson = {
        'relationship': 'best_friend',
        'age_group': '20_24',
        'occasion': 'eid',
        'budget': 5000,
        'interests': ['gaming'],
        'gift_styles': ['fun', 'budget_friendly'],
      };

      final req = GiftRequest.fromJson(apiJson);
      expect(req.relationship, 'Best Friend');
      expect(req.ageGroup, '20-24');
      expect(req.occasion, 'Eid');
      expect(req.budget, 5000.0);
      expect(req.interests, ['Gaming']);
      expect(req.giftStyles, ['Fun', 'Budget-Friendly']);
    });
  });

  group('ApiGiftRepository Tests', () {
    test(
      'Connectivity check throws friendly error BEFORE sending request when offline',
      () async {
        final offlineConnectivity = FakeConnectivity([ConnectivityResult.none]);
        final repo = ApiGiftRepository(connectivity: offlineConnectivity);

        final req = GiftRequest(
          relationship: 'Mother',
          ageGroup: '40-49',
          occasion: 'Birthday',
          budget: 3500.0,
          interests: ['Beauty'],
        );

        expect(
          () => repo.getRecommendations(req),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              'Internet connection is required to generate new recommendations.',
            ),
          ),
        );
      },
    );

    test(
      'Strict budget filter drops any product above request budget as UI safety net',
      () async {
        final dio = Dio();
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'request_id': 'test-uuid',
                    'budget': 3500,
                    'currency': 'PKR',
                    'categories': [
                      {
                        'id': 'cat_skincare',
                        'name': 'Skincare Gift Set',
                        'reason': 'Matches skincare.',
                        'icon': 'spa',
                        'product_count': 2,
                        'products': [
                          {
                            'id': 'p1',
                            'name': 'Under Budget Cream',
                            'description': 'Valid item',
                            'price': 2500,
                            'currency': 'PKR',
                            'image_url': 'https://example.com/p1.jpg',
                            'store_name': 'Daraz',
                            'store_url': 'https://example.com/p1',
                            'category_id': 'cat_skincare',
                            'tags': ['skincare'],
                            'availability': 'in_stock',
                            'source': 'curated',
                            'last_updated': '2026-10-07T00:00:00Z',
                          },
                          {
                            'id': 'p2',
                            'name': 'Over Budget Luxury Cream',
                            'description': 'Over budget item',
                            'price': 4500, // OVER 3500 BUDGET!
                            'currency': 'PKR',
                            'image_url': 'https://example.com/p2.jpg',
                            'store_name': 'Daraz',
                            'store_url': 'https://example.com/p2',
                            'category_id': 'cat_skincare',
                            'tags': ['skincare'],
                            'availability': 'in_stock',
                            'source': 'curated',
                            'last_updated': '2026-10-07T00:00:00Z',
                          },
                        ],
                      },
                    ],
                  },
                ),
              );
            },
          ),
        );

        final onlineConnectivity = FakeConnectivity([ConnectivityResult.wifi]);
        final repo = ApiGiftRepository(
          client: ApiClient(customDio: dio),
          connectivity: onlineConnectivity,
        );

        final req = GiftRequest(
          relationship: 'Mother',
          ageGroup: '40-49',
          occasion: 'Birthday',
          budget: 3500.0,
          interests: ['Skincare'],
        );

        final recs = await repo.getRecommendations(req);
        expect(recs.length, 1);
        final products = recs.first.products;
        expect(products.length, 1);
        expect(products.first.name, 'Under Budget Cream');
        expect(products.first.price, lessThanOrEqualTo(3500.0));
        expect(recs.first.category.productCount, 1);
      },
    );

    test(
      'Empty categories response returns empty list for empty state presentation',
      () async {
        final dio = Dio();
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'request_id': 'test-uuid',
                    'budget': 500,
                    'currency': 'PKR',
                    'categories': [],
                  },
                ),
              );
            },
          ),
        );

        final repo = ApiGiftRepository(
          client: ApiClient(customDio: dio),
          connectivity: FakeConnectivity([ConnectivityResult.wifi]),
        );

        final req = GiftRequest(
          relationship: 'Friend',
          ageGroup: '20-24',
          occasion: 'Birthday',
          budget: 500.0,
          interests: ['Technology'],
        );

        final recs = await repo.getRecommendations(req);
        expect(recs, isEmpty);
      },
    );

    test(
      'Maps HTTP status codes to user-friendly messages without exposing raw errors',
      () async {
        for (final code in [429, 500, 503, 422]) {
          final dio = Dio();
          dio.interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    response: Response(
                      requestOptions: options,
                      statusCode: code,
                    ),
                    type: DioExceptionType.badResponse,
                  ),
                );
              },
            ),
          );

          final repo = ApiGiftRepository(
            client: ApiClient(customDio: dio),
            connectivity: FakeConnectivity([ConnectivityResult.wifi]),
          );

          final req = GiftRequest(
            relationship: 'Mother',
            ageGroup: '40-49',
            occasion: 'Birthday',
            budget: 3500.0,
            interests: ['Beauty'],
          );

          try {
            await repo.getRecommendations(req);
            fail('Should have thrown ApiException');
          } catch (e) {
            expect(e, isA<ApiException>());
            final msg = (e as ApiException).message;
            expect(msg, isNotEmpty);
            expect(msg.toLowerCase(), isNot(contains('traceback')));
            expect(msg.toLowerCase(), isNot(contains('sql')));
            expect(msg.toLowerCase(), isNot(contains('dioexception')));
          }
        }
      },
    );
  });
}
