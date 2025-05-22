import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/card_history.dart';
import '../providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<OrderProvider>(context, listen: false).loadOrders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.orders.isEmpty) {
            return const Center(child: Text('Belum ada pesanan.'));
          }

          final sortedOrders = [...orderProvider.orders];
          sortedOrders.sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: sortedOrders.length,
            itemBuilder: (context, index) {
              final order = sortedOrders[index];
              return OrderHistoryCard(
                transactionCode: order.transactionCode,
                totalQty: order.totalQty,
                grandTotal: order.grandTotal,
                date: DateFormat('yyyy-MM-dd HH:mm:ss').format(order.date),
                status: order.status,
              );
            },
          );
        },
      ),
    );
  }
}
