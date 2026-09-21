// =============================================================================
// Ứng dụng: Hello World Flutter
// Mô tả   : Ứng dụng Flutter cơ bản hiển thị dòng chữ "Hello World".
//           Có thêm một nút bấm để đổi lời chào nhằm minh hoạ cách quản lý
//           trạng thái (state) trong Flutter.
// =============================================================================

// Thư viện material.dart cung cấp bộ widget theo chuẩn Material Design của
// Google (Scaffold, AppBar, Text, Button...). Đây là thư viện nền tảng cho
// hầu hết các ứng dụng Flutter.
import 'package:flutter/material.dart';

/// Hàm main() là điểm bắt đầu (entry point) của mọi chương trình Dart.
/// runApp() nhận vào một widget gốc và gắn nó vào cây widget để vẽ lên màn hình.
void main() {
  runApp(const MyApp());
}

/// MyApp là widget gốc (root widget) của ứng dụng.
///
/// Kế thừa StatelessWidget vì widget này KHÔNG có trạng thái thay đổi theo
/// thời gian — nó chỉ dựng khung ứng dụng một lần rồi giữ nguyên.
class MyApp extends StatelessWidget {
  // Constructor hằng (const) giúp Flutter tái sử dụng đối tượng, tăng hiệu năng.
  // `super.key` truyền khoá định danh widget lên lớp cha.
  const MyApp({super.key});

  // Phương thức build() mô tả giao diện của widget.
  // Flutter gọi build() mỗi khi cần vẽ lại widget này.
  @override
  Widget build(BuildContext context) {
    // MaterialApp là widget bao ngoài, cung cấp: điều hướng (navigation),
    // giao diện (theme), tiêu đề ứng dụng...
    return MaterialApp(
      // Tiêu đề ứng dụng (hiển thị ở trình quản lý tác vụ của hệ điều hành).
      title: 'Hello World Flutter',

      // Ẩn dải băng "DEBUG" ở góc phải trên màn hình khi chạy chế độ debug.
      debugShowCheckedModeBanner: false,

      // Cấu hình bảng màu/giao diện chung cho toàn ứng dụng.
      // colorSchemeSeed: Flutter tự sinh ra bộ màu hài hoà từ một màu gốc.
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true, // Dùng Material Design phiên bản 3.
      ),

      // home: màn hình đầu tiên được hiển thị khi mở ứng dụng.
      home: const HomePage(),
    );
  }
}

/// HomePage là màn hình chính của ứng dụng.
///
/// Kế thừa StatefulWidget vì nội dung lời chào CÓ THỂ thay đổi khi người dùng
/// bấm nút. StatefulWidget luôn đi kèm một lớp State tương ứng.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // createState() tạo ra đối tượng State lưu giữ dữ liệu của màn hình.
  @override
  State<HomePage> createState() => _HomePageState();
}

/// Lớp State chứa dữ liệu (biến trạng thái) và phần dựng giao diện của HomePage.
/// Dấu gạch dưới `_` ở đầu tên lớp nghĩa là lớp này chỉ dùng nội bộ trong file.
class _HomePageState extends State<HomePage> {
  // Danh sách các lời chào sẽ lần lượt được hiển thị.
  static const List<String> _loiChao = <String>[
    'Hello World',
    'Xin chào Flutter',
    'Chào mừng bạn!',
  ];

  // Biến trạng thái: vị trí của lời chào đang hiển thị trong danh sách trên.
  int _viTri = 0;

  /// Hàm xử lý khi người dùng bấm nút "Đổi lời chào".
  void _doiLoiChao() {
    // setState() báo cho Flutter biết dữ liệu đã thay đổi, nhờ đó Flutter sẽ
    // gọi lại build() để vẽ lại giao diện với dữ liệu mới.
    setState(() {
      // Toán tử % (chia lấy dư) giúp quay vòng về đầu danh sách khi đến cuối.
      _viTri = (_viTri + 1) % _loiChao.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold cung cấp bố cục chuẩn của một màn hình Material:
    // thanh tiêu đề (appBar), phần thân (body), nút nổi, menu...
    return Scaffold(
      // AppBar: thanh tiêu đề nằm trên cùng màn hình.
      appBar: AppBar(
        title: const Text('Hello World Flutter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      // body: phần nội dung chính của màn hình.
      // Center căn phần tử con vào chính giữa màn hình.
      body: Center(
        // Column sắp xếp các widget con theo chiều dọc (từ trên xuống dưới).
        child: Column(
          // Căn các widget con vào giữa theo trục dọc.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Biểu tượng minh hoạ phía trên dòng chữ.
            Icon(
              Icons.flutter_dash,
              size: 96,
              color: Theme.of(context).colorScheme.primary,
            ),

            // SizedBox dùng như khoảng trống để tạo giãn cách giữa các widget.
            const SizedBox(height: 24),

            // Text hiển thị lời chào hiện tại, lấy theo biến trạng thái _viTri.
            Text(
              _loiChao[_viTri],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Dòng chữ phụ, mô tả ngắn gọn về ứng dụng.
            const Text(
              'Ứng dụng Flutter đầu tiên của tôi',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 32),

            // Nút bấm: khi nhấn sẽ gọi hàm _doiLoiChao() ở trên.
            ElevatedButton.icon(
              onPressed: _doiLoiChao,
              icon: const Icon(Icons.refresh),
              label: const Text('Đổi lời chào'),
            ),
          ],
        ),
      ),
    );
  }
}
