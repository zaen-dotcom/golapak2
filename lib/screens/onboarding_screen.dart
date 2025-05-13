import 'dart:ui';

import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/dot_indicator.dart';
import '../theme/colors.dart';
import '../screens/login_screen.dart';
import '../utils/token_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/onboarding.png",
      "title": "Halo, Ayo Mulai!",
      "description":
          "Semua dalam satu genggaman, mulai dari sekarang dan rasakan pengalaman terbaik yang pernah ada.",
    },
    {
      "image": "assets/onboarding1.png",
      "title": "Pesan dengan Mudah",
      "description":
          "Cukup pilih makanan favoritmu, dan kami akan mengantarkannya langsung ke pintu rumahmu.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkToken();

    // Preload gambar onboarding1 agar langsung muncul
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage("assets/onboarding1.png"), context);

      if (mounted) {
        setState(() {}); 
      }
    });

    _pageController = PageController();
    _pageController.addListener(() {
      if (_pageController.hasClients && mounted) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _checkToken() async {
    final token = await TokenManager.getToken();
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(
            milliseconds: 400,
          ),
          pageBuilder:
              (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animasi lebih smooth
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return Stack(
              children: [
                // **Lapisan Blur**
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ), 
                  child: Container(
                    color: Colors.black.withOpacity(
                      0.1,
                    ), 
                  ),
                ),
                // **Animasi Slide dan Fade**
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: FadeTransition(opacity: curvedAnimation, child: child),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Flexible(
                          child: Image.asset(
                            data["image"]!,
                            height:
                                MediaQuery.of(context).size.height *
                                0.4,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data["title"]!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data["description"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            DotIndicator(
              currentIndex: _currentPage,
              dotCount: _onboardingData.length,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: CustomButton(text: "NEXT", onPressed: _nextPage),
            ),
          ],
        ),
      ),
    );
  }
}
