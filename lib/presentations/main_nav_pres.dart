import 'package:flutter/material.dart';
import 'event_pres.dart';
import 'habit_pres.dart';
import 'profile_pres.dart';
import 'task_pres.dart';

class MainNavPres extends StatefulWidget {
  const MainNavPres({super.key});

  @override
  State<MainNavPres> createState() {
    return _MainNavPresState();
  }
}

class _MainNavPresState extends State<MainNavPres> {
  int _currentIndex = 0;

  // ponytail: IndexedStack menjaga state tab tetap aktif tanpa re-build berlebihan
  final List<Widget> _pages = const [
    TaskPres(),
    HabitPres(),
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
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Task',
          ),
          NavigationDestination(
            icon: Icon(Icons.repeat_outlined),
            selectedIcon: Icon(Icons.repeat),
            label: 'Habit',
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
