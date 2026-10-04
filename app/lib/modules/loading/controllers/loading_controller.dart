import 'dart:async';
import 'package:get/get.dart';
import '../../../data/mock/mock_gift_repository.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../history/controllers/history_controller.dart';

class LoadingController extends GetxController {
  final MockGiftRepository _repository = MockGiftRepository();

  late GiftRequest request;
  final GiftRequest? initialRequest;
  final RxInt statusIndex = 0.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  Timer? _statusTimer;

  LoadingController({this.initialRequest});

  static const List<String> statusMessages = [
    'Understanding the recipient...',
    'Matching interests...',
    'Checking your budget...',
    'Picking the best gifts...',
  ];

  String get currentStatus => statusMessages[statusIndex.value % statusMessages.length];

  @override
  void onInit() {
    super.onInit();
    final args = initialRequest ?? Get.arguments;
    if (args is GiftRequest) {
      request = args;
    } else {
      request = GiftRequest(
        relationship: 'Friend',
        ageGroup: '25-29',
        occasion: 'Birthday',
        budget: 3500.0,
        interests: ['Technology'],
      );
    }
    loadRecommendations();
  }

  void _startStatusTimer() {
    _statusTimer?.cancel();
    statusIndex.value = 0;
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (statusIndex.value < statusMessages.length - 1) {
        statusIndex.value++;
      }
    });
  }

  Future<void> loadRecommendations() async {
    hasError.value = false;
    errorMessage.value = '';
    _startStatusTimer();

    try {
      final results = await _repository.getRecommendations(request);

      if (!isClosed) {
        _statusTimer?.cancel();

        // Every completed analysis from the Loading screen must add an item to History
        if (Get.isRegistered<HistoryController>()) {
          HistoryController.to.addSearch(
            request: request,
            recommendations: results,
          );
        }

        // Replace loading screen with results screen
        Get.offNamed(
          AppRoutes.results,
          arguments: {
            'request': request,
            'recommendations': results,
          },
        );
      }
    } catch (e) {
      if (!isClosed) {
        _statusTimer?.cancel();
        hasError.value = true;
        errorMessage.value = 'Failed to generate recommendations. Please try again.';
      }
    }
  }

  void retry() {
    loadRecommendations();
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    super.onClose();
  }
}
