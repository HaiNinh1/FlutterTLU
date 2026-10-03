import 'package:flutter/material.dart';

// Snackbar toàn cục: gọi được từ bất cứ đâu mà không cần BuildContext,
// tương tự globalSnackbar/openSnackbar của Cashew.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void openSnackbar({
  required String title,
  String? description,
  IconData? icon,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = scaffoldMessengerKey.currentState;
  if (messenger == null) return;
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      // Snackbar có nút (ví dụ "Hoàn tác") mặc định không tự tắt; giới hạn 4 giây
      // để không thể hoàn tác một thao tác đã quá lâu (Cashew dùng 3,5 giây).
      persist: false,
      duration: const Duration(seconds: 4),
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (description != null)
                  Text(description,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(label: actionLabel, onPressed: onAction)
          : null,
    ),
  );
}
