import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/cardproduct.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

class MinumanScreen extends StatefulWidget {
  const MinumanScreen({Key? key}) : super(key: key);

  @override
  State<MinumanScreen> createState() => _MinumanScreenState();
}

class _MinumanScreenState extends State<MinumanScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MinumanProvider>(context, listen: false).fetchMinuman(),
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
    return Consumer<MinumanProvider>(
      builder: (context, minumanProv, _) {
        if (minumanProv.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (minumanProv.error != null) {
          return Center(child: Text('Terjadi kesalahan: ${minumanProv.error}'));
        } else if (minumanProv.minumanList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Icon(Icons.local_drink, size: 50, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada minuman tersedia',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        } else {
          final minumanList = minumanProv.minumanList;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: minumanList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2 / 2.8,
              ),
              itemBuilder: (context, index) {
                final minuman = minumanList[index];
                final productId = minuman.id.toString();

                return Consumer<CartProvider>(
                  builder: (context, cart, _) {
                    final quantity = cart.getQuantity(productId, minuman.name);
                    return CardProduct(
                      title: minuman.name,
                      price: 'Rp. ${formatPrice(minuman.mainCost.toInt())}',
                      imageUrl: minuman.image,
                      quantity: quantity,
                      onIncrement: () {
                        cart.addItem(
                          id: productId,
                          title: minuman.name,
                          imageUrl: minuman.image,
                          price: minuman.mainCost.toDouble(),
                        );
                      },
                      onDecrement: () {
                        cart.removeItem(productId, minuman.name);
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
