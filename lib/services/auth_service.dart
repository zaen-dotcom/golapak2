import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

Future<Map<String, dynamic>> register(
  String name,
  String email,
  String phoneNumber,
  String password,
) async {
  final String url = "${ApiConfig.baseUrl}/register";
  final Map<String, String> registrationData = {
    'name': name,
    'email': email,
    'phone_number': phoneNumber,
    'password': password,
  };
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(registrationData),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'status': 'success',
        'message': responseData['message'],
        'data': responseData['data'],
      };
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'status': 'error',
        'message':
            responseData['message'] ?? 'Terjadi kesalahan saat registrasi',
      };
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Gagal menghubungi server: $e'};
  }
}

Future<Map<String, dynamic>> sendResetPassword(String email) async {
  final String url = "${ApiConfig.baseUrl}/send-reset-password";
  final Map<String, String> resetData = {'email': email};
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(resetData),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {'status': 'success', 'message': responseData['message']};
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'status': 'error',
        'message':
            responseData['message'] ??
            'Terjadi kesalahan saat mengirimkan email',
      };
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Gagal menghubungi server: $e'};
  }
}

Future<Map<String, dynamic>> verifyResetPassword({
  required String email,
  required String kodeOtp,
  required String newPassword,
}) async {
  final String url = "${ApiConfig.baseUrl}/verify-reset-password";
  final Map<String, String> requestData = {
    'email': email,
    'kode_otp': kodeOtp,
    'new_password': newPassword,
  };
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return {'status': 'success', 'message': responseData['message']};
    } else {
      return {
        'status': 'error',
        'message':
            responseData['message'] ?? 'Terjadi kesalahan saat verifikasi OTP',
      };
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Gagal menghubungi server: $e'};
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  final String url = "${ApiConfig.baseUrl}/login";
  final Map<String, String> loginData = {'email': email, 'password': password};
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(loginData),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'status': 'success',
        'message': responseData['message'],
        'access_token': responseData['data']['access_token'],
        'token_type': responseData['data']['token_type'],
      };
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String errorMsg = responseData['message']?.toLowerCase() ?? '';
      if (errorMsg.contains('validation') || response.statusCode == 422) {
        return {'status': 'error', 'message': 'Username atau password salah'};
      }
      return {
        'status': 'error',
        'message': responseData['message'] ?? 'Terjadi kesalahan saat login',
      };
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Gagal menghubungi server: $e'};
  }
}
