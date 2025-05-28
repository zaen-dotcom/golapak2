class ShippingAddress {
  final String name;
  final String phoneNumber;
  final String address;

  ShippingAddress({
    required this.name,
    required this.phoneNumber,
    required this.address,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
        name: json['name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }
}