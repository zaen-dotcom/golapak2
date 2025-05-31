import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/button.dart';
import '../../components/card_cartproduct.dart';
import '../../providers/cart_provider.dart';
import '../../providers/address_provider.dart'; // Pastikan nama file dan class sesuai, saya asumsikan 'AlamatProvider'
import '../create_order.dart';
import '../select_address.dart';
import '../../components/alertdialog.dart';
import '../../services/user_service.dart';
import '../../theme/colors.dart';

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

String formatPrice(double price) {
  final priceInt = price.toInt();
  final priceStr = priceInt.toString();
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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false; // Pindahkan ke level state agar setState efektif

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
                          final formattedPrice =
                              'Rp. ${formatPrice(item.price)}';

                          return CardProduct(
                            title: item.title,
                            price: formattedPrice,
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

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 28,
                      color: AppColors.primary,
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
                isLoading: isLoading,
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          setState(() => isLoading = true);

                          try {
                            final status = await fetchStatusToko();

                            if (!status['isOpen']) {
                              await showCustomAlertDialog(
                                context: context,
                                title: 'Toko Tutup',
                                message:
                                    status['status'] ??
                                    'Toko saat ini sedang tutup.',
                                confirmText: 'OK',
                                onConfirm: () {},
                              );
                              setState(() => isLoading = false);
                              return;
                            }
                          } catch (e) {
                            await showCustomAlertDialog(
                              context: context,
                              title: 'Gagal Cek Status',
                              message:
                                  'Tidak dapat mengecek status toko. Silakan coba lagi.',
                              confirmText: 'OK',
                              onConfirm: () {},
                            );
                            setState(() => isLoading = false);
                            return;
                          }

                          if (cartItems.isEmpty) {
                            await showCustomAlertDialog(
                              context: context,
                              title: 'Keranjang Kosong',
                              message:
                                  'Silakan tambahkan produk terlebih dahulu sebelum membuat pesanan.',
                              confirmText: 'OK',
                              onConfirm: () {},
                            );
                            setState(() => isLoading = false);
                            return;
                          }

                          if (selectedAlamat == null) {
                            await showCustomAlertDialog(
                              context: context,
                              title: 'Pilih Alamat',
                              message:
                                  'Pilih alamat terlebih dahulu sebelum melanjutkan.',
                              confirmText: 'OK',
                              onConfirm: () {},
                            );
                            setState(() => isLoading = false);
                            return;
                          }

                          setState(() => isLoading = false);

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
