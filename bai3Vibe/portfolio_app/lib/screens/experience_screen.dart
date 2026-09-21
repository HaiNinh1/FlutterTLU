import 'package:flutter/material.dart';

import '../data/profile_data.dart';
import '../widgets/common.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Kinh nghiệm & Học vấn',
      children: [
        for (final exp in experiences)
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exp.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${exp.place}  •  ${exp.time}',
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  for (final detail in exp.details)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(detail),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
