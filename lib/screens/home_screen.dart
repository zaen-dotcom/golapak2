import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/banner.dart';
import '../components/button.dart';
import '../routes/category_nav.dart';
import '../cart/cart_provider.dart';
import '../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final PageController _pageController = PageController(viewportFraction: 1.0);
  Timer? _bannerTimer;

  final int _bannerCount = 3;
  int _currentBanner = 0;

  final List<String> _bannerUrls = [
    'assets/images/Homepage_1.png',
    'assets/images/Homepage_2.png',
    'assets/images/Homepage_3.png',
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyBlue, // <-- GANTI DI SINI
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Color(
                                0xFF607D8B,
                              ), // atau sesuaikan jika punya warna icon sendiri
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  hintText: "Cari...",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF90A4AE),
                                  ),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor:
                                      AppColors
                                          .lightGreyBlue, // <-- GANTI DI SINI JUGA
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          AppColors
                                              .lightGreyBlue, // <-- DAN DI SINI
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFB0BEC5), // Biru-abu tua
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                autofocus: false,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Banner
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
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
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Kategori Menu
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Kategori Menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 15)),

                  const SliverToBoxAdapter(child: CategoryScreen()),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),

          // Animated Keranjang Button
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 12,
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
