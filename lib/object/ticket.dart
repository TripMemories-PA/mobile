import 'poi/poi.dart';

class Ticket {
  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.poi,
  });
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as String == 'null'
          ? 0
          : double.parse(json['price']),
      poi: Poi.fromJson(json['poi'] as Map<String, dynamic>),
    );
  }
  int id;
  String title;
  String description;
  int quantity;
  double price;
  Poi poi;

  Ticket copyWith({
    int? id,
    String? title,
    String? description,
    int? quantity,
    double? price,
    Poi? poi,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      poi: poi ?? this.poi,
    );
  }
}
