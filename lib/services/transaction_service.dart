import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';
import 'api_config.dart';

Future<Map<String, dynamic>> createOrder({
  required List<Map<String, dynamic>> menuItems,
  required int addressId,
}) async {
  final url = '${ApiConfig.baseUrl}/transaction-create';

  try {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Pengguna belum login.');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'menu': menuItems, 'address_id': addressId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return {
          'success': true,
          'transaction_id': data['data']['transaction_id'],
          'transaction_code': data['data']['transaction_code'],
        };
      } else {
        return {'success': false, 'message': data['message']};
      }
    } else {
      final error = json.decode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Gagal membuat pesanan',
      };
    }
  } catch (e) {
    return {'success': false, 'message': 'Terjadi kesalahan: $e'};
  }
}

Future<Map<String, dynamic>> calculateCartTotal(
  List<Map<String, dynamic>> cartItems,
) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/transaction-calculate');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'menu': cartItems}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      return data['data'];
    } else {
      throw Exception(data['message'] ?? 'Calculate failed');
    }
  } else {
    throw Exception(
      'Failed to calculate cart total. Status code: ${response.statusCode}',
    );
  }
}
