import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_screen.dart';
import 'routes/main_navigation.dart';
import 'screens/verifyotp_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/address_provider.dart';
import 'screens/profile/keranjang.dart';
import 'screens/splash_screen.dart';
import 'providers/product_provider.dart';
import 'package:golapak2/providers/order_provider.dart';
import 'providers/shipping_provider.dart';
import 'providers/transaction_history_provider.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<AlamatProvider>(create: (_) => AlamatProvider()),
        ChangeNotifierProvider(create: (_) => MakananProvider()),
        ChangeNotifierProvider(create: (_) => MinumanProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ShippingProvider()),
        ChangeNotifierProvider(create: (_) => TransactionHistoryProvider()),
      ],
      child: MaterialApp(
        title: 'My App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/forgot': (context) => ForgotPasswordScreen(),
          '/main': (context) => const MainNavigation(),
          '/cart': (context) => const CartScreen(),
          '/otp': (context) {
            final email = ModalRoute.of(context)?.settings.arguments as String?;
            if (email == null) {
              return const Scaffold(
                body: Center(child: Text('Email is required')),
              );
            }
            return VerifyOTPScreen(email: email);
          },
        },
      ),
    );
  }
}
