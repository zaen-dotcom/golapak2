import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/colors.dart';
import '../../components/info_item.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final result = await getUser();
    if (mounted) {
      setState(() {
        user = result;
      });
    }
  }

  Widget buildSkeletonItem(IconData icon, Color iconColor) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGreyBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 140, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(height: 12, width: 200, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            children:
                user == null
                    ? [
                      buildSkeletonItem(Icons.person_outline, Colors.orange),
                      const SizedBox(height: 12),
                      buildSkeletonItem(Icons.email_outlined, Colors.blue),
                      const SizedBox(height: 12),
                      buildSkeletonItem(Icons.phone_outlined, Colors.lightBlue),
                    ]
                    : [
                      InfoItem(
                        icon: Icons.person_outline,
                        iconColor: Colors.orange,
                        text: 'FULL NAME\n${user!.name}',
                      ),
                      const SizedBox(height: 12),
                      InfoItem(
                        icon: Icons.email_outlined,
                        iconColor: Colors.blue,
                        text: 'EMAIL\n${user!.email}',
                      ),
                      const SizedBox(height: 12),
                      InfoItem(
                        icon: Icons.phone_outlined,
                        iconColor: Colors.lightBlue,
                        text: 'PHONE NUMBER\n${user!.phoneNumber}',
                      ),
                    ],
          ),
        ),
      ),
    );
  }
}
