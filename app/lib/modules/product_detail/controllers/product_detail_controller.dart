import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/models.dart';
import '../../saved/controllers/saved_controller.dart';

class ProductDetailController extends GetxController {
  late Product product;
  late GiftRequest? request;
  final RxBool isSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      product = args['product'] as Product;
      request = args['request'] as GiftRequest?;
      if (args['isSaved'] is bool) {
        isSaved.value = args['isSaved'] as bool;
      }
    } else if (args is Product) {
      product = args;
      request = null;
    } else {
      product = Product(
        id: 'sample',
        name: 'Sample Gift',
        description: 'Sample description',
        price: 2500,
        imageUrl: '',
        storeName: 'Daraz',
        storeUrl: 'https://daraz.pk',
        category: 'cat_skincare',
        tags: ['Gifts', 'Curated'],
        availability: 'In stock',
        source: 'Curated catalog',
        lastUpdated: '2026-10-02',
      );
      request = null;
    }

    if (Get.isRegistered<SavedController>()) {
      isSaved.value = SavedController.to.isProductSaved(product.id);
    }
  }

  // Availability rule: strictly based on product availability string
  bool get isAvailable => product.availability.trim().toLowerCase() == 'in stock';

  void toggleSave() {
    isSaved.value = !isSaved.value;
    if (Get.isRegistered<SavedController>()) {
      SavedController.to.toggleSaveProduct(product);
    }
  }

  void _showSnackbar(String title, String message, {IconData icon = Icons.error_outline_rounded}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.95),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(icon, color: Colors.white),
      );
    }
  }

  Future<bool> openStoreUrl({Future<bool> Function(Uri)? launcher}) async {
    final urlString = product.storeUrl.trim();
    if (urlString.isEmpty) {
      _showSnackbar(
        'Store Link Unavailable',
        'No direct web store link is provided for this product.',
        icon: Icons.link_off_rounded,
      );
      return false;
    }

    try {
      final uri = Uri.parse(urlString);
      final launchFn = launcher ?? (u) => launchUrl(u, mode: LaunchMode.externalApplication);
      final success = await launchFn(uri);

      if (!success) {
        _showSnackbar(
          'Could Not Open Store',
          'Failed to open $urlString. Please check your browser or connection.',
        );
        return false;
      }
      return true;
    } catch (e) {
      _showSnackbar(
        'Error Opening Store',
        'Could not launch store link: ${e.toString()}',
      );
      return false;
    }
  }
}
