import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/ordercard.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        OrderCard(
          title: 'Pizza Hut',
          subtitle: '\$35.25 | 03 Items | 16 MEI, 17:10',
          orderId: '162432',
          imageUrl: 'images/bakso.jpg',
          actions: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Detail Order',
                  isOutlined: false,
                  onPressed: () {
                    print('Detail Order Pizza Hut diklik');
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  isOutlined: true,
                  onPressed: () {
                    print('Cancel Order Pizza Hut diklik');
                  },
                ),
              ),
            ],
          ),
        ),
        OrderCard(
          title: 'Burger King',
          subtitle: '\$18.40 | 02 Items | 16 MEI, 15:45',
          orderId: '162987',
          imageUrl: 'images/bakreng.jpg',
          actions: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Detail Order',
                  isOutlined: false,
                  onPressed: () {
                    print('Detail Order Burger King diklik');
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  isOutlined: true,
                  onPressed: () {
                    print('Cancel Order Burger King diklik');
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
