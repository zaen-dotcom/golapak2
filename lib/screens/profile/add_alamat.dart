import 'package:flutter/material.dart';
import '../../components/button.dart';
import '../../components/text_field.dart';
import '../../components/alertdialog.dart';
import '../../services/user_service.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class AddAlamatScreen extends StatefulWidget {
  const AddAlamatScreen({Key? key}) : super(key: key);

  @override
  State<AddAlamatScreen> createState() => _AddAlamatScreenState();
}

class _AddAlamatScreenState extends State<AddAlamatScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool isMainAddress = true;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value))
      return 'Nama hanya boleh huruf';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (value.length < 12) {
      return 'Nomor telepon minimal 12 digit';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Hanya angka yang diperbolehkan';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) return 'Alamat tidak boleh kosong';
    return null;
  }

  Future<void> _submitAddress() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId == null) {
      print('User ID tidak ditemukan');
      setState(() => _isLoading = false);
      return;
    }

    final result = await addAddress(
      userId: userId,
      name: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
      isMainAddress: isMainAddress,
    );

    if (result != null && result['status'] == 'success') {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => CustomAlert(
              title: 'Berhasil',
              message: result['message'] ?? 'Alamat berhasil ditambahkan',
              confirmText: 'OK',
              onConfirm: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).pop();
                setState(() => _isLoading = false); 
              },
            ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => CustomAlert(
              title: 'Gagal',
              message: 'Terjadi kesalahan saat menambahkan alamat.',
              confirmText: 'OK',
              onConfirm: () {
                Navigator.of(context).pop();
                setState(() => _isLoading = false); 
              },
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tambah Alamat',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama lengkap Anda',
                controller: nameController,
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Nomor Telepon',
                hintText: 'Masukkan nomor telepon Anda',
                controller: phoneController,
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Alamat Lengkap',
                hintText: 'Masukkan alamat lengkap Anda',
                controller: addressController,
                validator: _validateAddress,
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih Alamat Utama',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isMainAddress,
                    onChanged:
                        (value) => setState(() => isMainAddress = value!),
                  ),
                  const Text('Alamat Utama'),
                  const SizedBox(width: 20),
                  Radio<bool>(
                    value: false,
                    groupValue: isMainAddress,
                    onChanged:
                        (value) => setState(() => isMainAddress = value!),
                  ),
                  const Text('Alamat Lain'),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Konfirmasi',
                isLoading: _isLoading,
                onPressed: _submitAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
