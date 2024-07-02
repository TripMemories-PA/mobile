class Article {
  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.museumId,
    required this.stock,
  });
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as double,
      imageUrl: json['imageUrl'] as String,
      museumId: json['museumId'] as int,
      stock: json['stock'] as int,
    );
  }
  int id;
  String title;
  String description;
  double price;
  String imageUrl;
  int museumId;
  int stock;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'museumId': museumId,
      'stock': stock,
    };
  }

  Article copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    int? museumId,
    int? stock,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      museumId: museumId ?? this.museumId,
      stock: stock ?? this.stock,
    );
  }
}
