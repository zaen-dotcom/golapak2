import 'package:flutter/material.dart';

class OrderHistoryCard extends StatelessWidget {
  final String transactionCode;
  final int totalQty;
  final int grandTotal;
  final String date;
  final String status;
  final Widget? cancelButton;

  const OrderHistoryCard({
    super.key,
    required this.transactionCode,
    required this.totalQty,
    required this.grandTotal,
    required this.date,
    required this.status,
    this.cancelButton,
  });

  String _formatCurrency(int amount) {
    final str = amount.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (match) => '.');
  }

  String _formatDate(String datetime) {
    final dt = DateTime.parse(datetime);
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFC107);
      case 'cooking':
        return const Color(0xFFFF7043);
      case 'on delivery':
        return const Color(0xFF42A5F5);
      case 'done':
        return const Color(0xFF4CAF50);
      case 'canceled':
        return const Color(0xFFE57373);
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction Code
          Text(
            transactionCode,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$totalQty item${totalQty > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(date),
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Total Price row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Text(
                'Rp ${_formatCurrency(grandTotal)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.8,
              ),
            ),
          ),

          // Cancel button area
          if (cancelButton != null) ...[
            const SizedBox(height: 16),
            Align(alignment: Alignment.centerRight, child: cancelButton!),
          ],
        ],
      ),
    );
  }
}
