import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../components/menuitem.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Info Pribadi',
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
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGreyBlue, width: 1.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MenuItem(
                icon: Icons.person_outline,
                iconColor: Colors.orange,
                text: 'FULL NAME\nBabayo',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.email_outlined,
                iconColor: Colors.blue,
                text: 'EMAIL\nhello@halallab.co',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.phone_outlined,
                iconColor: Colors.lightBlue,
                text: 'PHONE NUMBER\n08123456789',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
