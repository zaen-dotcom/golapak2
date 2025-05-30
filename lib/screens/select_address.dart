import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import '../providers/user_provider.dart'; 
import '../components/address_list.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        Provider.of<AlamatProvider>(context, listen: false).fetchAlamat(userId);
      } else {
        print("User ID belum tersedia!");
      }
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
          'Pilih Alamat',
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
      body: AlamatList(
        onSelect: (selectedAlamat) {
          Provider.of<AlamatProvider>(
            context,
            listen: false,
          ).setSelectedAlamat(selectedAlamat);
          Navigator.pop(context);
        },
      ),
    );
  }
}
