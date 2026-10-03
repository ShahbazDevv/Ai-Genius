import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../saved/controllers/saved_controller.dart';

enum ProductSortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
}

class ProductListController extends GetxController {
  late Recommendation recommendation;
  late GiftRequest request;

  final Rx<ProductSortOption> selectedSort = ProductSortOption.relevance.obs;
  final RxBool onlyInStock = false.obs;
  final RxSet<String> savedProductIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      recommendation = args['recommendation'] as Recommendation;
      request = args['request'] as GiftRequest;
    } else if (args is Recommendation) {
      recommendation = args;
      request = GiftRequest(
        relationship: 'Friend',
        ageGroup: '25-29',
        occasion: 'Birthday',
        budget: 5000.0,
        interests: ['Gifts'],
      );
    } else {
      recommendation = Recommendation(
        id: 'rec_sample',
        category: GiftCategory(
          id: 'cat_sample',
          name: 'Gift Collection',
          reason: 'Thoughtful selection',
          productCount: 0,
          icon: 'card_giftcard',
        ),
        products: [],
        rank: 1,
      );
      request = GiftRequest(
        relationship: 'Friend',
        ageGroup: '25-29',
        occasion: 'Birthday',
        budget: 5000.0,
        interests: ['Gifts'],
      );
    }
  }

  // Filtered and sorted products list (STRICT: no product above request.budget)
  List<Product> get displayedProducts {
    var list = recommendation.products
        .where((p) => p.price <= request.budget)
        .toList();

    if (onlyInStock.value) {
      list = list
          .where((p) => p.availability.toLowerCase().contains('in stock'))
          .toList();
    }

    switch (selectedSort.value) {
      case ProductSortOption.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.relevance:
        break;
    }

    return list;
  }

  void setSort(ProductSortOption sort) {
    selectedSort.value = sort;
  }

  void toggleInStockFilter() {
    onlyInStock.value = !onlyInStock.value;
  }

  void resetFilters() {
    selectedSort.value = ProductSortOption.relevance;
    onlyInStock.value = false;
  }

  void toggleSaveProduct(String id) {
    if (isProductSaved(id)) {
      savedProductIds.remove(id);
      if (Get.isRegistered<SavedController>()) {
        SavedController.to.removeProduct(id);
      }
    } else {
      savedProductIds.add(id);
      if (Get.isRegistered<SavedController>()) {
        final prod = recommendation.products.firstWhereOrNull((p) => p.id == id);
        if (prod != null) {
          SavedController.to.toggleSaveProduct(prod);
        }
      }
    }
  }

  bool isProductSaved(String id) {
    if (Get.isRegistered<SavedController>()) {
      return SavedController.to.isProductSaved(id) || savedProductIds.contains(id);
    }
    return savedProductIds.contains(id);
  }

  void openProductDetail(Product product) {
    Get.toNamed(
      AppRoutes.productDetail,
      arguments: {
        'product': product,
        'request': request,
        'isSaved': isProductSaved(product.id),
      },
    );
  }
}
