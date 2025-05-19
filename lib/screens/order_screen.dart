import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/ordercard.dart';
import '../services/dummy_order.dart';
import '../theme/colors.dart';
import '../screens/detailorder_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: dummyOrders.length,
      itemBuilder: (context, index) {
        final order = dummyOrders[index];
        return OrderCard(
          title: order['restaurant_name'] as String,
          subtitle:
              '\$${order['price']} | ${order['items']} Items | ${order['date']}',
          orderId: order['transaction_code'] as String,
          imageUrl: order['imageUrl'] as String,
          statusText: order['status'] as String,
          statusColor: getStatusColor(order['status'] as String),
          actions: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Detail Order',
                  isOutlined: false,
                  onPressed: () {Navigator.push(context, MaterialPageRoute(
                    builder: (context) => OrderDetailPage(orderData: dummyOrders[index]),
                  ));
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  isOutlined: true,
                  onPressed: () {Navigator.push(context, MaterialPageRoute(
                    builder: (context) => OrderDetailPage(orderData: dummyOrders[index]),
                  ));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Menunggu konfirmasi':
        return AppColors.pending;
      case 'Sedang dimasak':
        return AppColors.cooking;
      case 'Sedang diantar':
        return AppColors.delivering;
      default:
        return AppColors.success;
    }
  }
}
