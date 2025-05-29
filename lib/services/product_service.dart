import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../utils/token_manager.dart';
import 'api_config.dart';

Future<List<ProductModel>> fetchMakanan() async {
  return _fetchProduk('/menu/makanan');
}

Future<List<ProductModel>> fetchMinuman() async {
  return _fetchProduk('/menu/minuman');
}

Future<List<ProductModel>> _fetchProduk(String endpoint) async {
  final url = '${ApiConfig.baseUrl}$endpoint';

  try {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan. Pengguna belum login.');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // penting!
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (response.body.startsWith('<!DOCTYPE html>')) {
        throw Exception('401'); // respons HTML, berarti token salah
      }

      final decoded = json.decode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('401');
    } else {
      throw Exception('Gagal mengambil data produk: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Kesalahan saat mengambil data: $e');
  }
}
