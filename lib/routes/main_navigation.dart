import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/pesanan_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    PesananScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: IndexedStack(
          key: ValueKey<int>(_selectedIndex),
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: List.generate(3, (index) {
            final isSelected = _selectedIndex == index;
            IconData iconData;
            String label;

            switch (index) {
              case 0:
                iconData = Icons.home;
                label = 'Home';
                break;
              case 1:
                iconData = Icons.receipt_long;
                label = 'Pesanan';
                break;
              default:
                iconData = Icons.person;
                label = 'Profil';
            }

            return BottomNavigationBarItem(
              label: label,
              icon: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: isSelected ? 1.0 : 0.9,
                  end: isSelected ? 1.2 : 1.0,
                ),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                builder:
                    (context, value, child) => Transform.scale(
                      scale: value,
                      child: Icon(
                        iconData,
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                      ),
                    ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
