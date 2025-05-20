import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/menuitem.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse("whatsapp://send?phone=6282228753198");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      final Uri fallback = Uri.parse("https://wa.me/6282228753198");
      if (await canLaunchUrl(fallback)) {
        await launchUrl(fallback, mode: LaunchMode.externalApplication);
      } else {
        print("Tidak dapat membuka WhatsApp");
      }
    }
  }

  void _launchTikTok() async {
    final Uri tiktokWeb = Uri.parse(
      "https://www.tiktok.com/@mieayamsolo.bondowoso",
    );
    try {
      await launchUrl(tiktokWeb, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("Gagal membuka TikTok: $e");
    }
  }

  void _makePhoneCall() async {
    final Uri telUri = Uri(scheme: 'tel', path: '+6282228753198');
    try {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Tidak dapat melakukan panggilan: $e');
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
          'Hubungi Kami',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MenuItem(
              icon: FontAwesomeIcons.whatsapp,
              text: 'WhatsApp',
              iconColor: Colors.green,
              onTap: _launchWhatsApp,
            ),
            const SizedBox(height: 12),
            MenuItem(
              icon: FontAwesomeIcons.tiktok,
              text: 'TikTok',
              iconColor: Colors.black,
              onTap: _launchTikTok,
            ),
            const SizedBox(height: 12),
            MenuItem(
              icon: Icons.phone,
              text: 'Telepon',
              iconColor: Colors.blue,
              onTap: _makePhoneCall,
            ),
          ],
        ),
      ),
    );
  }
}
