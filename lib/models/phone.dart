class Phone {
  final int? id;
  final String name;
  final String imei;
  final double costPrice;
  final double salePrice;
  final int? partnerId;

  Phone({
    this.id,
    required this.name,
    required this.imei,
    required this.costPrice,
    required this.salePrice,
    this.partnerId,
  });

  factory Phone.fromMap(Map<String, dynamic> map) {
    return Phone(
      id: map['id'],
      name: map['name'],
      imei: map['imei'],
      costPrice: map['costPrice'],
      salePrice: map['salePrice'],
      partnerId: map['partnerId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imei': imei,
      'costPrice': costPrice,
      'salePrice': salePrice,
      'partnerId': partnerId,
    };
  }
}
