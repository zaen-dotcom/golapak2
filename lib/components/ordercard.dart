import 'package:flutter/material.dart';
import '../theme/colors.dart';

class OrderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String orderId;
  final String? statusText;
  final Color? statusColor;
  final Widget? actions;
  final String? imageUrl; // URL atau path gambar (bisa dari asset atau network)

  const OrderCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.orderId,
    this.statusText,
    this.statusColor,
    this.actions,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Gambar pesanan
              if (imageUrl != null)
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: AssetImage(imageUrl!), // Kalau pakai asset
                      // image: NetworkImage(imageUrl!), // Kalau pakai network
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              // Judul dan nomor order
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.blueGreyText,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '#$orderId',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.blueGreyText,
                ),
              ),
            ],
          ),
          if (statusText != null && statusColor != null) ...[
            const SizedBox(height: 6),
            Text(
              statusText!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: statusColor!,
              ),
            ),
          ],
          if (actions != null) ...[
            const SizedBox(height: 16),
            actions!,
          ],
        ],
      ),
    );
  }
}
