import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/user_model.dart';
import '../utils/token_manager.dart';

Future<UserModel?> getUser() async {
  final token = await TokenManager.getToken();
  if (token == null) {
    print('Token tidak ditemukan');
    return null;
  }

  final url = Uri.parse('${ApiConfig.baseUrl}/user');

  try {
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'success') {
        return UserModel.fromJson(jsonResponse['data']);
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return null;
}

Future<Map<String, dynamic>?> addAddress({
  required int userId,
  required String name,
  required String phoneNumber,
  required String address,
  required double latitude,
  required double longitude,
  required bool isMainAddress,
}) async {
  final token = await TokenManager.getToken();
  if (token == null) return null;

  final url = Uri.parse('${ApiConfig.baseUrl}/add-address');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_id': userId,
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'main_address': isMainAddress,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return {
        'status': jsonResponse['status'],
        'message': jsonResponse['message'],
      };
    } else {
      final errorResponse = json.decode(response.body);
      print('Error ${response.statusCode}: ${errorResponse['message']}');
    }
  } catch (e) {
    print('Request failed: $e');
  }

  return null;
}

Future<List<Map<String, dynamic>>> getAddress(int userId) async {
  final token = await TokenManager.getToken();

  if (token == null) {
    print('Token tidak ditemukan');
    return [];
  }

  final url = Uri.parse('${ApiConfig.baseUrl}/get-address/$userId');

  try {
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'success') {
        final List<dynamic> data = jsonResponse['data'];
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Gagal mendapatkan data alamat: ${jsonResponse['status']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error saat mengambil alamat: $e');
  }

  return [];
}

Future<bool> updateAddress(Map<String, dynamic> data) async {
  final token = await TokenManager.getToken();

  if (token == null) {
    print('Token tidak ditemukan');
    return false;
  }

  final Uri url = Uri.parse('${ApiConfig.baseUrl}/update-address');

  try {
    print('Data yang dikirim ke server:');
    print(jsonEncode(data));

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['status'] == 'success';
    } else {
      print('Gagal update: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error saat update alamat: $e');
    return false;
  }
}

Future<void> deleteAddress(int addressId) async {
  final token = await TokenManager.getToken();

  if (token == null) {
    throw Exception('Token tidak ditemukan, silakan login terlebih dahulu.');
  }

  final url = Uri.parse('${ApiConfig.baseUrl}/delete-address/$addressId');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] != 'success') {
        throw Exception(data['message'] ?? 'Gagal menghapus alamat.');
      }
    } else {
      throw Exception(
        'Gagal menghapus alamat. Status code: ${response.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Terjadi kesalahan saat menghapus alamat: $e');
  }
}
