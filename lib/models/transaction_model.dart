class TransactionModel {
  final int? id;
  final String type;
  final double amount;
  final String date;
  final String? description;
  final int? relatedSaleId;
  final int? relatedPhoneId;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
    this.relatedSaleId,
    this.relatedPhoneId,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      date: map['date'],
      description: map['description'],
      relatedSaleId: map['relatedSaleId'],
      relatedPhoneId: map['relatedPhoneId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date,
      'description': description,
      'relatedSaleId': relatedSaleId,
      'relatedPhoneId': relatedPhoneId,
    };
  }
}
