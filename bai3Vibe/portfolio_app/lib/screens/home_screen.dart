import 'package:flutter/material.dart';

import '../data/profile_data.dart';

class HomeScreen extends StatelessWidget {
  // Hàm do MainPage truyền vào, dùng để chuyển sang trang khác
  final Function(int) onChangePage;

  const HomeScreen({super.key, required this.onChangePage});

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 800;

    // Ảnh đại diện hình tròn
    final Widget avatar = CircleAvatar(
      radius: isWide ? 130 : 80,
      backgroundImage: const AssetImage(myAvatar),
    );

    // Phần chữ giới thiệu + 2 nút bấm
    final Widget info = Column(
      crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        const Text('Xin chào, mình là', style: TextStyle(fontSize: 18)),
        const Text(
          myName,
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const Text(
          myRole,
          style: TextStyle(fontSize: 22, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        Text(
          myIntro,
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () => onChangePage(3), // 3 = trang Dự án
              icon: const Icon(Icons.folder),
              label: const Text('Xem dự án'),
            ),
            OutlinedButton.icon(
              onPressed: () => onChangePage(4), // 4 = trang Liên hệ
              icon: const Icon(Icons.mail),
              label: const Text('Liên hệ'),
            ),
          ],
        ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          // Máy tính: ảnh bên trái, chữ bên phải (Row)
          // Điện thoại: ảnh ở trên, chữ ở dưới (Column)
          child: isWide
              ? Row(
                  children: [
                    avatar,
                    const SizedBox(width: 48),
                    Expanded(child: info),
                  ],
                )
              : Column(
                  children: [
                    avatar,
                    const SizedBox(height: 24),
                    info,
                  ],
                ),
        ),
      ),
    );
  }
}
