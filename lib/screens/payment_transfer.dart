import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/alertdialog.dart';

class PaymentTransferScreen extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final String accountName;
  final num totalAmount;

  const PaymentTransferScreen({
    Key? key,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.totalAmount,
  }) : super(key: key);

  String formatCurrency(num amount) {
    final intAmount = amount.toInt();
    return 'Rp ${intAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, 
        title: const Text(
          'Selesaikan Pembayaran',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Total Pembayaran
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: colorScheme.primary.withOpacity(0.2),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        formatCurrency(totalAmount),
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Informasi Rekening
              Text(
                'Transfer ke Rekening Berikut:',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Bank', bankName, textTheme),
                    _divider(),
                    _buildInfoRow('No. Rekening', accountNumber, textTheme),
                    _divider(),
                    _buildInfoRow('Atas Nama', accountName, textTheme),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// Petunjuk Transfer
              Text(
                'Petunjuk Transfer:',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              _buildBulletText(
                'Lakukan transfer ke rekening di atas sesuai nominal.',
                textTheme,
              ),
              _buildBulletText(
                'Gunakan metode transfer yang mendukung bukti pembayaran.',
                textTheme,
              ),
              _buildBulletText(
                'Simpan bukti transfer sebagai konfirmasi.',
                textTheme,
              ),
              _buildBulletText(
                'Klik tombol "Saya Sudah Transfer" setelah pembayaran.',
                textTheme,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      /// Tombol Konfirmasi Transfer
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: CustomButton(
            text: 'Saya Sudah Transfer',
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return CustomAlert(
                    title: 'Konfirmasi',
                    message:
                        'Pastikan Anda telah menyelesaikan pembayaran. Jika tidak, pesanan akan dibatalkan.',
                    confirmText: 'Ya',
                    cancelText: 'Batal',
                    onConfirm: () {
                      Navigator.of(context).pop(); 
                      Navigator.of(
                        context,
                      ).pop(); 
                    },
                    onCancel: () => Navigator.of(context).pop(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// Fungsi untuk baris informasi rekening
  Widget _buildInfoRow(String label, String value, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  /// Divider tipis antar info rekening
  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  /// Fungsi untuk bullet text pada petunjuk transfer
  Widget _buildBulletText(String text, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 18, height: 1.4, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
