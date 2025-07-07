class Installment {
  final int? id;
  final int saleId;
  final String dueDate;
  final double amount;
  final String status;
  final String? paidDate;

  Installment({
    this.id,
    required this.saleId,
    required this.dueDate,
    required this.amount,
    required this.status,
    this.paidDate,
  });

  factory Installment.fromMap(Map<String, dynamic> map) {
    return Installment(
      id: map['id'],
      saleId: map['saleId'],
      dueDate: map['dueDate'],
      amount: map['amount'],
      status: map['status'],
      paidDate: map['paidDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'saleId': saleId,
      'dueDate': dueDate,
      'amount': amount,
      'status': status,
      'paidDate': paidDate,
    };
  }

}
