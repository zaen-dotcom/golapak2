import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import '../../providers/cart_provider.dart'; // Import CartProvider

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
