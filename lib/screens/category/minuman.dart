import 'package:flutter/material.dart';
import '../../components/cardproduct.dart';

class MinumanScreen extends StatelessWidget {
  const MinumanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Coca-Cola', 'price': 'Rp. 5000'},
      {'title': 'Sprite', 'price': 'Rp. 4000'},
      {'title': 'Pepsi', 'price': 'Rp. 6000'},
      {'title': 'Fanta', 'price': 'Rp. 4500'},
    ];

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
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 3 / 4,
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
