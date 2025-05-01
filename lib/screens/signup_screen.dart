import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/text_field.dart';

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

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      print("Nama: \${_nameController.text}");
      print("Email: \${_emailController.text}");
      print("Password: \${_passwordController.text}");
    }
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
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Email",
                      hintText: "example@gmail.com",
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Password",
                      hintText: "Kata sandi",
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "Tulis ulang Password",
                      hintText: "Konfirmasi kata sandi",
                      isPassword: true,
                      controller: _retypePasswordController,
                    ),
                    const SizedBox(height: 35),
                    CustomButton(text: "SIGN UP", onPressed: _signUp),
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
