import 'package:get/get.dart';
import '../controllers/saved_controller.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SavedController>()) {
      Get.put(SavedController());
    }
  }
}
