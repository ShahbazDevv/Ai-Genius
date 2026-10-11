import '../../core/network/api_contract_mapper.dart';

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

  /// Factory creating from JSON matching API contract and local storage formats.
  factory GiftRequest.fromJson(Map<String, dynamic> json) {
    final rawRel = json['relationship']?.toString() ?? '';
    final rawAge = (json['age_group'] ?? json['ageGroup'])?.toString() ?? '';
    final rawGender = json['gender']?.toString();
    final rawOccasion = json['occasion']?.toString() ?? '';
    final rawInterests = (json['interests'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];
    final stylesSource = (json['gift_styles'] ?? json['giftStyles']) as List<dynamic>?;
    final rawStyles = stylesSource
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];
    final rawDetails = (json['additional_details'] ?? json['additionalDetails'])?.toString();

    return GiftRequest(
      relationship: ApiContractMapper.relationshipToUi(rawRel),
      ageGroup: ApiContractMapper.ageGroupToUi(rawAge),
      gender: rawGender != null ? ApiContractMapper.genderToUi(rawGender) : null,
      occasion: ApiContractMapper.occasionToUi(rawOccasion),
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      interests: rawInterests.map((e) => ApiContractMapper.interestToUi(e)).toList(),
      giftStyles: rawStyles.map((e) => ApiContractMapper.giftStyleToUi(e)).toList(),
      additionalDetails: rawDetails,
    );
  }

  /// Serializes to JSON matching docs/api_contract.md EXACTLY.
  /// Keys: relationship, age_group, gender, occasion, budget (int), interests, gift_styles, additional_details.
  /// Values: snake_case API values (e.g. "mother", "40_49", "valentines_day").
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'relationship': ApiContractMapper.relationshipToApi(relationship),
      'age_group': ApiContractMapper.ageGroupToApi(ageGroup),
      'occasion': ApiContractMapper.occasionToApi(occasion),
      'budget': budget.toInt(),
      'interests': interests.map(ApiContractMapper.interestToApi).toList(),
      'gift_styles': giftStyles.map(ApiContractMapper.giftStyleToApi).toList(),
    };

    final apiGender = ApiContractMapper.genderToApi(gender);
    if (apiGender != null) {
      map['gender'] = apiGender;
    }

    if (additionalDetails != null && additionalDetails!.trim().isNotEmpty) {
      map['additional_details'] = additionalDetails!.trim();
    }

    return map;
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
