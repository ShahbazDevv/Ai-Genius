import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HistoryController>()) {
      Get.put(HistoryController());
    }
  }
}
