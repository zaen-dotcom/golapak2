import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/ordercard.dart';
import '../theme/colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        OrderCard(
          title: 'Starbucks',
          subtitle: '\$10.20 | 01 Items | 30 JAN, 12:00',
          orderId: '240112',
          imageUrl: 'images/gorengan.jpeg',
          statusText: 'Canceled',
          statusColor: AppColors.error,
          actions: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Rate',
                  isOutlined: false,
                  onPressed: () {
                    print('Rate Starbucks diklik');
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Re-Order',
                  isOutlined: true,
                  onPressed: () {
                    print('Re-Order Starbucks diklik');
                  },
                ),
              ),
            ],
          ),
        ),
        OrderCard(
          title: 'KFC',
          subtitle: '\$22.80 | 02 Items | 28 JAN, 18:30',
          orderId: '240109',
          imageUrl: 'images/esteler.png',
          statusText: 'Completed',
          statusColor: AppColors.success,
          actions: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Rate',
                  isOutlined: false,
                  onPressed: () {
                    print('Rate KFC diklik');
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Re-Order',
                  isOutlined: true,
                  onPressed: () {
                    print('Re-Order KFC diklik');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
