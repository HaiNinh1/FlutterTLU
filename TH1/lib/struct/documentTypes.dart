import 'package:flutter/material.dart';

import '../database/tables.dart';

// Thông tin hiển thị cho các enum của tầng database.
// Tầng database chỉ biết DocumentType.lecture...; tên tiếng Việt, biểu tượng
// và màu thuộc về struct/ để database không phụ thuộc Flutter UI.

extension DocumentTypeDisplay on DocumentType {
  String get label => switch (this) {
        DocumentType.lecture => 'Bài giảng',
        DocumentType.assignment => 'Bài tập',
        DocumentType.reference => 'Tham khảo',
      };

  IconData get icon => switch (this) {
        DocumentType.lecture => Icons.menu_book_rounded,
        DocumentType.assignment => Icons.assignment_rounded,
        DocumentType.reference => Icons.link_rounded,
      };

  Color get color => switch (this) {
        DocumentType.lecture => const Color(0xff1e88e5),
        DocumentType.assignment => const Color(0xffe53935),
        DocumentType.reference => const Color(0xff8e24aa),
      };
}

extension DocumentSortDisplay on DocumentSort {
  String get label => switch (this) {
        DocumentSort.newest => 'Mới nhất',
        DocumentSort.oldest => 'Cũ nhất',
        DocumentSort.titleAZ => 'Tên A → Z',
        DocumentSort.dueDate => 'Hạn nộp gần nhất',
      };
}

// Đổi mã lỗi nghiệp vụ của tầng database thành câu thông báo cho người dùng
String validationMessage(String code) {
  return switch (code) {
    'title-empty' => 'Vui lòng nhập tên tài liệu',
    'title-too-long' => 'Tên tài liệu tối đa $TITLE_LIMIT ký tự',
    'subject-not-found' => 'Môn học không còn tồn tại, hãy chọn môn khác',
    'link-invalid' => 'Đường dẫn URL không hợp lệ',
    'subject-empty' => 'Vui lòng nhập tên môn học',
    'subject-too-long' => 'Tên môn học tối đa $NAME_LIMIT ký tự',
    'subject-duplicate' => 'Môn học này đã tồn tại',
    _ => 'Có lỗi xảy ra ($code)',
  };
}
