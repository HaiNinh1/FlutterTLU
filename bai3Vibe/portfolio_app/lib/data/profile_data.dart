// File này chứa toàn bộ thông tin lấy từ CV.
// Muốn sửa nội dung app thì chỉ cần sửa ở đây.

class SkillGroup {
  final String title;
  final List<String> items;

  const SkillGroup(this.title, this.items);
}

class Experience {
  final String title;
  final String place;
  final String time;
  final List<String> details;

  const Experience(this.title, this.place, this.time, this.details);
}

class Project {
  final String name;
  final String summary;
  final List<String> techStack;
  final List<String> tasks;

  const Project(this.name, this.summary, this.techStack, this.tasks);
}

// ---------------- THÔNG TIN CÁ NHÂN ----------------
const String myName = 'Nguyễn Hải Ninh';
const String myRole = 'Fullstack Developer';
const String myAvatar = 'assets/images/avatar.jpg';
const String myIntro =
    'Sinh viên ngành Kỹ thuật Phần mềm - Đại học Thủy Lợi . '
    'Mình thích xây dựng sản phẩm hoàn chỉnh từ backend, frontend đến triển khai Docker, '
    'và đã làm các dự án thực tế về quản lý quy trình, quản lý hồ sơ '
    'và tự động hóa thiết kế tuyến cáp viễn thông có ứng dụng AI.';

// ---------------- KỸ NĂNG ----------------
const List<SkillGroup> skills = [
  SkillGroup('Frontend', ['HTML', 'CSS', 'React', 'Svelte']),
  SkillGroup('Backend', ['Java', 'JavaScript', 'C#', 'PHP', 'Python']),
  SkillGroup('Frameworks', ['Laravel', 'Spring', 'JavaFX', 'WinForms']),
  SkillGroup('Database', ['MySQL', 'PostgreSQL', 'MariaDB', 'MongoDB']),
  SkillGroup('Tools', ['Git', 'GitHub', 'Docker']),
  SkillGroup('Ngoại ngữ', ['Tiếng Anh B1']),
];

// ---------------- KINH NGHIỆM ----------------
const List<Experience> experiences = [
  Experience('Fullstack Developer', 'Các dự án thực tế', 'Hiện tại', [
    'Xây dựng hệ thống web với Laravel REST API + React TypeScript.',
    'Thiết kế cơ sở dữ liệu MariaDB, phân quyền người dùng.',
    'Đóng gói và triển khai bằng Docker Compose, GitHub Actions.',
    'Tích hợp AI (Claude, Gemini) để xử lý dữ liệu Excel.',
  ]),
  Experience('Sinh viên Kỹ thuật Phần mềm', 'Đại học Thủy Lợi', '2023 - 2027', [
    'Chuyên ngành: Software Engineering.',
    'GPA: 3.55 / 4.',
  ]),
];

// ---------------- DỰ ÁN ----------------
const List<Project> projects = [
  Project(
    'Process Management System',
    'Hệ thống quản lý quy trình, KPI, người dùng, phòng ban và tài liệu.',
    ['Laravel', 'React 18', 'TypeScript', 'Tailwind', 'MariaDB', 'Docker'],
    [
      'CRUD quy trình, văn bản, người dùng, phòng ban, vai trò.',
      'Dashboard KPI có biểu đồ, xuất CSV/Excel, cảnh báo hết hạn.',
      'Quản lý tài liệu: upload/download, liên kết với quy trình.',
      'Giao diện React responsive có bộ lọc, phân trang.',
      'Thiết kế CSDL MariaDB và Docker hóa ứng dụng.',
    ],
  ),
  Project(
    'Stock Management',
    'Quản lý hồ sơ nội bộ cho hoạt động đấu thầu xây dựng.',
    ['Laravel', 'React 18', 'TypeScript', 'Recharts', 'Docker', 'Nginx'],
    [
      'Quản lý nhân sự, chứng chỉ, hợp đồng, thiết bị.',
      'Đăng nhập Sanctum, tự đăng xuất khi không hoạt động.',
      'Dashboard thống kê, theo dõi chứng chỉ sắp hết hạn.',
      'Import/Export Excel, triển khai bằng GitHub Actions.',
    ],
  ),
  Project(
    'TuyenCap - Thiết kế tuyến cáp',
    'Chuyển file Excel thành bản vẽ AutoCAD tuyến cáp viễn thông.',
    ['Python', 'FastAPI', 'C#', 'AutoCAD', 'Claude AI', 'Gemini AI'],
    [
      'Web FastAPI: upload Excel, chuẩn hóa và xem trước bản vẽ.',
      'Tự nhận diện 3 định dạng file Excel của khách hàng.',
      'Dùng AI để nhận diện các cột Excel lạ.',
      'Plug-in C# cho AutoCAD tự vẽ cột, cáp và bảng vật tư.',
    ],
  ),
];

// ---------------- LIÊN HỆ ----------------
const String myEmail = 'haininh320@gmail.com';
const String myGithub = 'https://github.com/HaiNinh1';
const String myPhone = '0917634946';
