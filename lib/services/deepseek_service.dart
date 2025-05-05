import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_model.dart';

class DeepSeekService {
  static const String _baseUrl = 'https://api.deepseek.com';
  final String apiKey;

  DeepSeekService({required this.apiKey});

  Future<String> sendChat({
    required List<ChatMessage> chatHistory,
    String model = 'deepseek-chat',
    bool stream = false,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': 'You are a helpful assistant for Golapak marketplace.',
        },
        ...chatHistory.map((msg) => msg.toApiMessage()),
      ];

      final response = await http
          .post(
            Uri.parse('$_baseUrl/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode({
              'model': model,
              'messages': messages,
              'stream': stream,
            }),
          )
          .timeout(timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data['choices'][0]['message']['content'];
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
