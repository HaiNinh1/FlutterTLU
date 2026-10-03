// Chuẩn hoá chuỗi để tìm kiếm không phân biệt hoa/thường và dấu tiếng Việt.
// SQLite LIKE chỉ bỏ qua hoa/thường với ký tự ASCII, nên tầng database lưu sẵn
// một cột searchText đã chuẩn hoá và so khớp trên cột đó.

const Map<String, String> _vietnameseGroups = {
  'a': 'àáạảãâầấậẩẫăằắặẳẵ',
  'e': 'èéẹẻẽêềếệểễ',
  'i': 'ìíịỉĩ',
  'o': 'òóọỏõôồốộổỗơờớợởỡ',
  'u': 'ùúụủũưừứựửữ',
  'y': 'ỳýỵỷỹ',
  'd': 'đ',
};

final Map<String, String> _charToBase = {
  for (final entry in _vietnameseGroups.entries)
    for (final rune in entry.value.runes) String.fromCharCode(rune): entry.key,
};

// Dấu kết hợp (combining marks) khi chuỗi được gõ ở dạng tổ hợp NFD.
final RegExp _combiningMarks = RegExp('[̀-ͯ]');
final RegExp _whitespace = RegExp(r'\s+');

String normalizeForSearch(String input) {
  final lower = input.toLowerCase().replaceAll(_combiningMarks, '');
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_charToBase[char] ?? char);
  }
  return buffer.toString().replaceAll(_whitespace, ' ').trim();
}
