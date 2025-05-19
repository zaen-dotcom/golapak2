import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/button.dart';
import '../../components/card_cartproduct.dart';
import '../../providers/cart_provider.dart';
import '../select_address.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child:
                  cartItems.isEmpty
                      ? const Center(child: Text('Keranjang masih kosong'))
                      : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return CardProduct(
                            title: item.title,
                            price: 'Rp. ${item.price.toInt()}',
                            imageUrl: item.imageUrl,
                            quantity: cart.getQuantity(item.id, item.title),
                            onIncrement: () {
                              cart.addItem(
                                id: item.id,
                                title: item.title,
                                imageUrl: item.imageUrl,
                                price: item.price,
                              );
                            },
                            onDecrement: () {
                              cart.removeItem(item.id, item.title);
                            },
                          );
                        },
                      ),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '2118 Thornridge Cir. Syracuse',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectAddressScreen(),
                      ),
                    );
                  },
                  child: const Text('PILIH'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// SafeArea + jarak kecil
            SafeArea(
              top: false,
              child: CustomButton(text: 'BUAT PESANAN', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
