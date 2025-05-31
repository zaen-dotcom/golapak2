import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/button.dart';
import '../components/box_container.dart';
import '../providers/address_provider.dart';
import '../components/card_cartproduct.dart';
import '../providers/cart_provider.dart';
import '../services/transaction_service.dart';
import '../routes/main_navigation.dart';
import '../components/alertdialog.dart';
import '../screens/payment_transfer.dart';
import '../components/transfer_method.dart';
import '../utils/transfer_data.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

bool isLoading = false;

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  String? _paymentMethod = 'COD';
  String? selectedBank;

  int totalHargaProduk = 0;
  String biayaOngkir = '0';
  int totalBiayaPembayaran = 0;
  bool isLoadingSummary = false;
  late CartProvider _cartProvider;

  String formatRibuan(int number) {
    final str = number.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (match) => '.');
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final alamatProvider = Provider.of<AlamatProvider>(
        context,
        listen: false,
      );
      alamatProvider.fetchAlamat(1);

      _cartProvider = Provider.of<CartProvider>(context, listen: false);
      _cartProvider.addListener(_loadRingkasanPembayaran);

      _loadRingkasanPembayaran();
    });
  }

  @override
  void dispose() {
    _cartProvider.removeListener(_loadRingkasanPembayaran);
    super.dispose();
  }

  String formatCurrencyString(String numberStr) {
    final intValue = int.tryParse(numberStr) ?? 0;
    return 'Rp ${formatRibuan(intValue)}';
  }

  Widget _buildSummaryRow(String label, dynamic amount, {bool bold = false}) {
    String displayValue;
    if (amount is int) {
      displayValue = 'Rp ${formatRibuan(amount)}';
    } else if (amount is String) {
      displayValue = formatCurrencyString(amount);
    } else {
      displayValue = amount.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            displayValue,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadRingkasanPembayaran() async {
    if (!mounted) return;

    final cartItems = _cartProvider.items;

    if (cartItems.isEmpty) {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const MainNavigation(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
      return;
    }

    if (!mounted) return;

    setState(() => isLoadingSummary = true);

    final menuList =
        cartItems.values
            .map((item) => {'id': item.id, 'qty': item.quantity})
            .toList();

    final result = await calculateTransaction(menuList);

    if (!mounted) return;

    if (result != null) {
      setState(() {
        totalHargaProduk = result.totalHargaProduk;
        biayaOngkir = result.biayaOngkir;
        totalBiayaPembayaran = result.totalBiayaPembayaran;
        isLoadingSummary = false;
      });
    } else {
      if (mounted) {
        setState(() => isLoadingSummary = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Box 1: Alamat Pengiriman
            Consumer<AlamatProvider>(
              builder: (context, alamatProvider, child) {
                final alamat = alamatProvider.selectedAlamat;
                if (alamatProvider.isLoading) {
                  return const WhiteBoxContainer(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (alamat == null) {
                  return const WhiteBoxContainer(
                    child: Text('Belum ada alamat yang dipilih.'),
                  );
                }

                return WhiteBoxContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alamat Pengiriman',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alamat['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(alamat['address'] ?? ''),
                    ],
                  ),
                );
              },
            ),

            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final cartItems = cartProvider.items.values.toList();

                if (cartItems.isEmpty) {
                  return const WhiteBoxContainer(
                    child: Text('Belum ada produk yang dipilih.'),
                  );
                }

                return WhiteBoxContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daftar Produk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...cartItems.map(
                        (item) => CardProduct(
                          title: item.title,
                          price: 'Rp ${formatRibuan(item.price.toInt())}',
                          imageUrl: item.imageUrl,
                          quantity: item.quantity,
                          onIncrement: () {
                            cartProvider.addItem(
                              id: item.id,
                              title: item.title,
                              imageUrl: item.imageUrl,
                              price: item.price,
                            );
                          },
                          onDecrement: () {
                            cartProvider.removeItem(item.id, item.title);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            WhiteBoxContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (isLoadingSummary)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    _buildSummaryRow('Total Harga Produk', totalHargaProduk),
                    _buildSummaryRow('Biaya Ongkir', biayaOngkir),
                    const Divider(),
                    _buildSummaryRow(
                      'Total Pembayaran',
                      totalBiayaPembayaran,
                      bold: true,
                    ),
                  ],
                ],
              ),
            ),

            WhiteBoxContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text('COD (Bayar di tempat)'),
                    leading: Radio<String>(
                      value: 'COD',
                      groupValue: _paymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          _paymentMethod = value;
                          selectedBank = null;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Transfer'),
                    leading: Radio<String>(
                      value: 'Transfer',
                      groupValue: _paymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          _paymentMethod = value;
                        });
                      },
                    ),
                  ),
                  if (_paymentMethod == 'Transfer')
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: ChooseTransferMethodPage(
                        totalAmount: totalBiayaPembayaran,
                        selectedBank: selectedBank,
                        onChanged: (value) {
                          setState(() {
                            selectedBank = value;
                          });

                          if (_paymentMethod == 'Transfer' && value != null) {
                            final bankData = transferMethods.firstWhere(
                              (element) => element['name'] == value,
                              orElse: () => {},
                            );

                            final rekening =
                                bankData['rekening'] ?? 'Tidak diketahui';
                            final atasNama =
                                bankData['atas_nama'] ?? 'Tidak diketahui';

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => PaymentTransferScreen(
                                      bankName: value,
                                      accountNumber: rekening,
                                      accountName: atasNama,
                                      totalAmount: totalBiayaPembayaran,
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// Tombol
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 50),
        child: CustomButton(
          text: 'KONFIRMASI PESANAN',
          onPressed:
              isLoading
                  ? null
                  : () async {
                    setState(() => isLoading = true);

                    final cartItems = _cartProvider.items.values.toList();
                    final menuList =
                        cartItems
                            .map(
                              (item) => {'id': item.id, 'qty': item.quantity},
                            )
                            .toList();

                    final alamatProvider = Provider.of<AlamatProvider>(
                      context,
                      listen: false,
                    );
                    final alamat = alamatProvider.selectedAlamat;

                    if (alamat == null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => CustomAlert(
                              title: 'Gagal',
                              message: 'Alamat belum dipilih.',
                              confirmText: 'OK',
                              onConfirm: () {
                                Navigator.of(context).pop();
                                setState(
                                  () => isLoading = false,
                                ); 
                              },
                            ),
                      );
                      return;
                    }

                    String? accountNumber;
                    if (_paymentMethod == 'Transfer' && selectedBank != null) {
                      final bankData = transferMethods.firstWhere(
                        (element) => element['name'] == selectedBank,
                        orElse: () => {},
                      );
                      accountNumber = bankData['rekening'];
                    }

                    final paymentMethodToSend =
                        _paymentMethod == 'Transfer'
                            ? 'transfer'
                            : _paymentMethod!.toLowerCase();

                    final response = await createOrder(
                      menu: menuList,
                      addressId: alamat['id'],
                      paymentMethod: paymentMethodToSend,
                      accountNumber: accountNumber,
                    );

                    if (!mounted) return;

                    if (response['status'] == 'success') {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => CustomAlert(
                              title: 'Berhasil',
                              message: 'Pesanan berhasil dibuat!',
                              confirmText: 'Lihat Pesanan',
                              onConfirm: () {
                                _cartProvider.clearCart();
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const MainNavigation(
                                          initialIndex: 1,
                                        ),
                                  ),
                                );
                                setState(
                                  () => isLoading = false,
                                ); 
                              },
                            ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => CustomAlert(
                              title: 'Gagal',
                              message:
                                  response['message'] ??
                                  'Pesanan gagal dibuat.',
                              confirmText: 'Tutup',
                              onConfirm: () {
                                Navigator.of(context).pop();
                                setState(
                                  () => isLoading = false,
                                ); 
                              },
                            ),
                      );
                    }
                  },

          isLoading: false,
        ),
      ),
    );
  }
}
