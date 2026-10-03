import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/tables.dart';
import '../struct/databaseGlobal.dart';

// Phát danh sách môn học cho toàn ứng dụng qua Provider, giống
// widgets/watchAllWallets.dart của Cashew. Widget con đọc bằng
// context.watch<List<Subject>>().
class WatchAllSubjects extends StatefulWidget {
  const WatchAllSubjects({super.key, required this.child});

  final Widget child;

  @override
  State<WatchAllSubjects> createState() => _WatchAllSubjectsState();
}

class _WatchAllSubjectsState extends State<WatchAllSubjects> {
  // Tạo stream một lần, tránh đăng ký lại mỗi lần build
  late final Stream<List<Subject>> _stream = database.watchAllSubjects();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Subject>>.value(
      value: _stream,
      initialData: const [],
      child: widget.child,
    );
  }
}
