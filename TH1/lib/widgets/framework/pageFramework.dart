import 'package:flutter/material.dart';

// Khung trang chuẩn cho mọi màn hình (giống widgets/framework/pageFramework.dart
// của Cashew): AppBar lớn dạng sliver + danh sách sliver nội dung.
class PageFramework extends StatelessWidget {
  const PageFramework({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
    this.floatingActionButton,
    this.onBackButton,
    this.showBackButton = false,
  });

  final String title;
  final List<Widget> slivers;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  // Khi khác null: chặn thao tác quay lại và gọi hàm này (ví dụ hỏi huỷ thay đổi)
  final Future<void> Function()? onBackButton;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      floatingActionButton: floatingActionButton,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(title),
            automaticallyImplyLeading: showBackButton,
            actions: actions,
          ),
          ...slivers,
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
    if (onBackButton == null) return scaffold;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onBackButton!();
      },
      child: scaffold,
    );
  }
}
