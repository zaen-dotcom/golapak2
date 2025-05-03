import 'package:flutter/material.dart';

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      height: 180, // Sesuaikan tinggi sesuai kebutuhan
      decoration: BoxDecoration(
        color: Colors.grey[400], // Warna untuk placeholder
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          "Banner Placeholder",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
