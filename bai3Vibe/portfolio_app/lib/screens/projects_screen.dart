import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../widgets/common.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Dự án đã làm',
      children: [
        ResponsiveGrid(
          children: [
            for (final project in projects)
              Card(
                // InkWell giúp Card bấm được
                child: InkWell(
                  onTap: () {
                    // Mở trang chi tiết dự án
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDetailScreen(project: project),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.folder_open, size: 36, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(
                          project.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(project.summary),
                        const SizedBox(height: 12),
                        const Text(
                          'Xem chi tiết →',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
