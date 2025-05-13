import 'package:flutter/material.dart';
import '../screens/category/makanan.dart';
import '../screens/category/minuman.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _selectedTabIndex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.white,
            elevation: 0,
            child: Container(
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
                dividerColor: Colors.transparent,
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
                tabs: const [Tab(text: 'Makanan'), Tab(text: 'Minuman')],
                onTap: (index) {
                  print('Tab diklik: $index (0: Makanan, 1: Minuman)');
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          IndexedStack(
            index: _selectedTabIndex,
            children: [MakananScreen(), MinumanScreen()],
          ),
        ],
      ),
    );
  }
}
