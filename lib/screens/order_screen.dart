import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/card_history.dart';
import '../providers/order_provider.dart';
import 'package:intl/intl.dart';
import '../screens/detail_order_screen.dart';
import '../components/alertdialog.dart';

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

  bool _canCancel(String? status) {
    return status == 'pending' || status == 'processing';
  }

  void _handleCancelOrder(BuildContext context, int orderId) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Batalkan Pesanan',
      message: 'Yakin ingin membatalkan pesanan ini?',
    );

    if (confirmed) {
      await Provider.of<OrderProvider>(context, listen: false)
          .cancelOrder(orderId);
    }
  }

  void _navigateToDetail(BuildContext context, String orderId) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: OrderDetailScreen(orderId: orderId),
          );
        },
      ),
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

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Stack(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _navigateToDetail(context, order.id.toString()),
                      child: OrderHistoryCard(
                        transactionCode: order.transactionCode,
                        totalQty: order.totalQty,
                        grandTotal: order.grandTotal,
                        date: DateFormat(
                          'yyyy-MM-dd HH:mm:ss',
                        ).format(order.date),
                        status: order.status,
                        cancelButton: null,
                      ),
                    ),
                    if (_canCancel(order.status))
                      Positioned(
                        right: 24,
                        bottom: 23,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: const Size(0, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed:
                              () => _handleCancelOrder(context, order.id),
                          child: const Text(
                            'Batalkan',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
