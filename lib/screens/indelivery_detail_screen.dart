import 'package:flutter/material.dart';
import '../../components/box_container.dart';
import '../../components/menuitem.dart';
import '../../screens/profile/hubungikami.dart';
import '../../models/orderdetail_model.dart';
import 'package:intl/intl.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final String orderId;
  const DeliveryDetailScreen({super.key, required this.orderId});

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  late Future<OrderDetail> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = OrderDetail.fetchOrderDetail(widget.orderId);
  }

  void _navigateToContactSeller(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ContactUsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<OrderDetail>(
        future: futureOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final order = snapshot.data!;
          final shipping = order.shipping;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Alamat Pengiriman
                WhiteBoxContainer(
                  child: Text(
                    'Alamat Pengiriman:\n${shipping.name}\n${shipping.phoneNumber}\n${shipping.address}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 12),

                // Detail Produk
                WhiteBoxContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Detail Produk:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      ...order.items.map((item) => Text('- ${item.name} x${item.qty}')).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Detail Transaksi
                WhiteBoxContainer(
                  child: Text(
                    'Detail Transaksi:\n'
                    'Kode Transaksi: ${order.transactionCode}\n'
                    'Total Item: ${order.totalQty}\n'
                    'Total Harga: Rp ${order.totalMainCost}\n'
                    'Ongkir: Rp ${order.deliveryFee}\n'
                    'Grand Total: Rp ${order.grandTotal}\n'
                    'Status: ${order.status}\n'
                    'Tanggal: ${DateFormat('dd MMM yyyy HH:mm').format(order.date)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 16),
                const Text('Butuh Bantuan?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                WhiteBoxContainer(
                  child: MenuItem(
                    icon: Icons.support_agent_rounded,
                    text: 'Hubungi Penjual',
                    iconColor: Colors.blue,
                    onTap: () => _navigateToContactSeller(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
