import 'package:flutter/material.dart';
import '../screens/category/makanan.dart';
import '../screens/category/minuman.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [Tab(text: 'Makanan'), Tab(text: 'Minuman')],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height:
                MediaQuery.of(context).size.height *
                0.8, // atau sesuaikan lebih fleksibel
            child: TabBarView(
              controller: _tabController,
              children: const [MakananScreen(), MinumanScreen()],
            ),
          ),
        ],
      ),
    );
  }
}
