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
  final double latitude;
  final double longitude;
  final bool isMainAddress;

  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isMainAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      userId:
          json['user_id'] is int
              ? json['user_id']
              : int.tryParse(json['user_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      latitude:
          (json['latitude'] is double)
              ? json['latitude']
              : double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude:
          (json['longitude'] is double)
              ? json['longitude']
              : double.tryParse(json['longitude'].toString()) ?? 0.0,
      isMainAddress:
          (json['main_address'] == '1' ||
              json['main_address'] == 1 ||
              json['main_address'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'main_address': isMainAddress ? 1 : 0,
    };
  }
}
