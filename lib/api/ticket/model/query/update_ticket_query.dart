class UpdateTicketQuery {
  UpdateTicketQuery({
    required this.id,
    this.title,
    this.description,
    this.quantity,
    this.price,
    this.groupSize,
  });
  int id;
  String? title;
  String? description;
  int? quantity;
  double? price;
  int? groupSize;

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (groupSize != null) 'groupSize': groupSize,
    };
  }
}
