import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_screen.dart';
import 'routes/main_navigation.dart';
import 'screens/verifyotp_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/main': (context) => const MainNavigation(),
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
    );
  }
}
