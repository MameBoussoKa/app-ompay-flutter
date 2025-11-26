class User {
  final String id;
  final String username;
  final String password;
  final String role;
  final String langue;
  final String theme;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.langue,
    required this.theme,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      langue: json['langue'],
      theme: json['theme'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'langue': langue,
      'theme': theme,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}