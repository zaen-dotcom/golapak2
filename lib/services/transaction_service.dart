import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';
import 'api_config.dart';

Future<Map<String, dynamic>> createOrder({
  required List<Map<String, dynamic>> menu,
  required int addressId,
  required String paymentMethod,
  String? accountNumber, 
}) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/transaction-create');
  final token = await TokenManager.getToken();

  if (token == null) {
    return {
      'status': 'error',
      'message': 'Token tidak tersedia. Silakan login ulang.',
    };
  }

  try {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = {
      'menu': menu,
      'address_id': addressId,
      'payment_method': paymentMethod,
      if (accountNumber != null) 'account_number': accountNumber,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {
        'status': 'error',
        'message': 'Gagal membuat pesanan',
        'code': response.statusCode,
        'body': jsonDecode(response.body),
      };
    }
  } catch (e) {
    return {
      'status': 'error',
      'message': 'Terjadi kesalahan saat mengirim permintaan',
      'error': e.toString(),
    };
  }
}

Future<Map<String, dynamic>?> calculateTransaction(
  List<Map<String, dynamic>> menuList,
) async {
  final token = await TokenManager.getToken();

  if (token == null) {
    print('Token tidak ditemukan, user mungkin belum login');
    return null;
  }

  final url = Uri.parse('${ApiConfig.baseUrl}/transaction-calculate');

  final body = {'menu': menuList};
  final encodedBody = jsonEncode(body);

  try {
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: encodedBody,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      } else {
        print('Error dari server: ${data['message']}');
        return null;
      }
    } else {
      print('Request gagal dengan status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception saat request: $e');
    return null;
  }
}
