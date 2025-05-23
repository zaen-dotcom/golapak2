import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../components/text_field.dart';
import '../../components/button.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';
import '../../components/alertdialog.dart';

class UpdateAddressScreen extends StatefulWidget {
  final int addressId;
  final String initialName;
  final String initialPhone;
  final String initialAddress;
  final bool initialIsMain;
  final double initialLatitude;
  final double initialLongitude;

  const UpdateAddressScreen({
    Key? key,
    required this.addressId,
    required this.initialName,
    required this.initialPhone,
    required this.initialAddress,
    required this.initialIsMain,
    required this.initialLatitude,
    required this.initialLongitude,
  }) : super(key: key);

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isMainAddress = false;
  bool _isLoading = false;

  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _phoneController.text = widget.initialPhone;
    _addressController.text = widget.initialAddress;
    _isMainAddress = widget.initialIsMain;
    _selectedLatLng = LatLng(widget.initialLatitude, widget.initialLongitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_selectedLatLng != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _selectedLatLng!, zoom: 17.0),
        ),
      );
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate() || _selectedLatLng == null) return;

    setState(() => _isLoading = true);
    final userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId == null) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => CustomAlert(
              title: 'Gagal',
              message: 'User ID tidak ditemukan.',
              confirmText: 'OK',
              onConfirm: () => Navigator.of(context).pop(),
            ),
      );
      return;
    }

    final success = await updateAddress({
      'id': widget.addressId,
      'user_id': userId,
      'name': _nameController.text,
      'phone_number': _phoneController.text,
      'address': _addressController.text,
      'main_address': _isMainAddress,
      'latitude': _selectedLatLng!.latitude,
      'longitude': _selectedLatLng!.longitude,
    });

    setState(() => _isLoading = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (success) {
          return CustomAlert(
            title: 'Berhasil',
            message: 'Alamat berhasil diperbarui.',
            confirmText: 'OK',
            onConfirm: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          );
        } else {
          return CustomAlert(
            title: 'Gagal',
            message: 'Gagal mengupdate alamat. Silakan coba lagi.',
            confirmText: 'Tutup',
            onConfirm: () => Navigator.of(context).pop(),
          );
        }
      },
    );
  }

  Future<void> _onBackPressed() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => CustomAlert(
            title: 'Konfirmasi Keluar',
            message:
                'Anda yakin ingin keluar? Perubahan apapun tidak tersimpan.',
            confirmText: 'Ya, Keluar',
            onConfirm: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            cancelText: 'Batal',
            onCancel: () => Navigator.of(context).pop(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Alamat',
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
          onPressed: _onBackPressed,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                CustomTextField(
                  label: 'Nama Penerima',
                  hintText: 'Masukkan nama',
                  controller: _nameController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Nama wajib diisi'
                              : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Nomor HP',
                  hintText: 'Masukkan nomor HP',
                  controller: _phoneController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Nomor HP wajib diisi'
                              : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Alamat Lengkap',
                  hintText: 'Masukkan alamat lengkap',
                  controller: _addressController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Alamat wajib diisi'
                              : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Titik Lokasi (koordinat):',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _selectedLatLng!,
                          zoom: 17.0,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onCameraMove: (position) {
                          setState(() {
                            _selectedLatLng = position.target;
                          });
                        },
                      ),
                      // Pin statis di tengah layar, tanda lokasi yang dipilih
                      const Icon(
                        Icons.location_pin,
                        size: 36,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isMainAddress,
                      onChanged: (value) {
                        setState(() {
                          _isMainAddress = value!;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Jadikan sebagai alamat utama',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Update Alamat',
                  isLoading: _isLoading,
                  onPressed: _handleUpdate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
