class PostTicketQuery {
  
  PostTicketQuery({
    required this.title,
    required this.description,
    required this.quantity,
    required this.price,
  });
  String title;
  String description;
  int quantity;
  double price;
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'quantity': quantity,
      'price': price,
    };
  }
}
