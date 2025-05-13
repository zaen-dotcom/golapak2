import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/cardproduct.dart';
import '../../providers/cart_provider.dart';
import '../../models/product_model.dart'; // Ganti dengan path ke foodModel
import '../../services/product_service.dart'; // Pastikan fetchMakanan dipindah ke service

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      ),
      body: SafeArea(
        child: FutureBuilder<List<ProductModel>>(
          future: makananList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Terjadi kesalahan: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada data makanan'));
            } else {
              final makananList = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: makananList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
