import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Bật cây semantics (hỗ trợ trình đọc màn hình) trên web.
    SemanticsBinding.instance.ensureSemantics();
  }
  // Tham số URL chỉ dùng khi quay video demo trên Chrome:
  // ?reset=1 xóa dữ liệu cũ, ?touches=1 vẽ vòng tròn tại điểm chạm.
  final q = Uri.base.queryParameters;
  runApp(
    await bootstrap(
      resetData: kIsWeb && q['reset'] == '1',
      showTouches: kIsWeb && q['touches'] == '1',
    ),
  );
}
