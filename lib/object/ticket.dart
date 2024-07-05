class Ticket {
  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.museumId,
    required this.stock,
  });
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      museumId: json['museumId'] as int,
      stock: json['stock'] as int,
    );
  }
  int id;
  String title;
  String description;
  double price;
  int museumId;
  int stock;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'museumId': museumId,
      'stock': stock,
    };
  }

  Ticket copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    int? museumId,
    int? stock,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      museumId: museumId ?? this.museumId,
      stock: stock ?? this.stock,
    );
  }
}
