import 'dart:ui';
import 'package:flutter/material.dart';
import '../components/text_field.dart';
import '../components/button.dart';
import '../theme/colors.dart';
import 'verifyotp_screen.dart';
import '../components/alertdialog.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isButtonLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _showAlert(String title, String message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => CustomAlert(
            title: title,
            message: message,
            confirmText: "OK",
            onConfirm: () => Navigator.of(context).pop(),
          ),
    );
  }

  void _handleSendOtp() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showAlert("Peringatan", "Email tidak boleh kosong");
      return;
    }

    if (isButtonLoading) return; // Cegah klik ganda

    setState(() {
      isButtonLoading = true;
    });

    final result = await sendResetPassword(email);

    if (result['status'] == 'success') {
      _showAlert("Berhasil", result['message']).then((_) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    VerifyOTPScreen(email: email),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(color: Colors.black.withOpacity(0.1)),
                  ),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                ],
              );
            },
          ),
        );
        setState(() {
          isButtonLoading = false;
        });
      });
    } else {
      _showAlert("Gagal", result['message']);
      setState(() {
        isButtonLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1F38),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              height: 200,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Reset Sandi",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Masukkan email Anda untuk menerima tautan reset sandi.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "EMAIL",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    label: "Email",
                    hintText: "example@gmail.com",
                    isPassword: false,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: "KIRIM OTP",
                    onPressed: isButtonLoading ? null : _handleSendOtp,
                    isLoading: isButtonLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
