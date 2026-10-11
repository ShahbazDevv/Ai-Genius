import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app/core/config/app_config.dart';
import 'package:app/data/models/models.dart';
import 'package:app/data/repositories/api_gift_repository.dart';

class RealConnectionConnectivity implements Connectivity {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => [ConnectivityResult.wifi];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => Stream.value([ConnectivityResult.wifi]);
}

class RealHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context);
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = RealHttpOverrides();
  });

  test('Live Backend: POST /api/v1/recommendations returns and parses live data', () async {
    final repo = ApiGiftRepository(
      connectivity: RealConnectionConnectivity(),
    );

    final req = GiftRequest(
      relationship: 'Mother',
      ageGroup: '40-49',
      gender: 'Female',
      occasion: 'Birthday',
      budget: 3500.0,
      interests: ['Beauty', 'Skincare'],
      giftStyles: ['Elegant', 'Practical'],
    );

    final recommendations = await repo.getRecommendations(req);

    expect(recommendations, isNotEmpty);
    expect(recommendations.length, lessThanOrEqualTo(4));

    for (final rec in recommendations) {
      expect(rec.category.name, isNotEmpty);
      expect(rec.category.reason, isNotEmpty);
      expect(rec.products, isNotEmpty);
      for (final prod in rec.products) {
        expect(prod.price, lessThanOrEqualTo(3500.0),
            reason: 'Product ${prod.name} must be within budget');
      }
    }
  });
}
