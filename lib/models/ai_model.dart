import 'package:flutter/animation.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final AnimationController animationController;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.animationController,
  });

  Map<String, dynamic> toApiMessage() {
    return {'role': isUser ? 'user' : 'assistant', 'content': text};
  }
}
