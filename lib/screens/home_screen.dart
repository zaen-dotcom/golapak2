import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/banner.dart';
import '../components/button.dart';
import '../routes/category_nav.dart';
import '../cart/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _bannerTimer;

  final int _bannerCount = 3;
  int _currentBanner = 0;

  final List<String> _bannerUrls = [
    'images/Homepage_1.png',
    'images/Homepage_2.png',
    'images/Homepage_3.png',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScrollBanner();
    });
  }

  void _startAutoScrollBanner() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _currentBanner = (_currentBanner + 1) % _bannerCount;
        _pageController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    _pageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          SafeArea(
            child: GestureDetector(
              onTap: () => _focusNode.unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black45),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                hintText: "Cari...",
                                hintStyle: const TextStyle(
                                  color: Colors.black38,
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.grey[200],
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                              ),
                              autofocus: false,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Banner
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _bannerCount,
                        onPageChanged: (index) {
                          _currentBanner = index;
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: BannerPlaceholder(
                              imageUrl: _bannerUrls[index],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Kategori Menu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const CategoryScreen(),

                    const SizedBox(
                      height: 100,
                    ), // Spacer agar konten tidak tertutup tombol
                  ],
                ),
              ),
            ),
          ),

          // Animated Keranjang Button
          Positioned(
            left: 20,
            right: 20,
            bottom:
                MediaQuery.of(context).padding.bottom +
                12, // Lebih dekat ke navbot
            child: AnimatedSlide(
              offset: cartProvider.totalItems > 0 ? Offset(0, 0) : Offset(0, 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: cartProvider.totalItems > 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: CustomButton(
                  text: 'Keranjang (${cartProvider.totalItems})',
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
