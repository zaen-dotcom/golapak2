import 'package:flutter/material.dart';
import '../screens/order_screen.dart';
import '../screens/history_screen.dart';

class OrderNavigation extends StatelessWidget {
  const OrderNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const SizedBox(height: 17),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              dividerColor:
                  Colors.transparent, 
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
              indicatorPadding: const EdgeInsets.all(6),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    size: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  text: 'Pesanan',
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
                Tab(
                  icon: Icon(
                    Icons.history_outlined,
                    size: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  text: 'Riwayat',
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(children: [OrderScreen(), HistoryScreen()]),
          ),
        ],
      ),
    );
  }
}
