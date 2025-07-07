class Sale {
  final int? id;
  final int customerId;
  final int phoneId;
  final String saleDate;
  final double totalAmount;
  final double downPayment;
  final int installmentsCount;
  final bool installmentsOver; // <-- Add this

  Sale({
    this.id,
    required this.customerId,
    required this.phoneId,
    required this.saleDate,
    required this.totalAmount,
    required this.downPayment,
    required this.installmentsCount,
    this.installmentsOver = false, // <-- Default value
  });

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      customerId: map['customerId'],
      phoneId: map['phoneId'],
      saleDate: map['saleDate'],
      totalAmount: map['totalAmount'],
      downPayment: map['downPayment'],
      installmentsCount: map['installmentsCount'],
      installmentsOver: map['installmentsover'] == 1, // SQLite stores boolean as 0/1
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'phoneId': phoneId,
      'saleDate': saleDate,
      'totalAmount': totalAmount,
      'downPayment': downPayment,
      'installmentsCount': installmentsCount,
      'installmentsover': installmentsOver ? 1 : 0, // Convert to SQLite format
    };
  }
}
