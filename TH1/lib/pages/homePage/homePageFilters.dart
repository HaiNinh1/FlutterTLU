import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../database/tables.dart';

// Hàng chip lọc theo môn học
class HomePageFilters extends StatelessWidget {
  const HomePageFilters({
    super.key,
    required this.subjects,
    required this.selectedSubjectFks,
    required this.onToggleSubject,
  });

  final List<Subject> subjects;
  final Set<String> selectedSubjectFks;
  final ValueChanged<String> onToggleSubject;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) return const SizedBox(height: 8);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          for (final subject in subjects)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: CircleAvatar(
                  backgroundColor: colorFromString(subject.colour),
                  radius: 6,
                ),
                label: Text(subject.name),
                selected: selectedSubjectFks.contains(subject.subjectPk),
                onSelected: (_) => onToggleSubject(subject.subjectPk),
              ),
            ),
        ],
      ),
    );
  }
}
