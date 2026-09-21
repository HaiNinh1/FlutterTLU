import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../widgets/common.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Kỹ năng',
      children: [
        ResponsiveGrid(
          children: [
            // Mỗi nhóm kỹ năng là một Card
            for (final group in skills)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      // Wrap: tự xuống dòng khi hết chỗ
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final item in group.items) TechChip(item),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
