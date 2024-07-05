class UserType {

  UserType({
    required this.id,
    required this.name,
  });

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      id: json['id'],
      name: json['name'],
    );
  }
  final int id;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
