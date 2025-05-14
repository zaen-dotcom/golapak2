import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../components/button.dart';
import '../../components/addresscard.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';
import 'add_alamat.dart';
import 'update_alamat.dart';

class AlamatScreen extends StatefulWidget {
  const AlamatScreen({Key? key}) : super(key: key);

  @override
  State<AlamatScreen> createState() => _AlamatScreenState();
}

class _AlamatScreenState extends State<AlamatScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _addressList = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId == null) {
      print('User ID tidak ditemukan');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final addresses = await getAddress(userId);

    List<Map<String, dynamic>> mainAddress = [];
    List<Map<String, dynamic>> otherAddresses = [];

    for (var address in addresses) {
      if (address['main_address'] == 1) {
        mainAddress.add(address);
      } else {
        otherAddresses.add(address);
      }
    }

    mainAddress.addAll(otherAddresses);

    setState(() {
      _addressList = mainAddress;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        onRefresh: _loadAddresses,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        displacement: 40.0,
        child:
            _isLoading
                ? ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildSkeleton();
                  },
                )
                : _addressList.isEmpty
                ? ListView(
                  children: const [
                    Center(
                      child: Text(
                        'Tidak ada alamat.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _addressList.length,
                  itemBuilder: (context, index) {
                    final item = _addressList[index];
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
                                  initialIsMain: item['main_address'] == 1,
                                ),
                          ),
                        ).then((_) {
                          _loadAddresses();
                        });
                      },
                      onDelete: () {
                        // TODO: Aksi hapus alamat
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
            ).then((_) => _loadAddresses());
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
