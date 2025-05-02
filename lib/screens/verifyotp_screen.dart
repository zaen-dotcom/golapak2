import 'package:flutter/material.dart';
import '../components/text_field.dart';
import '../components/button.dart';
import '../theme/colors.dart';
import '../components/alertdialog.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String email;

  const VerifyOTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();
    if (otp.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => CustomAlert(
              title: "Peringatan",
              message: "OTP dan sandi baru tidak boleh kosong.",
              confirmText: "OK",
              onConfirm: () => Navigator.pop(context),
            ),
      );

      return;
    }
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
                  // Email TextField yang hanya untuk tampilan, tidak bisa diedit
                  TextField(
                    controller: TextEditingController(text: widget.email),
                    enabled: false, // Membuat textfield tidak bisa diedit
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
                  CustomButton(text: "VERIFIKASI", onPressed: _handleVerify),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
