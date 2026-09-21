import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HoSoScreen()),
  );
}

class HoSoScreen extends StatefulWidget {
  const HoSoScreen({super.key});

  @override
  State<HoSoScreen> createState() => _HoSoScreenState();
}

class _HoSoScreenState extends State<HoSoScreen> {
  // Công tắc để demo lỗi tràn viền (overflow)
  bool coExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ Sơ Cá Nhân')),

      // 👉 [PHẦN 2-④] SingleChildScrollView: cho phép cuộn -> không tràn viền phía dưới
      body: SingleChildScrollView(
        // 👉 [PHẦN 2-③] Center + SizedBox: nội dung rộng 400px như màn hình điện thoại
        child: Center(
          child: SizedBox(
            width: 400,
            // 👉 [PHẦN 4-①] Padding: cách mép màn hình 16px
            child: Padding(
              padding: const EdgeInsets.all(16),

              // 👉 [PHẦN 2-①] Column: xếp các phần theo chiều dọc
              child: Column(
                children: [
                  // 1. Ảnh đại diện
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  const SizedBox(height: 12), // 👉 [PHẦN 2-②] SizedBox: khoảng cách

                  // 2. Tên và trường
                  const Text(
                    'Nguyễn Hải Ninh',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Sinh viên Đại học Thủy Lợi'),
                  const SizedBox(height: 20),

                  // 👉 [PHẦN 3-①] Row: 3 ô thống kê nằm ngang, Expanded chia đều
                  const Row(
                    children: [
                      Expanded(
                        child: OThongKe(so: '3', nhan: 'Năm học'),
                      ),
                      Expanded(
                        child: OThongKe(so: '10', nhan: 'Dự án'),
                      ),
                      Expanded(
                        child: OThongKe(so: '5', nhan: 'Kỹ năng'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. Thông tin liên hệ: mỗi dòng là một Row
                  const DongThongTin(
                    icon: Icons.phone,
                    noiDung: '0917 634 946',
                  ),
                  const DongThongTin(
                    icon: Icons.email,
                    noiDung: 'haininh320@gmail.com',
                  ),
                  const DongThongTin(
                    icon: Icons.school,
                    noiDung:
                        'Trường Đại học Thủy Lợi, 175 Tây Sơn, Đống Đa, Hà Nội',
                  ),
                  const SizedBox(height: 20),

                  // 👉 [PHẦN 5] Demo lỗi overflow
                  Row(
                    children: [
                      const Text('Demo overflow'),
                      Switch(
                        value: coExpanded,
                        onChanged: (v) => setState(() => coExpanded = v),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.info),
                      const SizedBox(width: 12),
                      if (coExpanded)
                        // 👉 [PHẦN 5 - BẬT] Có Expanded: chữ tự xuống dòng -> không lỗi
                        const Expanded(child: Text(gioiThieu))
                      else
                        // 👉 [PHẦN 5 - TẮT] Không có Expanded: chữ tràn ra ngoài -> lỗi vàng đen
                        const Text(gioiThieu),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const gioiThieu =
    'Em là sinh viên Đại học Thủy Lợi, yêu thích lập trình '
    'di động với Flutter và muốn trở thành lập trình viên giỏi.';

// Ô thống kê: Column gồm con số ở trên, nhãn ở dưới
class OThongKe extends StatelessWidget {
  final String so;
  final String nhan;
  const OThongKe({super.key, required this.so, required this.nhan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          so,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(nhan),
      ],
    );
  }
}

// 👉 [PHẦN 3-②] Dòng thông tin: Row gồm [Icon] [khoảng cách] [Chữ]
class DongThongTin extends StatelessWidget {
  final IconData icon;
  final String noiDung;
  const DongThongTin({super.key, required this.icon, required this.noiDung});

  @override
  Widget build(BuildContext context) {
    // 👉 [PHẦN 4-②] Padding dọc: các dòng cách nhau đều 8px
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          // Expanded: chữ dài tự xuống dòng, không tràn phải
          Expanded(child: Text(noiDung)),
        ],
      ),
    );
  }
}
