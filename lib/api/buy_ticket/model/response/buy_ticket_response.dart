class BuyTicketResponse {
  BuyTicketResponse({
    required this.paymentIntent,
  });

  factory BuyTicketResponse.fromJson(Map<String, dynamic> json) {
    return BuyTicketResponse(
      paymentIntent: json['paymentIntent'],
    );
  }
  String paymentIntent;
}
