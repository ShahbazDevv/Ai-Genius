import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/gift_request.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  // Navigation Tab (0: Home, 1: Saved, 2: History)
  final RxInt currentTabIndex = 0.obs;

  // Form State
  final Rx<String?> relationship = Rx<String?>(null);
  final Rx<String?> ageGroup = Rx<String?>(null);
  final Rx<String?> gender = Rx<String?>(null);
  final Rx<String?> occasion = Rx<String?>(null);
  final RxDouble budget = 3500.0.obs;
  final RxSet<String> interests = <String>{}.obs;
  final RxSet<String> giftStyles = <String>{}.obs;
  final TextEditingController additionalDetailsController = TextEditingController();

  // Analysis / Loading state
  final RxBool isAnalyzing = false.obs;

  // Options lists matching design brief exactly
  static const List<String> relationshipOptions = [
    'Mother',
    'Father',
    'Friend',
    'Best Friend',
    'Partner',
    'Brother',
    'Sister',
    'Teacher',
    'Colleague',
    'Other',
  ];

  static const List<String> ageGroupOptions = [
    '5-9',
    '10-19',
    '20-24',
    '25-29',
    '30-39',
    '40-49',
    '50+',
  ];

  static const List<String> genderOptions = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  static const List<String> occasionOptions = [
    'Birthday',
    'Wedding',
    'Anniversary',
    'Graduation',
    'Engagement',
    'Thank You',
    'Valentine\'s Day',
    'Eid',
    'Christmas',
    'Other',
  ];

  static const List<Map<String, dynamic>> interestOptions = [
    {'name': 'Beauty', 'icon': Icons.face_retouching_natural_rounded},
    {'name': 'Skincare', 'icon': Icons.spa_rounded},
    {'name': 'Makeup', 'icon': Icons.brush_rounded},
    {'name': 'Books', 'icon': Icons.menu_book_rounded},
    {'name': 'Technology', 'icon': Icons.devices_rounded},
    {'name': 'Computer Gadgets', 'icon': Icons.laptop_chromebook_rounded},
    {'name': 'Mobile Accessories', 'icon': Icons.smartphone_rounded},
    {'name': 'Sports', 'icon': Icons.sports_soccer_rounded},
    {'name': 'Cricket', 'icon': Icons.sports_cricket_rounded},
    {'name': 'Fitness', 'icon': Icons.fitness_center_rounded},
    {'name': 'Fashion', 'icon': Icons.checkroom_rounded},
    {'name': 'Jewelry', 'icon': Icons.diamond_rounded},
    {'name': 'Gaming', 'icon': Icons.sports_esports_rounded},
    {'name': 'Travel', 'icon': Icons.flight_takeoff_rounded},
    {'name': 'Home & Lifestyle', 'icon': Icons.cottage_rounded},
    {'name': 'Food', 'icon': Icons.restaurant_rounded},
    {'name': 'Art & Crafts', 'icon': Icons.palette_rounded},
    {'name': 'Other', 'icon': Icons.category_rounded},
  ];

  static const List<String> giftStyleOptions = [
    'Practical',
    'Elegant',
    'Luxury',
    'Budget-Friendly',
    'Personalized',
    'Sentimental',
    'Fun',
    'Minimal',
    'Self-Care',
    'Experience',
  ];

  // Validation: Who, age, occasion, and at least 1 interest are required
  bool get isValid =>
      relationship.value != null &&
      ageGroup.value != null &&
      occasion.value != null &&
      interests.isNotEmpty;

  // Single select toggles (tap again to unselect if desired)
  void setRelationship(String val) {
    relationship.value = relationship.value == val ? null : val;
  }

  void setAgeGroup(String val) {
    ageGroup.value = ageGroup.value == val ? null : val;
  }

  void setGender(String val) {
    gender.value = gender.value == val ? null : val;
  }

  void setOccasion(String val) {
    occasion.value = occasion.value == val ? null : val;
  }

  void setBudget(double val) {
    budget.value = val;
  }

  // Multi select toggles
  void toggleInterest(String val) {
    if (interests.contains(val)) {
      interests.remove(val);
    } else {
      interests.add(val);
    }
  }

  void toggleGiftStyle(String val) {
    if (giftStyles.contains(val)) {
      giftStyles.remove(val);
    } else {
      giftStyles.add(val);
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> analyzeGifts() async {
    if (!isValid || isAnalyzing.value) return;

    isAnalyzing.value = true;

    final request = GiftRequest(
      relationship: relationship.value!,
      ageGroup: ageGroup.value!,
      gender: gender.value,
      occasion: occasion.value!,
      budget: budget.value,
      interests: interests.toList(),
      giftStyles: giftStyles.toList(),
      additionalDetails: additionalDetailsController.text.trim().isEmpty
          ? null
          : additionalDetailsController.text.trim(),
    );

    await Get.toNamed(AppRoutes.loading, arguments: request);

    isAnalyzing.value = false;
  }

  @override
  void onClose() {
    additionalDetailsController.dispose();
    super.onClose();
  }
}
