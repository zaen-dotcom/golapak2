import 'package:flutter/material.dart';
import '../components/text_field.dart';
import '../components/button.dart';
import '../theme/colors.dart';
import '../components/alertdialog.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String email;

  const VerifyOTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isButtonLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
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
            onConfirm: () => Navigator.pop(context),
          ),
    );
  }

  void _handleVerify() async {
    if (isButtonLoading) return;

    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();

    if (otp.isEmpty || password.isEmpty) {
      _showAlert("Peringatan", "OTP dan sandi baru tidak boleh kosong.");
      return;
    }

    if (password.length < 8) {
      _showAlert("Peringatan", "Sandi baru harus minimal 8 karakter.");
      return;
    }

    setState(() {
      isButtonLoading = true;
    });

    final result = await verifyResetPassword(
      email: widget.email,
      kodeOtp: otp,
      newPassword: password,
    );

    if (result['status'] == 'success') {
      _showAlert("Berhasil", result['message']).then((_) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      });
    } else {
      _showAlert("Gagal", result['message']);
    }

    setState(() {
      isButtonLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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
                          "Verifikasi OTP",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Masukkan kode OTP yang telah dikirim ke email Anda.",
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

            // Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: TextEditingController(text: widget.email),
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "example@gmail.com",
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Kode OTP",
                    hintText: "123456",
                    isPassword: false,
                    controller: _otpController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Sandi Baru",
                    hintText: "●●●●●●●●",
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: "VERIFIKASI",
                    onPressed: isButtonLoading ? null : _handleVerify,
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
