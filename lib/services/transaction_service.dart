import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';
import 'api_config.dart';
import '../models/order_model.dart';
import 'package:flutter/foundation.dart';
import '../models/shipping_model.dart';

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

List<Order> _parseOrders(String responseBody) {
  final parsed = json.decode(responseBody)['data'] as List<dynamic>;
  return parsed.map((json) => Order.fromJson(json)).toList();
}

Future<List<Order>?> fetchTransactionProgress() async {
  final url = Uri.parse('${ApiConfig.baseUrl}/transaction-progress');

  try {
    final token = await TokenManager.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return compute(_parseOrders, response.body);
    } else {
      print(
        'fetchTransactionProgress failed with status: ${response.statusCode}',
      );
    }
  } catch (e) {
    print('fetchTransactionProgress error: $e');
  }

  return null;
}

Future<List<ShippingTransactionModel>> fetchShippingTransactions() async {
  final token = await TokenManager.getToken();
  final url = Uri.parse('${ApiConfig.baseUrl}/transaction-shipping');

  final response = await http.get(
    url,
    headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData['status'] == 'success') {
      List data = jsonData['data'];
      return data
          .map((item) => ShippingTransactionModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Gagal mengambil data pengiriman');
    }
  } else {
    throw Exception('Server error: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> cancelTransaction(int transactionId) async {
  final token = await TokenManager.getToken(); 
  final url = Uri.parse('${ApiConfig.baseUrl}/transaction-cancel');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'id': transactionId}),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return {
      'status': 'error',
      'message': 'Gagal membatalkan pesanan',
    };
  }
}
