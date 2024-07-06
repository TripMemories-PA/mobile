class PostTicketQuery {
  PostTicketQuery({
    required this.title,
    required this.description,
    required this.quantity,
    required this.price,
    required this.groupSize,
  });
  String title;
  String description;
  int quantity;
  double price;
  int groupSize;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'quantity': quantity,
      'price': price,
      'groupSize': groupSize,
    };
  }
}
