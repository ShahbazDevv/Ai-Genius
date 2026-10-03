import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../saved/controllers/saved_controller.dart';

class ResultsController extends GetxController {
  late final GiftRequest request;
  late final List<Recommendation> recommendations;

  // In-memory saved categories tracker
  final RxSet<String> savedCategoryIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      request = args['request'] as GiftRequest;
      recommendations = (args['recommendations'] as List<dynamic>?)
              ?.map((e) => e as Recommendation)
              .toList() ??
          [];
    } else {
      recommendations = [];
      request = GiftRequest(
        relationship: 'Recipient',
        ageGroup: '20-29',
        occasion: 'Special Occasion',
        budget: 3500.0,
        interests: ['Gifts'],
      );
    }
  }

  bool isCategorySaved(String id) {
    if (Get.isRegistered<SavedController>()) {
      return SavedController.to.isCategorySaved(id) || savedCategoryIds.contains(id);
    }
    return savedCategoryIds.contains(id);
  }

  void toggleSaveCategory(String id) {
    if (isCategorySaved(id)) {
      savedCategoryIds.remove(id);
      if (Get.isRegistered<SavedController>()) {
        SavedController.to.removeCategory(id);
      }
    } else {
      savedCategoryIds.add(id);
      if (Get.isRegistered<SavedController>()) {
        final rec = recommendations.firstWhereOrNull((r) => r.category.id == id);
        if (rec != null) {
          SavedController.to.toggleSaveCategory(rec.category);
        }
      }
    }
  }

  void openCategory(Recommendation rec) {
    Get.toNamed(
      AppRoutes.productList,
      arguments: {
        'recommendation': rec,
        'request': request,
      },
    );
  }

  void changeBudget() {
    Get.offAllNamed(AppRoutes.home);
  }
}
