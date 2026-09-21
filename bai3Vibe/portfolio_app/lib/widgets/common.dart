import 'package:flutter/material.dart';

/// Khung chung cho các trang: có tiêu đề, cuộn được,
/// và giới hạn chiều rộng tối đa 1000px để không bị kéo giãn trên máy tính.
class PageLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PageLayout({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

/// Lưới tự đổi số cột theo chiều rộng: điện thoại 1 cột, tablet 2 cột, máy tính 3 cột.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        int columns = 1;
        if (width > 900) {
          columns = 3;
        } else if (width > 600) {
          columns = 2;
        }

        const double spacing = 16;
        final double itemWidth = (width - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

/// Nhãn nhỏ hiển thị tên công nghệ, ví dụ: "React", "Docker".
class TechChip extends StatelessWidget {
  final String label;

  const TechChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
