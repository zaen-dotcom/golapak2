import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../components/card_cartproduct.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<ProductModel> searchResults = [];

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final makananProvider = Provider.of<MakananProvider>(
        context,
        listen: false,
      );
      final minumanProvider = Provider.of<MinumanProvider>(
        context,
        listen: false,
      );

      await makananProvider.fetchMakanan();
      await minumanProvider.fetchMinuman();

      final allProducts = [
        ...makananProvider.makananList,
        ...minumanProvider.minumanList,
      ];

      setState(() {
        searchResults = allProducts;
      });
    });
  }

  void _search(String query, List<ProductModel> allProducts) {
    setState(() {
      if (query.isEmpty) {
        searchResults = allProducts;
      } else {
        searchResults =
            allProducts
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Jangan buat MultiProvider di sini, asumsikan sudah ada di root

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pencarian',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Cari...',
                hintStyle: const TextStyle(color: Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final allProducts = [
                      ...Provider.of<MakananProvider>(
                        context,
                        listen: false,
                      ).makananList,
                      ...Provider.of<MinumanProvider>(
                        context,
                        listen: false,
                      ).minumanList,
                    ];
                    _search(_searchController.text, allProducts);
                  },
                ),
              ),
              onChanged: (query) {
                final allProducts = [
                  ...Provider.of<MakananProvider>(
                    context,
                    listen: false,
                  ).makananList,
                  ...Provider.of<MinumanProvider>(
                    context,
                    listen: false,
                  ).minumanList,
                ];
                _search(query, allProducts);
              },
            ),
          ),
        ),
      ),
      body: Consumer3<MakananProvider, MinumanProvider, CartProvider>(
        builder: (
          context,
          makananProvider,
          minumanProvider,
          cartProvider,
          child,
        ) {
          if (makananProvider.isLoading || minumanProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (makananProvider.error != null || minumanProvider.error != null) {
            return Center(
              child: Text(
                makananProvider.error ??
                    minumanProvider.error ??
                    'Terjadi kesalahan',
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                searchResults.isEmpty
                    ? const Center(child: Text('Tidak ada hasil pencarian'))
                    : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final ProductModel product = searchResults[index];
                        return CardProduct(
                          title: product.name,
                          price: 'Rp. ${formatPrice(product.mainCost.toInt())}',
                          imageUrl: product.image,
                          quantity: cartProvider.getQuantity(
                            product.id.toString(),
                            product.name,
                          ),
                          onIncrement: () {
                            cartProvider.addItem(
                              id: product.id.toString(),
                              title: product.name,
                              imageUrl: product.image,
                              price: product.mainCost,
                            );
                          },
                          onDecrement: () {
                            cartProvider.removeItem(
                              product.id.toString(),
                              product.name,
                            );
                          },
                        );
                      },
                    ),
          );
        },
      ),
    );
  }
}
