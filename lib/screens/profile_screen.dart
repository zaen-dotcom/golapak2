import 'package:flutter/material.dart';
import '../components/menuitem.dart';
import '../components/alertdialog.dart';
import 'profile/infopribadi.dart';
import 'profile/alamat.dart';
import 'profile/keranjang.dart';
import 'profile/help.dart';
import 'profile/pengaturan.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _onLogout(BuildContext context) async {
    // Tampilkan dialog konfirmasi logout
    showDialog(
      context: context,
      barrierDismissible: false, // Mencegah dialog ditutup selain dengan tombol
      builder:
          (_) => CustomAlert(
            title: 'Keluar',
            message: 'Yakin ingin keluar dari akun ini?',
            confirmText: 'OK',
            onConfirm: () async {
              final token =
                  await TokenManager.getToken(); // Ambil token dari SharedPreferences

              if (token == null) {
                // Jika token tidak ada di SharedPreferences, langsung arahkan ke halaman login
                Navigator.pushReplacementNamed(context, '/login');
              } else {
                // Jika token ada, lanjutkan dengan proses logout
                final result =
                    await logout(); // Proses logout dari API atau state

                if (result['status'] == 'success') {
                  // Jika logout berhasil, hapus token dari SharedPreferences
                  await TokenManager.removeToken();

                  // Arahkan langsung ke halaman login
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  // Jika logout gagal, tampilkan pesan error
                  Navigator.pop(context); // Tutup dialog
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result['message'])));
                }
              }
            },
            cancelText: 'Batal',
            onCancel: () {
              Navigator.pop(context); // Tutup dialog jika batal
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
                child: CircleAvatar(
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
              const Center(
                child: Text(
                  'Nama Pengguna',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
