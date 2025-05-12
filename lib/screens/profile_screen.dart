import 'package:flutter/material.dart';
import '../components/menuitem.dart';
import '../components/alertdialog.dart';
import 'profile/infopribadi.dart';
import 'profile/alamat.dart';
import 'profile/keranjang.dart';
import 'profile/help.dart';
import 'profile/pengaturan.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';
import '../models/user_model.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await getUser();

      // Set user ke state
      setState(() {
        _user = user;
      });

      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUserId(user.id);
      }
    } catch (e) {
      setState(() {
        _user = null;
      });
    }
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
                    _user == null
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
                    _user == null
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
                          _user!.name,
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
                    MaterialPageRoute(builder: (context) => const InfoScreen()),
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
                    MaterialPageRoute(
                      builder: (context) => const AlamatScreen(),
                    ),
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
                    MaterialPageRoute(builder: (context) => const CartScreen()),
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
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
              ),
              const SizedBox(height: 5),
              MenuItem(
                icon: Icons.settings_outlined,
                text: 'Pengaturan',
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingScreen(),
                    ),
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
