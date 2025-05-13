import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:golapak2/theme/colors.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import 'signup_screen.dart';
import 'forgot_screen.dart';
import '../services/auth_service.dart';
import '../components/alertdialog.dart';
import '../utils/token_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => isLoading = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlert(
            title: 'Gagal',
            message: 'Email dan Password tidak boleh kosong.',
            confirmText: 'OK',
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      return;
    }

    final response = await login(email, password);
    setState(() => isLoading = false);

    if (response['status'] == 'success') {
      // Simpan token langsung tanpa perlu checkbox
      await TokenManager.saveToken(response['access_token']);

      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CustomAlert(
            title: 'Gagal',
            message: response['message'] ?? 'Email atau password salah.',
            confirmText: 'OK',
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

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
                  CustomTextField(
                    label: "Email",
                    hintText: "example@gmail.com",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Password",
                    hintText: "●●●●●●●●",
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: "Lupa Sandi",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: AppColors.link),
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
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomButton(
                    text: "LOG IN",
                    onPressed: isLoading ? null : _handleLogin,
                    isLoading: isLoading,
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
