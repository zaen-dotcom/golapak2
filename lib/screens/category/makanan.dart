import 'package:flutter/material.dart';
import '../../components/cardproduct.dart';

class MakananScreen extends StatelessWidget {
  const MakananScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Burger Bistro', 'price': 'Rp. 25000'},
      {'title': 'Smokin\' Burger', 'price': 'Rp. 10000'},
      {'title': 'Buffalo Burgers', 'price': 'Rp. 13000'},
      {'title': 'Bullseye Burgers', 'price': 'Rp. 14000'},
    ];

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
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 2 / 2.8,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return CardProduct(
              title: item['title']!,
              price: item['price']!,
              onAdd: () {
                // Tambah aksi
              },
            );
          },
        ),
      ),
    );
  }
}
