class Customer {
  final int? id;
  final String name;
  final String? phoneNumber;
  final String? address;
  final String cnic;

  Customer({
    this.id,
    required this.name,
    this.phoneNumber,
    this.address,
    required this.cnic,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      cnic: map['cnic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'cnic': cnic,
    };
  }
}
