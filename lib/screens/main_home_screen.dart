import 'package:flutter/material.dart';
import 'package:workout_app/screens/exercise_list_screen.dart';
import 'fovorite_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ExerciseListScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      // الـ body بيعرض الشاشة الحالية
      body: _screens[_currentIndex],

      // هنا الـ bottomNavigationBar الحقيقي والوحيد للتطبيق كله
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: navBgColor,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.orangeAccent.withOpacity(0.2),
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(
              Icons.fitness_center_rounded,
              color: Colors.orangeAccent,
            ),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(
              Icons.favorite_rounded,
              color: Colors.redAccent,
            ),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}