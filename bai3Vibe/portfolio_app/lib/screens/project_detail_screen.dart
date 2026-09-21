import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../widgets/common.dart';

class ProjectDetailScreen extends StatelessWidget {
  // Dự án được truyền từ trang Dự án sang
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar tự có nút quay lại (Navigator.pop)
      appBar: AppBar(title: const Text('Chi tiết dự án')),
      body: PageLayout(
        title: project.name,
        children: [
          Text(project.summary, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          const Text(
            'Công nghệ sử dụng',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tech in project.techStack) TechChip(tech),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Công việc chính',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          for (final task in project.tasks)
            ListTile(
              leading: const Icon(Icons.arrow_right, color: Colors.blue),
              title: Text(task),
            ),
        ],
      ),
    );
  }
}
