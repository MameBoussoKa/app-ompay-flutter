class Client {
  final String id;
  final String? userId;
  final String nom;
  final String prenom;
  final String telephone;
  final String? email;
  final String? confirmationCode;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  Client({
    required this.id,
    this.userId,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.email,
    this.confirmationCode,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      userId: json['user_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      email: json['email'],
      confirmationCode: json['confirmation_code'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'confirmation_code': confirmationCode,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}