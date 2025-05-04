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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Makanan')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 2 / 2.8,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            // Mengambil jumlah produk yang dipilih dari CartProvider
            final quantity = Provider.of<CartProvider>(
              context,
            ).getQuantity(item['title']!);

            return CardProduct(
              title: item['title']!,
              price: item['price']!,
              imageUrl: item['image']!,
              quantity: quantity,
              onIncrement: () {
                // Menambahkan item ke CartProvider
                Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).addItem(item['title']!);
              },
              onDecrement: () {
                // Mengurangi item dari CartProvider
                Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).removeItem(item['title']!);
              },
            );
          },
        ),
      ),
    );
  }
}
