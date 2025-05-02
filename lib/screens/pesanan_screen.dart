import 'package:flutter/material.dart';

class PesananScreen extends StatelessWidget {
  const PesananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Ini Pesanan',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
