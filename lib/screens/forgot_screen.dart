import 'package:flutter/material.dart';
import '../components/text_field.dart';
import '../components/button.dart';
import '../theme/colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Panel Header
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
                        const Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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

            // Input & Tombol
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Email
                  const Text(
                    "EMAIL",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Input Email
                  CustomTextField(
                    label: "Email",
                    hintText: "example@gmail.com",
                    isPassword: false,
                    controller: _emailController,
                  ),

                  const SizedBox(height: 24),

                  // Tombol Send Code
                  CustomButton(
                    text: "SEND CODE",
                    onPressed: () {
                      String email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        print("Kode reset dikirim ke: $email");
                      } else {
                        print("Email tidak boleh kosong");
                      }
                    },
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
