class Partner {
  final int? id;
  final String name;
  final int investment;
  final String? phoneNumber;
  final String? address;

  Partner({
    this.id,
    required this.name,
    required this.investment,
    this.phoneNumber,
    this.address,
  });

  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      id: map['id'],
      name: map['name'],
      investment: map['investment'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'investment': investment,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
