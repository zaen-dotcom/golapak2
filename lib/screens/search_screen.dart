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
  List<ProductModel> searchResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MakananProvider>(context, listen: false).fetchMakanan();
      Provider.of<MinumanProvider>(context, listen: false).fetchMinuman();
    });
  }

  void _search(String query, List<ProductModel> allProducts) {
    setState(() {
      if (query.isEmpty) {
        searchResults = allProducts;
      } else {
        searchResults =
            allProducts.where((product) {
              return product.name.toLowerCase().contains(query.toLowerCase());
            }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MakananProvider()),
        ChangeNotifierProvider(create: (_) => MinumanProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Scaffold(
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

            if (makananProvider.error != null ||
                minumanProvider.error != null) {
              return Center(
                child: Text(
                  makananProvider.error ??
                      minumanProvider.error ??
                      'Terjadi kesalahan',
                ),
              );
            }

            final allProducts = [
              ...makananProvider.makananList,
              ...minumanProvider.minumanList,
            ];

            if (searchResults.isEmpty && allProducts.isNotEmpty) {
              searchResults = allProducts;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  searchResults.isEmpty
                      ? const Center(child: Text('Tidak ada hasil pencarian'))
                      : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final ProductModel product = searchResults[index];
                          return CardProduct(
                            title: product.name,
                            price:
                                product.mainCost
                                    .toString(), // Untuk UI, gunakan int
                            imageUrl: product.image,
                            quantity: cartProvider.getQuantity(
                              product.id
                                  .toString(), // Konversi id ke String untuk CartProvider
                              product.name,
                            ),
                            onIncrement: () {
                              cartProvider.addItem(
                                id:
                                    product.id
                                        .toString(), // Konversi id ke String untuk CartProvider
                                title: product.name,
                                imageUrl: product.image,
                                price:
                                    product
                                        .mainCost, // Untuk CartProvider, gunakan double
                              );
                            },
                            onDecrement: () {
                              cartProvider.removeItem(
                                product.id
                                    .toString(), // Konversi id ke String untuk CartProvider
                                product.name,
                              );
                            },
                          );
                        },
                      ),
            );
          },
        ),
      ),
    );
  }
}
