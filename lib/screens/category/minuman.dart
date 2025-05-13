import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/cardproduct.dart';
import '../../providers/cart_provider.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';

class MinumanScreen extends StatefulWidget {
  const MinumanScreen({Key? key}) : super(key: key);

  @override
  State<MinumanScreen> createState() => _MinumanScreenState();
}

class _MinumanScreenState extends State<MinumanScreen> {
  late Future<List<ProductModel>> minumanList;

  @override
  void initState() {
    super.initState();
    minumanList = fetchMinuman();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: minumanList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error di MinumanScreen: ${snapshot.error}');
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('Tidak ada data di MinumanScreen');
          return const Center(child: Text('Tidak ada data minuman'));
        } else {
          final minumanList = snapshot.data!;
          print('Jumlah item di MinumanScreen: ${minumanList.length}');
          return LayoutBuilder(
            builder: (context, constraints) {
              print('Tinggi grid MinumanScreen: ${constraints.maxHeight}');
              print('Lebar grid MinumanScreen: ${constraints.maxWidth}');
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
                    final quantity = Provider.of<CartProvider>(
                      context,
                    ).getQuantity(minuman.name);

                    return CardProduct(
                      title: minuman.name,
                      price: 'Rp. ${minuman.mainCost.toInt()}',
                      imageUrl: minuman.image,
                      quantity: quantity,
                      onIncrement: () {
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).addItem(minuman.name);
                      },
                      onDecrement: () {
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).removeItem(minuman.name);
                      },
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
