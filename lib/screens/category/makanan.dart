import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/cardproduct.dart';
import '../../cart/cart_provider.dart';

class MakananScreen extends StatefulWidget {
  const MakananScreen({Key? key}) : super(key: key);

  @override
  State<MakananScreen> createState() => _MakananScreenState();
}

class _MakananScreenState extends State<MakananScreen> {
  final List<Map<String, String>> items = [
    {
      'title': 'Burger Bistro',
      'price': 'Rp. 25000',
      'image': 'assets/images/bakso.jpg',
    },
    {
      'title': 'Smokin\' Burger',
      'price': 'Rp. 10000',
      'image': 'assets/images/bakreng.jpg',
    },
    {
      'title': 'Buffalo Burgers',
      'price': 'Rp. 13000',
      'image': 'assets/images/gorengan.jpeg',
    },
    {
      'title': 'Bullseye Burgers',
      'price': 'Rp. 14000',
      'image': 'assets/images/miayam.jpg',
    },
    // Bisa menambahkan lebih banyak item sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: GridView.builder(
              shrinkWrap:
                  true, // Ini memungkinkan GridView menyesuaikan tinggi kontennya
              physics:
                  const NeverScrollableScrollPhysics(), // Agar scroll hanya di GridView utama
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio:
                    2 / 2.8, // Sesuaikan agar gambar dan teks seimbang
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                final quantity = Provider.of<CartProvider>(
                  context,
                ).getQuantity(item['title']!);

                return CardProduct(
                  title: item['title']!,
                  price: item['price']!,
                  imageUrl: item['image']!,
                  quantity: quantity,
                  onIncrement: () {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).addItem(item['title']!);
                  },
                  onDecrement: () {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).removeItem(item['title']!);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
