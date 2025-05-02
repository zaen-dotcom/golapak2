import 'dart:ui';
import 'package:flutter/gestures.dart'; // Tambahkan import ini
import 'package:flutter/material.dart';
import 'package:golapak2/theme/colors.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import 'signup_screen.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1F38),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 50),
                  Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Silakan masuk ke akun Anda yang sudah ada.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Email
                  const CustomTextField(
                    label: "Email",
                    hintText: "example@gmail.com",
                  ),

                  const SizedBox(height: 20),

                  const CustomTextField(
                    label: "Password",
                    hintText: "●●●●●●●●",
                    isPassword: true,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (value) {}),
                          const Text("Ingat saya"),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Lupa Sandi",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.link),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => ForgotPasswordScreen(),
                                      transitionsBuilder: (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return Stack(
                                          children: [
                                            // Layer Blur
                                            BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 10.0,
                                                sigmaY: 10.0,
                                              ),
                                              child: Container(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                              ),
                                            ),

                                            SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(
                                                  1.0,
                                                  0.0,
                                                ), // Dari kanan ke kiri
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                    text: "LOG IN",
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/main',
                        (route) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Belum memiliki akun?  ",
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: "Daftar",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: AppColors.link),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    print("Teks 'Daftar' ditekan");
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => const SignUpScreen(),
                                        transitionsBuilder: (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return Stack(
                                            children: [
                                              // Layer Blur
                                              BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 10.0,
                                                  sigmaY: 10.0,
                                                ),
                                                child: Container(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                ),
                                              ),

                                              SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
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
