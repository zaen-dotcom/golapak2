import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/button.dart';
import '../../components/card_cartproduct.dart';
import '../../providers/cart_provider.dart';
import '../../providers/address_provider.dart';
import '../create_order.dart';
import '../select_address.dart';
import '../../components/alertdialog.dart';

Future<void> showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (ctx) => CustomAlert(
          title: title,
          message: message,
          confirmText: confirmText,
          onConfirm: () {
            Navigator.of(ctx).pop();
            onConfirm();
          },
        ),
  );
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final alamatProvider = Provider.of<AlamatProvider>(context);
    final selectedAlamat = alamatProvider.selectedAlamat;
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

            /// Alamat pengiriman
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // ICON vertical center
                children: [
                  Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 28,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child:
                        selectedAlamat != null
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  selectedAlamat['name'] ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedAlamat['address'] ?? '-',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                            : const Text(
                              'Pilih Alamat',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
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
            ),

            const SizedBox(height: 12),

            SafeArea(
              top: false,
              child: CustomButton(
                text: 'BUAT PESANAN',
                onPressed: () async {
                  if (selectedAlamat == null) {
                    await showCustomAlertDialog(
                      context: context,
                      title: 'Pilih Alamat',
                      message:
                          'Pilih alamat terlebih dahulu sebelum melanjutkan.',
                      confirmText: 'OK',
                      onConfirm: () {},
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateOrderScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
