import 'package:flutter/material.dart';
import '../components/box_container.dart';
import '../components/menuitem.dart';
import '../screens/profile/hubungikami.dart';
import '../models/orderdetail_model.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<OrderDetail> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = OrderDetail.fetchOrderDetail(widget.orderId);
  }

  void _navigateToContactSeller(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactUsScreen()));
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
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               WhiteBoxContainer(
  child: Text(
    'Alamat Pengiriman:\n'
    '${data.shipping.name}\n'
    '${data.shipping.phoneNumber}\n'
    '${data.shipping.address}',
    style: const TextStyle(fontSize: 16),
  ),
),
WhiteBoxContainer(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Detail Produk:', style: TextStyle(fontSize: 16)),
      const SizedBox(height: 8),
      ...data.items.map((item) => Text(
        '- ${item.name} (x${item.qty}) = Rp ${item.mainSubtotal}',
        style: const TextStyle(fontSize: 16),
      )),
    ],
  ),
),
WhiteBoxContainer(
  child: Text(
    'Detail Transaksi:\n'
    'Total Biaya Produk: Rp ${data.totalMainCost}\n'
    'Ongkos Kirim: Rp ${data.deliveryFee}\n'
    'Grand Total: Rp ${data.grandTotal}\n'
    'Status: ${data.status}\n'
     'Tanggal: ${DateFormat('dd MMM yyyy HH:mm').format(data.date)}',
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
