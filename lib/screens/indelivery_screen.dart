import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/card_history.dart';
import '../providers/shipping_provider.dart';
import '../screens/indelivery_detail_screen.dart';

class InDeliveryScreen extends StatefulWidget {
  const InDeliveryScreen({super.key});

  @override
  State<InDeliveryScreen> createState() => _InDeliveryScreenState();
}

class _InDeliveryScreenState extends State<InDeliveryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ShippingProvider>(
        context,
        listen: false,
      ).loadShippingTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<ShippingProvider>(
        builder: (context, shippingProvider, _) {
          if (shippingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (shippingProvider.shippings.isEmpty) {
            return const Center(
              child: Text('Belum ada pesanan yang sedang diantar.'),
            );
          }

          final sortedShippings = [...shippingProvider.shippings];
          sortedShippings.sort((a, b) => b.date.compareTo(a.date));

         return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: sortedShippings.length,
              itemBuilder: (context, index) {
                final shipping = sortedShippings[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeliveryDetailScreen(orderId: shipping.id.toString()),
                      ),
                    );
                  },
                  child: OrderHistoryCard(
                    transactionCode: shipping.transactionCode,
                    totalQty: shipping.totalQty,
                    grandTotal: shipping.grandTotal,
                    date: shipping.date,
                    status: shipping.status,
                  ),
                );
              },
            );

        },
      ),
    );
  }
}
