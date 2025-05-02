import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.validator, // Tambahkan validator
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          validator: widget.validator, // Pakai validator di sini
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: _togglePasswordVisibility,
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
