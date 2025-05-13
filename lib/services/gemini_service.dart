import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_model.dart';

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  final String apiKey;

  GeminiService({required this.apiKey});

  Future<String> sendChat({
    required List<ChatMessage> chatHistory,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {

      final parts = chatHistory.map((msg) => {'text': msg.text}).toList();

      final body = {
        'contents': [
          {'parts': parts},
        ],
      };

      final response = await http
          .post(
            Uri.parse('$_baseUrl?key=$apiKey'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception(data['error']?['message'] ?? 'Unknown error');
      }
    } on TimeoutException {
      throw Exception('Request timeout');
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }
}
