import 'package:flutter/material.dart';
import '../../components/cardproduct.dart';

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
      'image':
          'https://via.placeholder.com/150/FFB6C1/000000?text=Burger+Bistro',
    },
    {
      'title': 'Smokin\' Burger',
      'price': 'Rp. 10000',
      'image':
          'https://via.placeholder.com/150/90EE90/000000?text=Smokin+Burger',
    },
    {
      'title': 'Buffalo Burgers',
      'price': 'Rp. 13000',
      'image':
          'https://via.placeholder.com/150/87CEFA/000000?text=Buffalo+Burgers',
    },
    {
      'title': 'Bullseye Burgers',
      'price': 'Rp. 14000',
      'image':
          'https://via.placeholder.com/150/FFD700/000000?text=Bullseye+Burgers',
    },
  ];

  late List<int> quantities;

  @override
  void initState() {
    super.initState();
    quantities = List.generate(items.length, (_) => 0);
  }

  void _increment(int index) {
    setState(() {
      quantities[index]++;
    });
  }

  void _decrement(int index) {
    if (quantities[index] > 0) {
      setState(() {
        quantities[index]--;
      });
    }
  }

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
            return CardProduct(
              title: item['title']!,
              price: item['price']!,
              imageUrl: item['image']!,
              quantity: quantities[index],
              onIncrement: () => _increment(index),
              onDecrement: () => _decrement(index),
            );
          },
        ),
      ),
    );
  }
}
