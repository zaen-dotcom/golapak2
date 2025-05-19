import 'package:flutter/material.dart';
import '../components/orderitemtile.dart';
import '../components/pricesummaryorder.dart';
import '../theme/colors.dart';

class OrderDetailPage extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailPage({super.key, required this.orderData});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Map<String, dynamic> orderData;

  @override
  void initState() {
    super.initState();
    orderData = widget.orderData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Order"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Gambar & Nama Restoran
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    orderData['imageUrl'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  orderData['restaurant_name'],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "${orderData['transaction_code']} • ${orderData['date']}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section: Daftar Pesanan
            const Text(
              "Pesanan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            ...List.generate((orderData['items_detail'] ?? []).length, (index) {
              final item = orderData['items_detail'][index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: OrderItemTile(
                  name: item['name'],
                  qty: item['qty'],
                  price: item['price'],
                ),
              );
            }),

            const Divider(height: 32, thickness: 1.2),

            // Ringkasan Harga
            const Text(
              "Ringkasan Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            PriceSummaryRow(label: "Subtotal", amount: orderData['subtotal']),
            PriceSummaryRow(label: "Ongkir", amount: orderData['delivery_fee']),
            const SizedBox(height: 6),
            PriceSummaryRow(
              label: "Total Bayar",
              amount: orderData['grand_total'],
              isTotal: true,
            ),

            const Divider(height: 32, thickness: 1.2),

            // Informasi Tambahan
            Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.grey),
                const SizedBox(width: 8),
                Text("Tipe Order: ${orderData['order_type'] ?? 'Delivery'}"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.pending_actions, color: Colors.grey),
                const SizedBox(width: 8),
                Text("Status: ${orderData['status']}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
