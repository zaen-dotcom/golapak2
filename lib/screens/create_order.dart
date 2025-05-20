import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/addresscard.dart'; // Pastikan path yang sesuai
import '../components/card_cartproduct.dart'; // Pastikan path yang sesuai

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  // Variabel untuk pilihan pembayaran
  String? _paymentMethod = 'COD'; // Default pilihan adalah COD

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alamat Pengantaran
            AddressCard(
              address: 'Pisang Keju Gedangdut, Jl. Sumatra',
              name: 'John Doe',
              phone: '08123456789',
              isMain: true,
              onEdit: () {},
              onDelete: () {},
            ),

            // Item List Menu
            _buildCardProduct(
              title: 'Choco Tiramisu',
              price: '38.750',
              imageUrl: 'https://example.com/image.jpg',
              quantity: 1,
              onIncrement: () {},
              onDecrement: () {},
            ),

            _buildCardProduct(
              title: 'Choco Choco',
              price: '38.750',
              imageUrl: 'https://example.com/image.jpg',
              quantity: 1,
              onIncrement: () {},
              onDecrement: () {},
            ),

            // Ringkasan Pembayaran
            _buildPaymentSummary(),

            // Opsi Pembayaran
            _buildPaymentOptions(),
          ],
        ),
      ),
      // CustomButton di bawah body
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          text: 'Beli dan antar sekarang',
          onPressed: () {}, // Ganti dengan logika yang sesuai
          isLoading: false, // Set to true jika sedang loading
        ),
      ),
    );
  }

  // Helper Method untuk CardProduct dengan Border dan Padding
  Widget _buildCardProduct({
    required String title,
    required String price,
    required String imageUrl,
    required int quantity,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(10), // Padding di dalam container
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Garis pembatas
        borderRadius: BorderRadius.circular(10),
      ),
      child: CardProduct(
        title: title,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
        onIncrement: onIncrement,
        onDecrement: onDecrement,
      ),
    );
  }

  // Helper Method untuk Ringkasan Pembayaran
  Widget _buildPaymentSummary() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          const Text('Harga: 38.750'),
          const Text('Biaya Penanganan dan Pengiriman: 19.500'),
          const Divider(),
          const Text(
            'Total Pembayaran: 58.250',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Helper Method untuk Opsi Pembayaran (COD atau Transfer)
  Widget _buildPaymentOptions() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.only(
        bottom: 10,
        top: 10,
      ), // Menambahkan margin top untuk jarak
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Opsi Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text('COD (Cash On Delivery)'),
            leading: Radio<String>(
              value: 'COD',
              groupValue: _paymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _paymentMethod = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Transfer Bank'),
            leading: Radio<String>(
              value: 'Transfer',
              groupValue: _paymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _paymentMethod = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
