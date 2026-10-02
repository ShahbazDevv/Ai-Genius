import 'dart:async';
import 'package:get/get.dart';
import '../../../data/mock/mock_gift_repository.dart';
import '../../../data/models/models.dart';

class LoadingController extends GetxController {
  final MockGiftRepository _repository = MockGiftRepository();

  late final GiftRequest request;
  final RxInt statusIndex = 0.obs;
  final RxBool isComplete = false.obs;
  final RxList<Recommendation> recommendations = <Recommendation>[].obs;

  Timer? _statusTimer;

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
    final args = Get.arguments;
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
    _startStatusCycle();
    _fetchRecommendations();
  }

  void _startStatusCycle() {
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (statusIndex.value < statusMessages.length - 1) {
        statusIndex.value++;
      }
    });
  }

  Future<void> _fetchRecommendations() async {
    final results = await _repository.getRecommendations(request);
    recommendations.assignAll(results);
    isComplete.value = true;
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    super.onClose();
  }
}
