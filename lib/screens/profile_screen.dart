import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/menuitem.dart';
import '../components/alertdialog.dart';
import 'profile/infopribadi.dart';
import 'profile/alamat.dart';
import 'profile/keranjang.dart';
import 'profile/help.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';
import '../providers/user_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../screens/profile/hubungikami.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).loadUser();
    });
  }

  void _onLogout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => CustomAlert(
            title: 'Keluar',
            message: 'Yakin ingin keluar dari akun ini?',
            confirmText: 'OK',
            onConfirm: () async {
              final token = await TokenManager.getToken();
              if (token == null) {
                Navigator.pushReplacementNamed(context, '/login');
              } else {
                final result = await logout();
                if (result['status'] == 'success') {
                  await TokenManager.removeToken();
                  Provider.of<UserProvider>(context, listen: false).reset();
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result['message'])));
                }
              }
            },
            cancelText: 'Batal',
            onCancel: () {
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final isLoading = userProvider.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Center(
                child:
                    isLoading || user == null
                        ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CircleAvatar(
                            radius: 57,
                            backgroundColor: Colors.grey[300],
                          ),
                        )
                        : CircleAvatar(
                          radius: 57,
                          backgroundColor: Colors.orangeAccent,
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
              ),
              const SizedBox(height: 20),
              Center(
                child:
                    isLoading || user == null
                        ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 18,
                            width: 100,
                            color: Colors.grey[300],
                          ),
                        )
                        : Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
              const SizedBox(height: 50),
              MenuItem(
                icon: Icons.person_outline,
                text: 'Info Pribadi',
                iconColor: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InfoScreen()),
                  );
                },
              ),
              const SizedBox(height: 5),
              MenuItem(
                icon: Icons.location_on_outlined,
                text: 'Alamat',
                iconColor: Colors.deepPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AlamatScreen()),
                  );
                },
              ),
              const SizedBox(height: 5),
              MenuItem(
                icon: Icons.shopping_cart_outlined,
                text: 'Keranjang',
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              const SizedBox(height: 5),
              MenuItem(
                icon: Icons.chat_outlined,
                text: 'Bantuan',
                iconColor: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpScreen()),
                  );
                },
              ),
              const SizedBox(height: 5),
              MenuItem(
                icon: Icons.phone_android,
                text: 'Hubungi Kami',
                iconColor: Colors.blueGrey,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                  );
                },
              ),
              const SizedBox(height: 5),
              MenuItem(
                icon: Icons.logout,
                text: 'Log Out',
                iconColor: Colors.redAccent,
                onTap: () => _onLogout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
