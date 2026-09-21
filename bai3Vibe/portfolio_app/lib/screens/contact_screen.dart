import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/profile_data.dart';
import '../widgets/common.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // Mở link bằng ứng dụng phù hợp: trình duyệt, app email, app gọi điện
  void openLink(String link) {
    launchUrl(Uri.parse(link));
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Liên hệ',
      children: [
        const Text('Hãy liên hệ với mình qua các kênh dưới đây:'),
        const SizedBox(height: 16),
        ResponsiveGrid(
          children: [
            contactButton(Icons.email, 'Email', myEmail, Colors.red, 'mailto:$myEmail'),
            contactButton(Icons.code, 'GitHub', 'github.com/HaiNinh1', Colors.black, myGithub),
            contactButton(Icons.phone, 'Điện thoại', myPhone, Colors.green, 'tel:$myPhone'),
          ],
        ),
      ],
    );
  }

  // Tạo 1 nút liên hệ
  Widget contactButton(IconData icon, String label, String value, Color color, String link) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => openLink(link),
      ),
    );
  }
}
