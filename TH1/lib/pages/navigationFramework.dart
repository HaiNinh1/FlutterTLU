import 'package:flutter/material.dart';

import 'editSubjectsPage.dart';
import 'homePage/homePage.dart';
import 'settingsPage.dart';

// Khung điều hướng bằng thanh tab dưới (Cashew: widgets/navigationFramework.dart).
// Đặt trong pages/ vì nó ghép các trang lại với nhau.
class NavigationFramework extends StatefulWidget {
  const NavigationFramework({super.key});

  @override
  State<NavigationFramework> createState() => _NavigationFrameworkState();
}

class _NavigationFrameworkState extends State<NavigationFramework> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [HomePage(), EditSubjectsPage(), SettingsPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description_rounded),
            label: 'Tài liệu',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Môn học',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
