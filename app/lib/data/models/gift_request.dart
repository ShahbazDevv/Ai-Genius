class GiftRequest {
  final String relationship;
  final String ageGroup;
  final String? gender;
  final String occasion;
  final double budget;
  final List<String> interests;
  final List<String> giftStyles;
  final String? additionalDetails;

  GiftRequest({
    required this.relationship,
    required this.ageGroup,
    this.gender,
    required this.occasion,
    required this.budget,
    required this.interests,
    this.giftStyles = const [],
    this.additionalDetails,
  });

  factory GiftRequest.fromJson(Map<String, dynamic> json) {
    return GiftRequest(
      relationship: json['relationship'] as String? ?? '',
      ageGroup: json['ageGroup'] as String? ?? '',
      gender: json['gender'] as String?,
      occasion: json['occasion'] as String? ?? '',
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      giftStyles: (json['giftStyles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      additionalDetails: json['additionalDetails'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relationship': relationship,
      'ageGroup': ageGroup,
      'gender': gender,
      'occasion': occasion,
      'budget': budget,
      'interests': interests,
      'giftStyles': giftStyles,
      'additionalDetails': additionalDetails,
    };
  }

  GiftRequest copyWith({
    String? relationship,
    String? ageGroup,
    String? gender,
    String? occasion,
    double? budget,
    List<String>? interests,
    List<String>? giftStyles,
    String? additionalDetails,
  }) {
    return GiftRequest(
      relationship: relationship ?? this.relationship,
      ageGroup: ageGroup ?? this.ageGroup,
      gender: gender ?? this.gender,
      occasion: occasion ?? this.occasion,
      budget: budget ?? this.budget,
      interests: interests ?? this.interests,
      giftStyles: giftStyles ?? this.giftStyles,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }
}
