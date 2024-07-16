class CheckQuestValidityResponse {
  CheckQuestValidityResponse({required this.valid});

  factory CheckQuestValidityResponse.fromJson(Map<String, dynamic> json) {
    return CheckQuestValidityResponse(
      valid: json['valid'],
    );
  }
  final bool valid;
}
