import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/cardproduct.dart';
import '../../cart/cart_provider.dart';

class MinumanScreen extends StatefulWidget {
  const MinumanScreen({Key? key}) : super(key: key);

  @override
  State<MinumanScreen> createState() => _MinumanScreenState();
}

class _MinumanScreenState extends State<MinumanScreen> {
  final List<Map<String, String>> items = [
    {
      'title': 'Coca-Cola',
      'price': 'Rp. 5000',
      'image': 'https://via.placeholder.com/150/FF0000/FFFFFF?text=Coca-Cola',
    },
    {
      'title': 'Sprite',
      'price': 'Rp. 4000',
      'image': 'https://via.placeholder.com/150/7FFF00/000000?text=Sprite',
    },
    {
      'title': 'Pepsi',
      'price': 'Rp. 6000',
      'image': 'https://via.placeholder.com/150/1E90FF/FFFFFF?text=Pepsi',
    },
    {
      'title': 'Fanta',
      'price': 'Rp. 4500',
      'image': 'https://via.placeholder.com/150/FF69B4/000000?text=Fanta',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minuman')),
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
