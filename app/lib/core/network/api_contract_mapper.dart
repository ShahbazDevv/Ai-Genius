/// Central mapping place for converting between UI labels and API contract snake_case values.
/// Defined according to docs/api_contract.md.
class ApiContractMapper {
  // --- RELATIONSHIP ---
  static const Map<String, String> _relationshipUiToApi = {
    'Mother': 'mother',
    'Father': 'father',
    'Friend': 'friend',
    'Best Friend': 'best_friend',
    'Partner': 'partner',
    'Brother': 'brother',
    'Sister': 'sister',
    'Teacher': 'teacher',
    'Colleague': 'colleague',
    'Other': 'other',
  };

  static const Map<String, String> _relationshipApiToUi = {
    'mother': 'Mother',
    'father': 'Father',
    'friend': 'Friend',
    'best_friend': 'Best Friend',
    'partner': 'Partner',
    'brother': 'Brother',
    'sister': 'Sister',
    'teacher': 'Teacher',
    'colleague': 'Colleague',
    'other': 'Other',
  };

  // --- AGE GROUP ---
  static const Map<String, String> _ageGroupUiToApi = {
    '5-9': '5_9',
    '10-19': '10_19',
    '20-24': '20_24',
    '25-29': '25_29',
    '30-39': '30_39',
    '40-49': '40_49',
    '50+': '50_plus',
  };

  static const Map<String, String> _ageGroupApiToUi = {
    '5_9': '5-9',
    '10_19': '10-19',
    '20_24': '20-24',
    '25_29': '25-29',
    '30_39': '30-39',
    '40_49': '40-49',
    '50_plus': '50+',
  };

  // --- GENDER ---
  static const Map<String, String> _genderUiToApi = {
    'Male': 'male',
    'Female': 'female',
    'Prefer not to say': 'unspecified',
  };

  static const Map<String, String> _genderApiToUi = {
    'male': 'Male',
    'female': 'Female',
    'unspecified': 'Prefer not to say',
  };

  // --- OCCASION ---
  static const Map<String, String> _occasionUiToApi = {
    'Birthday': 'birthday',
    'Wedding': 'wedding',
    'Anniversary': 'anniversary',
    'Graduation': 'graduation',
    'Engagement': 'engagement',
    'Thank You': 'thank_you',
    "Valentine's Day": 'valentines_day',
    'Eid': 'eid',
    'Christmas': 'christmas',
    'Other': 'other',
  };

  static const Map<String, String> _occasionApiToUi = {
    'birthday': 'Birthday',
    'wedding': 'Wedding',
    'anniversary': 'Anniversary',
    'graduation': 'Graduation',
    'engagement': 'Engagement',
    'thank_you': 'Thank You',
    'valentines_day': "Valentine's Day",
    'eid': 'Eid',
    'christmas': 'Christmas',
    'other': 'Other',
  };

  // --- INTERESTS ---
  static const Map<String, String> _interestUiToApi = {
    'Beauty': 'beauty',
    'Skincare': 'skincare',
    'Makeup': 'makeup',
    'Books': 'books',
    'Technology': 'technology',
    'Computer Gadgets': 'computer_gadgets',
    'Mobile Accessories': 'mobile_accessories',
    'Sports': 'sports',
    'Cricket': 'cricket',
    'Fitness': 'fitness',
    'Fashion': 'fashion',
    'Jewelry': 'jewelry',
    'Gaming': 'gaming',
    'Travel': 'travel',
    'Home & Lifestyle': 'home_lifestyle',
    'Food': 'food',
    'Art & Crafts': 'art_crafts',
    'Other': 'other',
  };

  static const Map<String, String> _interestApiToUi = {
    'beauty': 'Beauty',
    'skincare': 'Skincare',
    'makeup': 'Makeup',
    'books': 'Books',
    'technology': 'Technology',
    'computer_gadgets': 'Computer Gadgets',
    'mobile_accessories': 'Mobile Accessories',
    'sports': 'Sports',
    'cricket': 'Cricket',
    'fitness': 'Fitness',
    'fashion': 'Fashion',
    'jewelry': 'Jewelry',
    'gaming': 'Gaming',
    'travel': 'Travel',
    'home_lifestyle': 'Home & Lifestyle',
    'food': 'Food',
    'art_crafts': 'Art & Crafts',
    'other': 'Other',
  };

  // --- GIFT STYLES ---
  static const Map<String, String> _giftStyleUiToApi = {
    'Practical': 'practical',
    'Elegant': 'elegant',
    'Luxury': 'luxury',
    'Budget-Friendly': 'budget_friendly',
    'Personalized': 'personalized',
    'Sentimental': 'sentimental',
    'Fun': 'fun',
    'Minimal': 'minimal',
    'Self-Care': 'self_care',
    'Experience': 'experience',
  };

  static const Map<String, String> _giftStyleApiToUi = {
    'practical': 'Practical',
    'elegant': 'Elegant',
    'luxury': 'Luxury',
    'budget_friendly': 'Budget-Friendly',
    'personalized': 'Personalized',
    'sentimental': 'Sentimental',
    'fun': 'Fun',
    'minimal': 'Minimal',
    'self_care': 'Self-Care',
    'experience': 'Experience',
  };

  // --- CONVERTERS ---

  static String relationshipToApi(String val) {
    final trimmed = val.trim();
    if (_relationshipUiToApi.containsKey(trimmed)) {
      return _relationshipUiToApi[trimmed]!;
    }
    final lower = trimmed.toLowerCase().replaceAll(' ', '_');
    if (_relationshipApiToUi.containsKey(lower)) {
      return lower;
    }
    return lower;
  }

  static String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(RegExp(r'[\s_]+')).map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static String relationshipToUi(String val) {
    final trimmed = val.trim();
    if (_relationshipApiToUi.containsKey(trimmed)) {
      return _relationshipApiToUi[trimmed]!;
    }
    if (_relationshipUiToApi.containsKey(trimmed)) {
      return trimmed;
    }
    return _toTitleCase(trimmed);
  }

  static String ageGroupToApi(String val) {
    final trimmed = val.trim();
    if (_ageGroupUiToApi.containsKey(trimmed)) {
      return _ageGroupUiToApi[trimmed]!;
    }
    final sanitized = trimmed
        .replaceAll('-', '_')
        .replaceAll('+', '_plus')
        .toLowerCase();
    if (_ageGroupApiToUi.containsKey(sanitized)) {
      return sanitized;
    }
    return sanitized;
  }

  static String ageGroupToUi(String val) {
    final trimmed = val.trim();
    if (_ageGroupApiToUi.containsKey(trimmed)) {
      return _ageGroupApiToUi[trimmed]!;
    }
    if (_ageGroupUiToApi.containsKey(trimmed)) {
      return trimmed;
    }
    return trimmed.replaceAll('_plus', '+').replaceAll('_', '-');
  }

  static String? genderToApi(String? val) {
    if (val == null || val.trim().isEmpty) return null;
    final trimmed = val.trim();
    if (_genderUiToApi.containsKey(trimmed)) {
      final res = _genderUiToApi[trimmed]!;
      return res == 'unspecified' ? null : res;
    }
    final lower = trimmed.toLowerCase();
    if (lower == 'unspecified' || lower == 'prefer not to say') {
      return null;
    }
    return lower;
  }

  static String? genderToUi(String? val) {
    if (val == null || val.trim().isEmpty) return null;
    final trimmed = val.trim().toLowerCase();
    if (_genderApiToUi.containsKey(trimmed)) {
      return _genderApiToUi[trimmed];
    }
    return _toTitleCase(val);
  }

  static String occasionToApi(String val) {
    final trimmed = val.trim();
    if (_occasionUiToApi.containsKey(trimmed)) {
      return _occasionUiToApi[trimmed]!;
    }
    final lower = trimmed
        .toLowerCase()
        .replaceAll("'", '')
        .replaceAll(' ', '_');
    if (_occasionApiToUi.containsKey(lower)) {
      return lower;
    }
    return lower;
  }

  static String occasionToUi(String val) {
    final trimmed = val.trim();
    if (_occasionApiToUi.containsKey(trimmed)) {
      return _occasionApiToUi[trimmed]!;
    }
    if (_occasionUiToApi.containsKey(trimmed)) {
      return trimmed;
    }
    return _toTitleCase(trimmed);
  }

  static String interestToApi(String val) {
    final trimmed = val.trim();
    if (_interestUiToApi.containsKey(trimmed)) {
      return _interestUiToApi[trimmed]!;
    }
    final lower = trimmed
        .toLowerCase()
        .replaceAll(' & ', '_')
        .replaceAll('&', '_')
        .replaceAll(' ', '_');
    if (_interestApiToUi.containsKey(lower)) {
      return lower;
    }
    return lower;
  }

  static String interestToUi(String val) {
    final trimmed = val.trim();
    if (_interestApiToUi.containsKey(trimmed)) {
      return _interestApiToUi[trimmed]!;
    }
    if (_interestUiToApi.containsKey(trimmed)) {
      return trimmed;
    }
    return _toTitleCase(trimmed);
  }

  static String giftStyleToApi(String val) {
    final trimmed = val.trim();
    if (_giftStyleUiToApi.containsKey(trimmed)) {
      return _giftStyleUiToApi[trimmed]!;
    }
    final lower = trimmed
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    if (_giftStyleApiToUi.containsKey(lower)) {
      return lower;
    }
    return lower;
  }

  static String giftStyleToUi(String val) {
    final trimmed = val.trim();
    if (_giftStyleApiToUi.containsKey(trimmed)) {
      return _giftStyleApiToUi[trimmed]!;
    }
    if (_giftStyleUiToApi.containsKey(trimmed)) {
      return trimmed;
    }
    return _toTitleCase(trimmed);
  }
}
