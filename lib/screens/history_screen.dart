import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_history_provider.dart';
import '../components/card_history.dart';
import 'detail_history_screen.dart'; // Ganti sesuai nama file detail history kamu

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TransactionHistoryProvider>(context, listen: false).loadTransactionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<TransactionHistoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.transactions.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat transaksi.'),
            );
          }

          final sortedTransactions = [...provider.transactions];
          sortedTransactions.sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: sortedTransactions.length,
            itemBuilder: (context, index) {
              final trx = sortedTransactions[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DetailHistoryScreen(), 
                    ),
                  );
                },
                child: OrderHistoryCard(
                  transactionCode: trx.transactionCode,
                  totalQty: trx.totalQty,
                  grandTotal: trx.grandTotal,
                  date: trx.date,
                  status: trx.status,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
