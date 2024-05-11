class User {
  final int id;
  final String email;
  final String name;
  final DateTime dateOfBirth;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }
}
