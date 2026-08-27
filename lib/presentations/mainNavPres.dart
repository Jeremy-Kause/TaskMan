import 'package:flutter/material.dart';
import 'calenderPres.dart';
import 'homePres.dart';
import 'profilePres.dart';

class MainNavPres extends StatefulWidget {
  const MainNavPres({super.key});

  @override
  State<MainNavPres> createState(){
    return _MainNavPresState();
  }
}

class _MainNavPresState extends State<MainNavPres> {
  int _currentIndex = 0;

  // ponytail: IndexedStack menjaga state tab tetap aktif tanpa re-build berlebihan
  final List<Widget> _pages = const [
    HomePres(),
    CalenderPres(),
    ProfilePres(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide, // ponytail: icon-only navigation
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Kalender',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
