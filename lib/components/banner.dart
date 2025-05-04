import 'package:flutter/material.dart';

class BannerPlaceholder extends StatelessWidget {
  final String imageUrl;

  const BannerPlaceholder({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAsset = !imageUrl.startsWith('http');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:
            isAsset
                ? Image.asset(imageUrl, fit: BoxFit.cover)
                : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image));
                  },
                ),
      ),
    );
  }
}
