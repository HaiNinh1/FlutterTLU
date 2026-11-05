import 'package:flutter/material.dart';

import 'habit_form_screen.dart';
import 'stats_screen.dart';
import 'today_screen.dart';

/// Khung chính: thanh điều hướng dưới với 2 tab "Hôm nay" và "Thống kê".
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [TodayScreen(), StatsScreen()],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton.extended(
              key: const ValueKey('fab-add'),
              onPressed: () => HabitFormScreen.open(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Thêm thói quen'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            key: ValueKey('tab-today'),
            icon: Icon(Icons.check_circle_outline_rounded),
            selectedIcon: Icon(Icons.check_circle_rounded),
            label: 'Hôm nay',
          ),
          NavigationDestination(
            key: ValueKey('tab-stats'),
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }
}
