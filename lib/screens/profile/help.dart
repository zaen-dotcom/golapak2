import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../components/chatbubble.dart';
import '../profile/chat/data_chat.dart';
import '../profile/chat/kat_produk.dart';
import '../profile/chat/kat_pengiriman.dart';
import '../profile/chat/kat_pembayaran.dart';
import '../profile/chat/kat_pengguna.dart';
import '../profile/chat/kat_bantuan.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Widget> chatWidgets = [
    const ChatBubble(
      message: 'Halo Kak, ada yang bisa kami bantu?',
      isUserMessage: false,
    ),
  ];

  bool showProductQuestions = false;
  bool showPengirimanQuestions = false;
  bool showPembayaranQuestions = false;
  bool showAkunPenggunaQuestions = false;
  bool showBantuanQuestions = false;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  void _insertChatBubble(Widget chatBubble) {
    chatWidgets.add(chatBubble);
    if (_listKey.currentState != null) {
      _listKey.currentState?.insertItem(chatWidgets.length - 1);
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _backToCategories() {
    setState(() {
      showProductQuestions = false;
      showPengirimanQuestions = false;
      showPembayaranQuestions = false;
      showAkunPenggunaQuestions = false;
      showBantuanQuestions = false;
    });


    _insertChatBubble(
      const ChatBubble(
        message: 'Kembali ke daftar kategori',
        isUserMessage: true,
      ),
    );


    Future.delayed(const Duration(seconds: 1), () {
      _insertChatBubble(
        const ChatBubble(
          message: 'Silakan pilih kategori pertanyaan',
          isUserMessage: false,
        ),
      );
    });
  }

  void handleCategoryTap(String category) {
    setState(() {
      showProductQuestions = false;
      showPengirimanQuestions = false;
      showPembayaranQuestions = false;
      showAkunPenggunaQuestions = false;
      showBantuanQuestions = false;

      _insertChatBubble(ChatBubble(message: category, isUserMessage: true));

      Future.delayed(const Duration(seconds: 1), () {
        if (category == 'Produk') {
          _insertChatBubble(
            ChatBubble(
              message: categoryWelcomeMessages[0],
              isUserMessage: false,
            ),
          );
          setState(() {
            showProductQuestions = true;
          });
        } else if (category == 'Pengiriman') {
          _insertChatBubble(
            ChatBubble(
              message: categoryWelcomeMessages[1],
              isUserMessage: false,
            ),
          );
          setState(() {
            showPengirimanQuestions = true;
          });
        } else if (category == 'Pembayaran') {
          _insertChatBubble(
            ChatBubble(
              message: categoryWelcomeMessages[2],
              isUserMessage: false,
            ),
          );
          setState(() {
            showPembayaranQuestions = true;
          });
        } else if (category == 'Akun Pengguna') {
          _insertChatBubble(
            ChatBubble(
              message: categoryWelcomeMessages[3],
              isUserMessage: false,
            ),
          );
          setState(() {
            showAkunPenggunaQuestions = true;
          });
        } else if (category == 'Bantuan/Support') {
          _insertChatBubble(
            ChatBubble(
              message: categoryWelcomeMessages[4],
              isUserMessage: false,
            ),
          );
          setState(() {
            showBantuanQuestions = true;
          });
        }
      });
    });
  }

  void handleQuestionTap(String question, String answer) {
    setState(() {
      _insertChatBubble(ChatBubble(message: question, isUserMessage: true));

      Future.delayed(const Duration(seconds: 1), () {
        _insertChatBubble(ChatBubble(message: answer, isUserMessage: false));
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Golapak Assistant',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedList(
                      key: _listKey,
                      controller: _scrollController,
                      initialItemCount: chatWidgets.length,
                      itemBuilder: (context, index, animation) {
                        final chatBubble = chatWidgets[index] as ChatBubble;
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin:
                                chatBubble.isUserMessage
                                    ? const Offset(1, 0)
                                    : const Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              children: [
                                chatWidgets[index],
                                if (index == chatWidgets.length - 1 &&
                                    !chatBubble.isUserMessage)
                                  _buildOptionsList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (!showProductQuestions &&
              !showPengirimanQuestions &&
              !showPembayaranQuestions &&
              !showAkunPenggunaQuestions &&
              !showBantuanQuestions)
            ...chatCategories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        foregroundColor: AppColors.secondary,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () => handleCategoryTap(category),
                      child: Text(category),
                    ),
                  ),
                ),
              );
            }).toList(),


          if (showProductQuestions) ...[
            ...produkChat.map((qa) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        foregroundColor: AppColors.secondary,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed:
                          () =>
                              handleQuestionTap(qa['question']!, qa['answer']!),
                      child: Text(qa['question']!),
                    ),
                  ),
                ),
              );
            }).toList(),
            _buildBackButton(), 
          ],

          if (showPengirimanQuestions) ...[
            ...pengirimanChat.map((qa) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        foregroundColor: AppColors.secondary,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed:
                          () =>
                              handleQuestionTap(qa['question']!, qa['answer']!),
                      child: Text(qa['question']!),
                    ),
                  ),
                ),
              );
            }).toList(),
            _buildBackButton(), 
          ],

          if (showPembayaranQuestions) ...[
            ...pembayaranChat.map((qa) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        foregroundColor: AppColors.secondary,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed:
                          () =>
                              handleQuestionTap(qa['question']!, qa['answer']!),
                      child: Text(qa['question']!),
                    ),
                  ),
                ),
              );
            }).toList(),
            _buildBackButton(), 
          ],

          if (showAkunPenggunaQuestions) ...[
            ...akunPenggunaChat.map((qa) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        foregroundColor: AppColors.secondary,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed:
                          () =>
                              handleQuestionTap(qa['question']!, qa['answer']!),
                      child: Text(qa['question']!),
                    ),
                  ),
                ),
              );
            }).toList(),
            _buildBackButton(),
          ],

          if (showBantuanQuestions) ...[
            ...bantuanSupportChat.map((qa) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        foregroundColor: AppColors.secondary,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed:
                          () =>
                              handleQuestionTap(qa['question']!, qa['answer']!),
                      child: Text(qa['question']!),
                    ),
                  ),
                ),
              );
            }).toList(),
            _buildBackButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            foregroundColor: AppColors.secondary,
            textStyle: const TextStyle(fontSize: 16),
          ),
          onPressed: _backToCategories, 
          child: const Text('Kembali ke Pertanyaan Lainnya'),
        ),
      ),
    );
  }
}
