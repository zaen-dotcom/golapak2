import 'package:flutter/material.dart';
import '../../components/button.dart'; // Import CustomButton
import '../../components/cardproduct.dart'; // Import CardProduct widget

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Keranjang Belanja',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Daftar produk di keranjang
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Misalnya ada 5 produk di keranjang
                itemBuilder: (context, index) {
                  return CardProduct(
                    title: 'Pizza Calzone',
                    price: 'Rp. 64,000',
                    imageUrl: 'https://via.placeholder.com/150',
                    quantity: 2,
                    onIncrement: () {
                      // Implement aksi untuk menambah kuantitas
                    },
                    onDecrement: () {
                      // Implement aksi untuk mengurangi kuantitas
                    },
                  );
                },
              ),
            ),
            // Bagian Alamat Pengiriman
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '2118 Thornridge Cir. Syracuse',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      // Aksi edit alamat
                    },
                    child: Text('EDIT'),
                  ),
                ],
              ),
            ),
            // Bagian Total Harga
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp. 128,000',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Ganti ElevatedButton dengan CustomButton
            CustomButton(
              text: 'PLACE ORDER',
              onPressed: () {
                // Aksi untuk melakukan pemesanan
              },
            ),
          ],
        ),
      ),
    );
  }
}
