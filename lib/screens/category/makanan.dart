import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/cardproduct.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

class MakananScreen extends StatefulWidget {
  const MakananScreen({Key? key}) : super(key: key);

  @override
  State<MakananScreen> createState() => _MakananScreenState();
}

class _MakananScreenState extends State<MakananScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MakananProvider>(context, listen: false).fetchMakanan(),
    );
  }

  String formatPrice(int price) {
    final priceStr = price.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = priceStr.length - 1; i >= 0; i--) {
      buffer.write(priceStr[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }

    return buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MakananProvider>(
      builder: (context, makananProv, _) {
        if (makananProv.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (makananProv.error != null) {
          return Center(child: Text('Terjadi kesalahan: ${makananProv.error}'));
        } else if (makananProv.makananList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Icon(Icons.restaurant_menu, size: 50, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada makanan tersedia',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        } else {
          final makananList = makananProv.makananList;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: makananList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2 / 2.8,
              ),
              itemBuilder: (context, index) {
                final makanan = makananList[index];
                final productId = makanan.id.toString();

                return Consumer<CartProvider>(
                  builder: (context, cart, _) {
                    final quantity = cart.getQuantity(productId, makanan.name);
                    return CardProduct(
                      title: makanan.name,
                      price: 'Rp. ${formatPrice(makanan.mainCost.toInt())}',
                      imageUrl: makanan.image,
                      quantity: quantity,
                      onIncrement: () {
                        cart.addItem(
                          id: productId,
                          title: makanan.name,
                          imageUrl: makanan.image,
                          price: makanan.mainCost.toDouble(),
                        );
                      },
                      onDecrement: () {
                        cart.removeItem(productId, makanan.name);
                      },
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
