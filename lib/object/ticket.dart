import 'poi/poi.dart';

class Ticket {
  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.poi,
    required this.groupSize,
  });
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      price:
          json['price'] as String == 'null' ? 0 : double.parse(json['price']),
      poi: Poi.fromJson(json['poi'] as Map<String, dynamic>),
      groupSize: json['groupSize'] as int,
    );
  }
  int id;
  String title;
  String description;
  int quantity;
  double price;
  Poi poi;
  int groupSize;

  Ticket copyWith({
    int? id,
    String? title,
    String? description,
    int? quantity,
    double? price,
    Poi? poi,
    int? groupSize,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      poi: poi ?? this.poi,
      groupSize: groupSize ?? this.groupSize,
    );
  }
}
