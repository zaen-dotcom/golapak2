import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import '../../cart/cart_provider.dart'; // Import CartProvider

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: ListView.builder(
        itemCount: cartProvider.items.length,
        itemBuilder: (context, index) {
          final item = cartProvider.items.keys.elementAt(index);
          return ListTile(
            title: Text(item),
            trailing: Text('Qty: ${cartProvider.items[item]}'),
            onTap: () {
              // Optional: bisa menambah atau mengurangi produk di cart
            },
          );
        },
      ),
    );
  }
}
