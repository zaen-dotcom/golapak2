import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../../theme/colors.dart';
import '../../../services/gemini_service.dart';
import '../../../models/ai_model.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with TickerProviderStateMixin {
  late final GeminiService _deepSeekService;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _deepSeekService = GeminiService(
      apiKey: 'AIzaSyCS7DvYPoeZazCUx-Kl12UAs_WazYm7Hb0',
    );

    _waveController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOutSine),
    );

    _addMessage(
      message:
          "Halo! Saya AI Assistant Golapak. Ada yang bisa saya bantu?\n\n⚠️ Catatan: Chat ini tidak disimpan dan akan hilang ketika Anda keluar dari halaman ini.",
      isUser: false,
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    for (final msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }

  void _addMessage({required String message, required bool isUser}) {
    final msg = ChatMessage(
      text: message,
      isUser: isUser,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    setState(() {
      _messages.add(msg);
    });

    msg.animationController.forward().then((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 50), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final message = _textController.text;
    _textController.clear();

    _addMessage(message: message, isUser: true);

    setState(() => _isLoading = true);

    try {
      final response = await _deepSeekService.sendChat(chatHistory: _messages);
      _addMessage(message: response, isUser: false);
    } catch (e) {
      _addMessage(
        message: "Maaf, terjadi kesalahan: ${e.toString()}",
        isUser: false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Golapak AI Assistant',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: AppColors.lightGreyBlue,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: WaveBackgroundPainter(_waveAnimation.value),
                );
              },
            ),
          ),
          Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder:
                        (context, index) => _buildMessage(_messages[index]),
                  ),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              _buildInputField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: message.animationController,
        curve: Curves.easeOut,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment:
              message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!message.isUser)
              CircleAvatar(
                backgroundColor: AppColors.lightGreyBlue,
                child: const Icon(Icons.smart_toy, color: Colors.black),
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      message.isUser
                          ? AppColors.primary
                          : AppColors.lightGreyBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isUser ? 16 : 0),
                    bottomRight: Radius.circular(message.isUser ? 0 : 16),
                  ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.isUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            if (message.isUser) const SizedBox(width: 8),
            if (message.isUser)
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.person, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintText: 'Tulis pesan...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: AppColors.primary,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveBackgroundPainter extends CustomPainter {
  final double animationValue;

  WaveBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue.withOpacity(0.2)
          ..strokeWidth = 3
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(0, size.height * 0.5)
          ..quadraticBezierTo(
            size.width * 0.25,
            size.height * (0.5 + 0.1 * (animationValue - 0.5)),
            size.width * 0.5,
            size.height * 0.5,
          )
          ..quadraticBezierTo(
            size.width * 0.75,
            size.height * (0.5 - 0.1 * (animationValue - 0.5)),
            size.width,
            size.height * 0.5,
          )
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
