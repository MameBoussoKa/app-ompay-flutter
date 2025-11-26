class Compte {
  final String id;
  final String clientId;
  final String numeroCompte;
  final String devise;
  final String dateDerniereMaj;
  final String createdAt;
  final String updatedAt;

  Compte({
    required this.id,
    required this.clientId,
    required this.numeroCompte,
    required this.devise,
    required this.dateDerniereMaj,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
      id: json['id'],
      clientId: json['client_id'],
      numeroCompte: json['numero_compte'] ?? json['numeroCompte'],
      devise: json['devise'],
      dateDerniereMaj: json['date_derniere_maj'] ?? json['dateDerniereMaj'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'numero_compte': numeroCompte,
      'devise': devise,
      'date_derniere_maj': dateDerniereMaj,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}