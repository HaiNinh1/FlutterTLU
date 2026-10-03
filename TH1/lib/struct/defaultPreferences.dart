// Giá trị mặc định của mọi khoá cài đặt, giống getDefaultPreferences() của Cashew.
// Khi thêm cài đặt mới chỉ cần thêm khoá ở đây; settings.dart sẽ tự bổ sung
// khoá còn thiếu cho người dùng cũ.
Map<String, dynamic> getDefaultPreferences() {
  return {
    'theme': 'system', // system | light | dark
    'accentColor': '0xff2e7d32',
    'documentSort': 'newest', // tên của DocumentSort
    'showDescriptionInList': true,
    'hasInitializedDefaults': false,
  };
}
