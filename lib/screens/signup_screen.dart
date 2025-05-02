import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../services/auth_service.dart';
import '../components/alertdialog.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isLoading = false;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String retypePassword = _retypePasswordController.text;
      String phoneNumber = _phoneNumberController.text;

      if (password != retypePassword) {
        setState(() => isLoading = false);
        _showAlert('Peringatan', 'Password tidak cocok', 'OK', () {
          Navigator.of(context).pop();
        });
        return;
      }

      final response = await register(name, email, phoneNumber, password);

      if (response['status'] == 'success') {
        // Jika berhasil
        _showAlert('Sukses', response['message'], 'OK', () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        });
      } else {
        // Jika gagal
        _showAlert('Error', response['message'], 'OK', () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  void _showAlert(
    String title,
    String message,
    String confirmText,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomAlert(
          title: title,
          message: message,
          confirmText: confirmText,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Color(0xFF1E1F38),
                borderRadius: const BorderRadius.only(
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
                          "Daftar Akun",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Silakan daftar untuk memulai.",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: "Nama",
                      hintText: "Masukan nama anda",
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Email",
                      hintText: "example@gmail.com",
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email harus diisi';
                        }
                        if (!RegExp(
                          r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                        ).hasMatch(value)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Nomor Telepon",
                      hintText: "08xxxxxxxxxx",
                      controller: _phoneNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon harus diisi';
                        }
                        if (!RegExp(r'^08\d{8,11}$').hasMatch(value)) {
                          return 'Format nomor telepon tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Password",
                      hintText: "Kata sandi",
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password harus diisi';
                        }
                        if (value.length < 8) {
                          return 'Password minimal 8 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Tulis ulang Password",
                      hintText: "Konfirmasi kata sandi",
                      isPassword: true,
                      controller: _retypePasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password harus diisi';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 35),
                    CustomButton(
                      text: "Sign Up",
                      onPressed: _signUp,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
