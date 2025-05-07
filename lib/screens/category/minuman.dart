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
      'image': 'assets/images/esteler.png',
    },
    {
      'title': 'Sprite',
      'price': 'Rp. 4000',
      'image': 'assets/images/bakso.jpg',
    },
    {
      'title': 'Pepsi',
      'price': 'Rp. 6000',
      'image': 'assets/images/bakreng.jpg',
    },
    {
      'title': 'Fanta',
      'price': 'Rp. 4500',
      'image': 'assets/images/miepromo.png',
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
                  true, // Agar GridView menyesuaikan dengan tinggi kontennya
              physics:
                  const NeverScrollableScrollPhysics(), // Agar hanya scroll utama yang aktif
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
