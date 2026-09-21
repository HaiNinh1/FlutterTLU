import 'package:flutter/material.dart';

import 'screens/contact_screen.dart';
import 'screens/experience_screen.dart';
import 'screens/home_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/skills_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nguyễn Hải Ninh - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const MainPage(),
    );
  }
}

/// Trang chính: chứa 5 trang con và thanh menu để chuyển trang.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Vị trí trang đang được chọn (0 = Trang chủ)
  int currentIndex = 0;

  final List<String> titles = ['Trang chủ', 'Kỹ năng', 'Kinh nghiệm', 'Dự án', 'Liên hệ'];
  final List<IconData> icons = [Icons.home, Icons.star, Icons.work, Icons.folder, Icons.mail];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onChangePage: changePage),
      const SkillsScreen(),
      const ExperienceScreen(),
      const ProjectsScreen(),
      const ContactScreen(),
    ];

    // Lấy chiều rộng màn hình để quyết định bố cục
    final double screenWidth = MediaQuery.of(context).size.width;

    // Màn hình rộng (máy tính): menu nằm bên trái
    if (screenWidth >= 800) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: changePage,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (int i = 0; i < titles.length; i++)
                  NavigationRailDestination(
                    icon: Icon(icons[i]),
                    label: Text(titles[i]),
                  ),
              ],
            ),
            Expanded(child: pages[currentIndex]),
          ],
        ),
      );
    }

    // Màn hình hẹp (điện thoại): menu nằm ở dưới
    return Scaffold(
      appBar: AppBar(title: Text(titles[currentIndex])),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: changePage,
        destinations: [
          for (int i = 0; i < titles.length; i++)
            NavigationDestination(icon: Icon(icons[i]), label: titles[i]),
        ],
      ),
    );
  }
}
