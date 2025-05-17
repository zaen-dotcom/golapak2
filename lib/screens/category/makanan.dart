import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/cardproduct.dart';
import '../../providers/cart_provider.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';

class MakananScreen extends StatefulWidget {
  const MakananScreen({Key? key}) : super(key: key);

  @override
  State<MakananScreen> createState() => _MakananScreenState();
}

class _MakananScreenState extends State<MakananScreen> {
  late Future<List<ProductModel>> makananList;

  @override
  void initState() {
    super.initState();
    makananList = fetchMakanan();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: makananList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error di MakananScreen: ${snapshot.error}');
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('Tidak ada data di MakananScreen');
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
          final makananList = snapshot.data!;
          print('Jumlah item di MakananScreen: ${makananList.length}');
          return LayoutBuilder(
            builder: (context, constraints) {
              print('Tinggi grid MakananScreen: ${constraints.maxHeight}');
              print('Lebar grid MakananScreen: ${constraints.maxWidth}');
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
                    final quantity = Provider.of<CartProvider>(
                      context,
                    ).getQuantity(makanan.name);

                    return CardProduct(
                      title: makanan.name,
                      price: 'Rp. ${makanan.mainCost.toInt()}',
                      imageUrl: makanan.image,
                      quantity: quantity,
                      onIncrement: () {
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).addItem(makanan.name);
                      },
                      onDecrement: () {
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).removeItem(makanan.name);
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
