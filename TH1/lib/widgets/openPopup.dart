import 'package:flutter/material.dart';

// Hộp thoại dùng chung, giống budget/lib/widgets/openPopup.dart của Cashew.

enum DeletePopupAction { cancel, delete }

// Sau khi xoá thì đóng bao nhiêu trang (giống RoutesToPopAfterDelete của Cashew)
enum RoutesToPopAfterDelete { none, one }

Future<T?> openPopup<T>(
  BuildContext context, {
  required String title,
  IconData? icon,
  String? subtitle,
  String? description,
  String? onSubmitLabel,
  T? submitValue,
  String? onCancelLabel,
  T? cancelValue,
  bool destructive = false,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;
      return AlertDialog(
        icon: icon == null
            ? null
            : Icon(icon, color: destructive ? colors.error : colors.primary),
        title: Text(title, textAlign: TextAlign.center),
        content: (subtitle == null && description == null)
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (subtitle != null)
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Text(description, textAlign: TextAlign.center),
                  ],
                ],
              ),
        actions: [
          if (onCancelLabel != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(cancelValue),
              child: Text(onCancelLabel),
            ),
          if (onSubmitLabel != null)
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: colors.error,
                      foregroundColor: colors.onError,
                    )
                  : null,
              onPressed: () => Navigator.of(context).pop(submitValue),
              child: Text(onSubmitLabel),
            ),
        ],
      );
    },
  );
}

Future<DeletePopupAction?> openDeletePopup(
  BuildContext context, {
  required String title,
  String? subtitle,
  String? description,
}) {
  return openPopup<DeletePopupAction>(
    context,
    title: title,
    subtitle: subtitle,
    description: description,
    icon: Icons.delete_rounded,
    destructive: true,
    onCancelLabel: 'Huỷ',
    cancelValue: DeletePopupAction.cancel,
    onSubmitLabel: 'Xoá',
    submitValue: DeletePopupAction.delete,
  );
}

// Hỏi trước khi rời trang khi còn thay đổi chưa lưu. Trả về true nếu bỏ thay đổi.
Future<bool> discardChangesPopup(BuildContext context) async {
  final result = await openPopup<bool>(
    context,
    title: 'Bỏ các thay đổi?',
    description: 'Những gì bạn vừa nhập sẽ không được lưu.',
    icon: Icons.warning_amber_rounded,
    onCancelLabel: 'Ở lại',
    cancelValue: false,
    onSubmitLabel: 'Bỏ thay đổi',
    submitValue: true,
    destructive: true,
  );
  return result ?? false;
}
