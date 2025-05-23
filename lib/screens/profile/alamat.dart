import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../components/button.dart';
import '../../components/addresscard.dart';
import '../../providers/user_provider.dart';
import '../../providers/address_provider.dart';
import '../../services/user_service.dart';
import 'add_alamat.dart';
import 'update_alamat.dart';
import '../../components/alertdialog.dart';

class AlamatScreen extends StatefulWidget {
  const AlamatScreen({Key? key}) : super(key: key);

  @override
  State<AlamatScreen> createState() => _AlamatScreenState();
}

class _AlamatScreenState extends State<AlamatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        Provider.of<AlamatProvider>(context, listen: false).fetchAlamat(userId);
      }
    });
  }

  Future<void> _refreshAlamat() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId != null) {
      await Provider.of<AlamatProvider>(
        context,
        listen: false,
      ).fetchAlamat(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alamatProvider = Provider.of<AlamatProvider>(context);
    final isLoading = alamatProvider.isLoading;
    final addressList = alamatProvider.alamatList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Alamat Saya',
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
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAlamat,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        displacement: 40.0,
        child:
            isLoading
                ? ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildSkeleton(),
                )
                : addressList.isEmpty
                ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 60.0),
                          child: Text(
                            'Tidak ada alamat.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: addressList.length,
                  itemBuilder: (context, index) {
                    final item = addressList[index];
                    return AddressCard(
                      address: item['address'] ?? 'Alamat tidak tersedia',
                      name: item['name'] ?? 'Nama tidak tersedia',
                      phone: item['phone_number'] ?? 'Nomor tidak tersedia',
                      isMain: item['main_address'] == 1,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => UpdateAddressScreen(
                                  addressId: item['id'],
                                  initialName: item['name'] ?? '',
                                  initialPhone: item['phone_number'] ?? '',
                                  initialAddress: item['address'] ?? '',
                                  initialIsMain:
                                      (item['main_address'] ?? 0) == 1,
                                  initialLatitude:
                                      item['latitude'] is String
                                          ? double.tryParse(item['latitude']) ??
                                              0.0
                                          : (item['latitude']?.toDouble() ??
                                              0.0),
                                  initialLongitude:
                                      item['longitude'] is String
                                          ? double.tryParse(
                                                item['longitude'],
                                              ) ??
                                              0.0
                                          : (item['longitude']?.toDouble() ??
                                              0.0),
                                ),
                          ),
                        ).then((_) => _refreshAlamat());
                      },

                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (context) => WillPopScope(
                                onWillPop: () async => false,
                                child: CustomAlert(
                                  title: 'Hapus Alamat',
                                  message:
                                      'Apakah kamu yakin ingin menghapus alamat ini?',
                                  cancelText: 'Batal',
                                  onCancel:
                                      () => Navigator.of(context).pop(false),
                                  confirmText: 'Hapus',
                                  onConfirm:
                                      () => Navigator.of(context).pop(true),
                                  isDestructive: true,
                                ),
                              ),
                        );

                        if (confirm == true) {
                          try {
                            await deleteAddress(item['id']);
                            await _refreshAlamat();
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (context) => WillPopScope(
                                    onWillPop: () async => false,
                                    child: CustomAlert(
                                      title: 'Berhasil',
                                      message: 'Alamat berhasil dihapus',
                                      confirmText: 'OK',
                                      onConfirm:
                                          () => Navigator.of(context).pop(),
                                    ),
                                  ),
                            );
                          } catch (e) {
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (context) => WillPopScope(
                                    onWillPop: () async => false,
                                    child: CustomAlert(
                                      title: 'Gagal Menghapus',
                                      message: 'Gagal menghapus alamat: $e',
                                      confirmText: 'OK',
                                      onConfirm:
                                          () => Navigator.of(context).pop(),
                                    ),
                                  ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: CustomButton(
          text: 'Tambah Alamat',
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const AddAlamatScreen(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            ).then((_) => _refreshAlamat());
          },
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 10, color: Colors.grey[300]),
                  const SizedBox(height: 4),
                  Container(width: 200, height: 10, color: Colors.grey[300]),
                ],
              ),
            ),
            Row(
              children: [
                Container(width: 24, height: 24, color: Colors.grey[300]),
                const SizedBox(width: 8),
                Container(width: 24, height: 24, color: Colors.grey[300]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
