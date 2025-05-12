class UserModel {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
    );
  }
}

class AddressModel {
  final int id;
  final int userId;
  final String name;
  final String phoneNumber;
  final String address;
  final bool isMainAddress;

  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.isMainAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      isMainAddress: json['main_address'] == 1,
    );
  }
}
