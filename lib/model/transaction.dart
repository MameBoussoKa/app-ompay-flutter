class Transaction {
  final String id;
  final String compteId;
  final String type;
  final double montant;
  final String devise;
  final String date;
  final String statut;
  final String? reference;
  final String? marchandId;
  final String? recipientType;
  final String? recipientId;
  final String createdAt;
  final String updatedAt;

  Transaction({
    required this.id,
    required this.compteId,
    required this.type,
    required this.montant,
    required this.devise,
    required this.date,
    required this.statut,
    this.reference,
    this.marchandId,
    this.recipientType,
    this.recipientId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      compteId: json['compte_id'],
      type: json['type'],
      montant: (json['montant'] as num).toDouble(),
      devise: json['devise'],
      date: json['date'],
      statut: json['statut'],
      reference: json['reference'],
      marchandId: json['marchand_id'],
      recipientType: json['recipient_type'],
      recipientId: json['recipient_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'compte_id': compteId,
      'type': type,
      'montant': montant,
      'devise': devise,
      'date': date,
      'statut': statut,
      'reference': reference,
      'marchand_id': marchandId,
      'recipient_type': recipientType,
      'recipient_id': recipientId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}