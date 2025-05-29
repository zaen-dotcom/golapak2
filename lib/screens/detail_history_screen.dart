import 'package:flutter/material.dart';
import '../components/box_container.dart';
import '../components/menuitem.dart';
import '../screens/profile/hubungikami.dart';

class DetailHistoryScreen extends StatelessWidget {
  const DetailHistoryScreen({super.key});

  void _navigateToContactSeller(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ContactUsScreen()));
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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WhiteBoxContainer(
              child: Text(
                'Alamat Pengiriman:\nJl. Contoh Alamat No.123, Jakarta',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const WhiteBoxContainer(
              child: Text(
                'Detail Produk:\n- Produk A x2\n- Produk B x1\n- Produk C x3',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const WhiteBoxContainer(
              child: Text(
                'Detail Transaksi:\nTotal Harga: Rp 150.000\nStatus: Sukses\nTanggal: 2025-05-22 14:30',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Butuh Bantuan?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
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
      ),
    );
  }
}
