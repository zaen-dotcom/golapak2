import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/profile/chat/ai_screen.dart';
import '../routes/order_navigation.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    OrderNavigation(),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => const AIScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  );
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 1.0),
                      end: Offset.zero,
                    ).animate(curvedAnimation),
                    child: FadeTransition(
                      opacity: curvedAnimation,
                      child: child,
                    ),
                  );
                },
              ),
            );
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1F38),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.chat_bubble, color: Colors.white, size: 28),
                Transform.translate(
                  offset: const Offset(0, -3),
                  child: const Text(
                    'AI',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
