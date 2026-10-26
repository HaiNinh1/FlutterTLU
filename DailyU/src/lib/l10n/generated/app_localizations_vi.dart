// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Ghi chép hôm nay!';

  @override
  String get dailyReminderDescription =>
      'Hãy ghi chép nhật ký hàng ngày của bạn…';

  @override
  String get actionTakePhoto => 'Chụp ảnh';

  @override
  String get actionTakeVideo => 'Quay video';

  @override
  String get actionRecordAudio => 'Ghi âm';

  @override
  String get actionAddImage => 'Thêm ảnh';

  @override
  String get actionAddVideo => 'Thêm video';

  @override
  String get actionAddAudio => 'Thêm âm thanh';

  @override
  String get actionToday => 'Hôm nay';

  @override
  String get actionOtherDay => 'Ngày khác';

  @override
  String get pageHomeTitle => 'Trang chủ';

  @override
  String get jumpToMonthTitle => 'Chuyển đến tháng';

  @override
  String get jumpToLogTitle => 'Chuyển đến nhật ký';

  @override
  String get flashbacksTitle => 'Hồi tưởng';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Loại trừ những ngày tệ';

  @override
  String get flaskbacksEmpty => 'Chưa có hồi tưởng nào…';

  @override
  String get flashbackGoodDay => 'Một ngày tốt lành';

  @override
  String get flashbackRandomDay => 'Một ngày ngẫu nhiên';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tuần trước',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tháng trước',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count năm trước',
    );
    return '$_temp0';
  }

  @override
  String get flashbackOnThisDay => 'Ngày này năm xưa';

  @override
  String get pageGalleryTitle => 'Thư viện';

  @override
  String get searchLogsHint => 'Tìm kiếm nhật ký…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nhật ký',
    );
    return '$_temp0';
  }

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count từ',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Không có nhật ký…';

  @override
  String get noResults => 'Không có kết quả…';

  @override
  String get sortDateTitle => 'Ngày';

  @override
  String get sortOrderAscendingTitle => 'Tăng dần';

  @override
  String get sortOrderDescendingTitle => 'Giảm dần';

  @override
  String get pageStatisticsTitle => 'Thống kê';

  @override
  String get statisticsNotEnoughData => 'Không đủ dữ liệu…';

  @override
  String get statisticsRangeOneMonth => '1 tháng';

  @override
  String get statisticsRangeSixMonths => '6 tháng';

  @override
  String get statisticsRangeOneYear => '1 năm';

  @override
  String get statisticsRangeAllTime => 'Mọi thời gian';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Tổng quan $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag theo ngày';
  }

  @override
  String chartOverTimeTitle(Object tag) {
    return '$tag theo thời gian';
  }

  @override
  String get chartGroupingLabel => 'Nhóm theo';

  @override
  String get chartGroupingDay => 'Ngày';

  @override
  String get chartGroupingWeek => 'Tuần';

  @override
  String get chartGroupingMonth => 'Tháng';

  @override
  String get chartGroupingYear => 'Năm';

  @override
  String get chartSmoothingLabel => 'Làm mượt';

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chuỗi hiện tại $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chuỗi dài nhất $count',
    );
    return '$_temp0';
  }

  @override
  String streakGreatDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ngày tuyệt vời $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Số ngày từ ngày tệ gần nhất $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Không thể truy cập bộ nhớ ngoài';

  @override
  String get errorExternalStorageAccessDescription =>
      'Nếu bạn đang dùng bộ nhớ mạng, hãy đảm bảo dịch vụ đang trực tuyến và bạn có kết nối mạng.\n\nNếu không, ứng dụng có thể đã mất quyền truy cập thư mục ngoài. Hãy vào phần cài đặt và chọn lại thư mục ngoài để cấp quyền.\n\nCảnh báo: các thay đổi sẽ không được đồng bộ cho đến khi bạn khôi phục quyền truy cập vào vị trí lưu trữ ngoài!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Tiếp tục với cơ sở dữ liệu cục bộ';

  @override
  String get databaseMigrationErrorTitle => 'Không thể di chuyển dữ liệu';

  @override
  String get databaseMigrationErrorDescription =>
      'Các bản ghi của bạn vẫn an toàn nhưng không thể chuyển vào bộ nhớ của ứng dụng.\n\nHãy thử lại và báo cáo sự cố nếu lỗi tiếp tục xảy ra.';

  @override
  String get databaseMigrationErrorRetry => 'Thử lại';

  @override
  String get databaseNewerErrorTitle => 'Cần cập nhật';

  @override
  String get databaseNewerErrorDescription =>
      'Dữ liệu của bạn được lưu bởi phiên bản Daily You mới hơn. Phiên bản này không thể mở dữ liệu một cách an toàn. Hãy cập nhật ứng dụng để tiếp tục.';

  @override
  String get errorReport => 'Báo cáo sự cố';

  @override
  String get lastModified => 'Đã sửa';

  @override
  String get writeSomethingHint => 'Viết gì đó…';

  @override
  String get titleHint => 'Tiêu đề…';

  @override
  String get deleteLogTitle => 'Xóa nhật ký';

  @override
  String get deleteLogDescription => 'Bạn có muốn xóa nhật ký này không?';

  @override
  String get deletePhotoTitle => 'Xóa ảnh';

  @override
  String get deletePhotoDescription => 'Bạn có muốn xóa ảnh này không?';

  @override
  String get deleteAttachmentTitle => 'Xóa tệp đính kèm';

  @override
  String get deleteAttachmentDescription =>
      'Bạn có muốn xóa tệp đính kèm này không?';

  @override
  String get largeAttachmentWarningTitle => 'Tệp đính kèm lớn';

  @override
  String get largeAttachmentWarningDescription =>
      'Tệp đính kèm này có dung lượng lớn và sẽ làm tăng kích thước bản sao lưu.';

  @override
  String get dontShowAgain => 'Không hiển thị lại';

  @override
  String get pageSettingsTitle => 'Cài đặt';

  @override
  String get settingsAppearanceTitle => 'Giao diện';

  @override
  String get settingsTheme => 'Chủ đề';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Ngày đầu tuần';

  @override
  String get settingsCalendarSystem => 'Hệ lịch';

  @override
  String get calendarSystemGregorian => 'Dương lịch (Gregorian)';

  @override
  String get calendarSystemJalali => 'Lịch Jalali (Ba Tư)';

  @override
  String get settingsUseSystemAccentColor => 'Dùng màu nhấn của hệ thống';

  @override
  String get settingsCustomAccentColor => 'Màu nhấn tùy chỉnh';

  @override
  String get settingsShowMarkdownToolbar => 'Hiện thanh công cụ Markdown';

  @override
  String get settingsShowFlashbacks => 'Hiện hồi tưởng';

  @override
  String get settingsChangeMoodIcons => 'Thay đổi biểu tượng tâm trạng';

  @override
  String get moodIconPrompt => 'Nhập một biểu tượng';

  @override
  String get settingsFlashbacksViewLayout => 'Bố cục hiển thị hồi tưởng';

  @override
  String get settingsGalleryViewLayout => 'Bố cục hiển thị thư viện';

  @override
  String get settingsHideImagesInGallery => 'Ẩn ảnh trong thư viện';

  @override
  String get settingsHideImages => 'Ẩn ảnh';

  @override
  String get pageCalendarTitle => 'Lịch';

  @override
  String get viewLayoutList => 'Danh sách';

  @override
  String get viewLayoutGrid => 'Lưới';

  @override
  String get settingsNotificationsTitle => 'Thông báo';

  @override
  String get settingsDailyReminderOnboarding =>
      'Bật nhắc nhở hằng ngày để duy trì thói quen viết nhật ký!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Ứng dụng sẽ yêu cầu quyền \'lên lịch báo thức\' để gửi lời nhắc vào một thời điểm ngẫu nhiên hoặc vào giờ bạn chọn.';

  @override
  String get settingsDailyReminderTitle => 'Nhắc nhở hằng ngày';

  @override
  String get settingsOnThisDayDescription => 'Xem lại những kỷ niệm cũ';

  @override
  String get settingsDailyReminderDescription =>
      'Một lời nhắc nhẹ nhàng mỗi ngày';

  @override
  String get settingsReminderTime => 'Giờ nhắc nhở';

  @override
  String get settingsFixedReminderTimeTitle => 'Giờ nhắc cố định';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Chọn một giờ cố định cho lời nhắc';

  @override
  String get settingsAlwaysSendReminderTitle => 'Luôn gửi lời nhắc';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Gửi lời nhắc kể cả khi đã bắt đầu viết nhật ký';

  @override
  String get settingsCustomizeNotificationTitle => 'Tùy chỉnh thông báo';

  @override
  String get settingsTemplatesTitle => 'Mẫu';

  @override
  String get settingsDefaultTemplate => 'Mẫu mặc định';

  @override
  String get manageTemplates => 'Quản lý mẫu';

  @override
  String get addTemplate => 'Thêm mẫu';

  @override
  String get newTemplate => 'Mẫu mới';

  @override
  String get noTemplateTitle => 'Không có';

  @override
  String get noTemplatesDescription => 'Chưa có mẫu nào…';

  @override
  String get templateVariableTime => 'Giờ';

  @override
  String get templateDefaultTimestampTitle => 'Mốc thời gian';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Tóm tắt ngày';

  @override
  String get templateDefaultSummaryBody =>
      '### Tóm tắt\n- \n\n### Trích dẫn\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Suy ngẫm';

  @override
  String get templateDefaultReflectionBody =>
      '### Hôm nay bạn thích điều gì?\n- \n\n### Bạn biết ơn điều gì?\n- \n\n### Bạn đang mong chờ điều gì?\n- ';

  @override
  String get settingsTagsTitle => 'Thẻ';

  @override
  String get manageTags => 'Quản lý thẻ';

  @override
  String get tagTypeLabelTitle => 'Nhãn';

  @override
  String get tagTypeTrackerTitle => 'Theo dõi';

  @override
  String get nameHint => 'Tên';

  @override
  String get tagColorLabel => 'Màu';

  @override
  String get iconPickerTitle => 'Chọn biểu tượng';

  @override
  String get iconPickerIconsTab => 'Biểu tượng';

  @override
  String get iconPickerCustomTab => 'Tùy chỉnh';

  @override
  String get iconPickerSearchHint => 'Tìm biểu tượng…';

  @override
  String get colorPickerTitle => 'Chọn màu';

  @override
  String get colorPickerPaletteTab => 'Màu sắc';

  @override
  String get iconGroupMoodPeople => 'Tâm trạng & Con người';

  @override
  String get iconGroupHealth => 'Sức khỏe';

  @override
  String get iconGroupWorkFinance => 'Công việc & Tài chính';

  @override
  String get iconGroupHabitsGoals => 'Thói quen & Mục tiêu';

  @override
  String get iconGroupNature => 'Thiên nhiên';

  @override
  String get iconGroupFoodDrink => 'Đồ ăn & Thức uống';

  @override
  String get iconGroupHome => 'Nhà cửa';

  @override
  String get iconGroupTravel => 'Du lịch';

  @override
  String get iconGroupSymbols => 'Ký hiệu';

  @override
  String get tagCategoryLabel => 'Danh mục';

  @override
  String get tagLabel => 'Thẻ';

  @override
  String get tagCategoryUncategorized => 'Chưa phân loại';

  @override
  String get newCategoryTitle => 'Danh mục mới';

  @override
  String get shareButtonLabel => 'Chia sẻ';

  @override
  String get importErrorDescription => 'Nhập tệp thất bại!';

  @override
  String get exportErrorDescription => 'Xuất tệp thất bại!';

  @override
  String get deleteTitle => 'Xóa';

  @override
  String deleteTagMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' Thẻ này đang được dùng trong $count nhật ký.',
      one: ' Thẻ này đang được dùng trong 1 nhật ký.',
      zero: '',
    );
    return 'Xóa \"$name\"?$_temp0';
  }

  @override
  String deleteCategoryMessage(num count, Object name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count thẻ trong danh mục này cũng sẽ bị xóa.',
      one: ' 1 thẻ trong danh mục này cũng sẽ bị xóa.',
      zero: '',
    );
    return 'Xóa \"$name\"?$_temp0';
  }

  @override
  String deleteTemplateMessage(Object name) {
    return 'Xóa \"$name\"?';
  }

  @override
  String get filterTagsTitle => 'Bộ lọc';

  @override
  String get tagFilterModeAny => 'Bất kỳ thẻ nào';

  @override
  String get tagFilterModeAll => 'Tất cả các thẻ';

  @override
  String get clearAllFilters => 'Xóa tất cả';

  @override
  String get noTagsFilterLabel => 'Không có thẻ';

  @override
  String get addTagsTitle => 'Thêm thẻ';

  @override
  String get addTagsSearchHint => 'Tìm thẻ…';

  @override
  String get tagPickerSortManualLabel => 'Thứ tự thủ công';

  @override
  String get tagPickerSortUsageLabel => 'Sắp xếp theo mức sử dụng';

  @override
  String get tagFavoriteName => 'Yêu thích';

  @override
  String get tagEnergyName => 'Năng lượng';

  @override
  String get tagCategoryActivitiesName => 'Hoạt động';

  @override
  String get tagExerciseName => 'Tập thể dục';

  @override
  String get tagSocializingName => 'Giao lưu';

  @override
  String get tagHobbyName => 'Sở thích';

  @override
  String get tagEntertainmentName => 'Giải trí';

  @override
  String get tagDiningName => 'Ăn uống';

  @override
  String get tagChoresName => 'Việc nhà';

  @override
  String get tagCategoryEmotionsName => 'Cảm xúc';

  @override
  String get tagExcitedName => 'Hào hứng';

  @override
  String get tagGratefulName => 'Biết ơn';

  @override
  String get tagCalmName => 'Bình yên';

  @override
  String get tagTiredName => 'Mệt mỏi';

  @override
  String get tagAnxiousName => 'Lo lắng';

  @override
  String get tagAnnoyedName => 'Khó chịu';

  @override
  String get welcomeLogBodyText =>
      '## Chào mừng đến với Daily You\n\n> Mỗi ngày đều đáng nhớ, hãy lưu giữ nó!\n\n**Daily You** miễn phí, [mã nguồn mở](https://github.com/Demizo/Daily_You) và được cộng đồng hỗ trợ. Ứng dụng được xây dựng dựa trên niềm tin rằng nhật ký là của riêng bạn, không phải một sản phẩm:\n\n- Không quảng cáo\n- Không khóa tính năng\n- Không theo dõi hay thu thập dữ liệu\n\nDù bạn viết nhật ký, suy ngẫm hay chỉ ghi lại điều khiến bạn mỉm cười, **Daily You** mang đến cho bạn một không gian riêng tư _thực sự của riêng bạn_.';

  @override
  String get settingsStorageTitle => 'Lưu trữ & Đồng bộ';

  @override
  String get settingsImageQuality => 'Chất lượng ảnh';

  @override
  String get settingsMediaQualityTitle => 'Chất lượng đa phương tiện';

  @override
  String get imageQualityHigh => 'Cao';

  @override
  String get imageQualityMedium => 'Trung bình';

  @override
  String get imageQualityLow => 'Thấp';

  @override
  String get imageQualityNoCompression => 'Không nén';

  @override
  String get settingsStorageUsage => 'Dung lượng đã dùng';

  @override
  String get settingsLogFolder => 'Thư mục nhật ký';

  @override
  String get settingsImageFolder => 'Thư mục ảnh';

  @override
  String get settingsExternalSyncTitle => 'Đồng bộ với vị trí bên ngoài';

  @override
  String get chooseFolderHint => 'Chọn một thư mục';

  @override
  String get warningTitle => 'Cảnh báo';

  @override
  String get logFolderWarningDescription =>
      'Thư mục đã chọn đã có tệp \'daily_you.db\', tệp này sẽ được dùng để ghi đè lên nhật ký hiện tại của bạn!';

  @override
  String get errorTitle => 'Lỗi';

  @override
  String get logFolderErrorDescription => 'Thay đổi thư mục nhật ký thất bại!';

  @override
  String get imageFolderErrorDescription => 'Thay đổi thư mục ảnh thất bại!';

  @override
  String get syncErrorDescription => 'Đồng bộ với vị trí bên ngoài thất bại!';

  @override
  String get backupErrorDescription => 'Tạo bản sao lưu thất bại!';

  @override
  String get restoreErrorDescription => 'Khôi phục bản sao lưu thất bại!';

  @override
  String get settingsBackupRestoreTitle => 'Sao lưu & Khôi phục';

  @override
  String get settingsBackup => 'Sao lưu';

  @override
  String get settingsRestore => 'Khôi phục';

  @override
  String get settingsRestorePromptDescription =>
      'Khôi phục bản sao lưu sẽ ghi đè lên dữ liệu hiện tại của bạn!';

  @override
  String get settingsBackupPasswordProtect =>
      'Bảo vệ bản sao lưu bằng mật khẩu';

  @override
  String get backupEncryptedTitle => 'Bản sao lưu đã mã hóa';

  @override
  String get backupEncryptedContent =>
      'Bản sao lưu này được bảo vệ bằng mật khẩu.';

  @override
  String get settingsAutoBackup => 'Sao lưu tự động';

  @override
  String get settingsAutoBackupLocation => 'Vị trí sao lưu';

  @override
  String get settingsAutoBackupInterval => 'Chu kỳ sao lưu';

  @override
  String get settingsAutoBackupIntervalDaily => 'Hằng ngày';

  @override
  String get settingsAutoBackupIntervalWeekly => 'Hằng tuần';

  @override
  String get settingsAutoBackupIntervalMonthly => 'Hằng tháng';

  @override
  String get settingsAutoBackupMaxCount => 'Số bản sao lưu giữ lại';

  @override
  String get settingsAutoBackupRequireCharging => 'Chỉ khi đang sạc';

  @override
  String settingsBackupLast(Object time) {
    return 'Sao lưu gần nhất $time';
  }

  @override
  String get settingsBackupNever => 'Chưa từng sao lưu';

  @override
  String settingsAutoBackupNext(Object time) {
    return 'Sao lưu tiếp theo $time';
  }

  @override
  String get settingsAutoBackupKeepAll => 'Tất cả';

  @override
  String get autoBackupFailedTitle => 'Sao lưu thất bại';

  @override
  String tranferStatus(Object percent) {
    return 'Đang chuyển… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Đang tạo bản sao lưu… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Đang khôi phục bản sao lưu… $percent%';
  }

  @override
  String encryptingBackupStatus(Object percent) {
    return 'Đang mã hóa bản sao lưu… $percent%';
  }

  @override
  String decryptingBackupStatus(Object percent) {
    return 'Đang giải mã bản sao lưu… $percent%';
  }

  @override
  String get cleanUpStatus => 'Đang dọn dẹp…';

  @override
  String migratingImagesStatus(Object current, Object total) {
    return 'Đang di chuyển ảnh… $current/$total';
  }

  @override
  String get settingsExport => 'Xuất';

  @override
  String get settingsExportToAnotherFormat => 'Xuất sang định dạng khác';

  @override
  String get settingsExportFormatDescription =>
      'Không nên dùng tính năng này thay cho sao lưu!';

  @override
  String get exportLogs => 'Xuất nhật ký';

  @override
  String get exportImages => 'Xuất ảnh';

  @override
  String get exportIncludeTitle => 'Bao gồm';

  @override
  String get settingsImport => 'Nhập';

  @override
  String get settingsImportFromAnotherApp => 'Nhập từ ứng dụng khác';

  @override
  String get settingsTranslateCallToAction =>
      'Ai cũng xứng đáng có một cuốn nhật ký!';

  @override
  String get settingsHelpTranslate => 'Giúp dịch thuật';

  @override
  String get importLogs => 'Nhập nhật ký';

  @override
  String get importImages => 'Nhập ảnh';

  @override
  String get logFormatTitle => 'Chọn định dạng';

  @override
  String get logFormatDescription =>
      'Định dạng của ứng dụng khác có thể không hỗ trợ đầy đủ tính năng. Vui lòng báo cáo sự cố vì định dạng của bên thứ ba có thể thay đổi bất cứ lúc nào. Thao tác này không ảnh hưởng đến nhật ký hiện có!';

  @override
  String get formatDailyYouJson => 'Daily You (JSON)';

  @override
  String get formatDaybook => 'Daybook';

  @override
  String get formatDaylio => 'Daylio';

  @override
  String get formatDiarium => 'Diarium';

  @override
  String get formatDiaro => 'Diaro';

  @override
  String get formatMyBrain => 'My Brain';

  @override
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Xóa tất cả nhật ký';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Bạn có muốn xóa toàn bộ nhật ký của mình không?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Nhập \'$prompt\' để xác nhận. Thao tác này không thể hoàn tác!';
  }

  @override
  String get settingsLanguageTitle => 'Ngôn ngữ';

  @override
  String get settingsAppLanguageTitle => 'Ngôn ngữ ứng dụng';

  @override
  String get settingsOverrideAppLanguageTitle => 'Thay đổi ngôn ngữ ứng dụng';

  @override
  String get settingsSecurityTitle => 'Bảo mật';

  @override
  String get settingsSecurityRequirePassword => 'Yêu cầu mật khẩu';

  @override
  String get settingsSecurityEnterPassword => 'Nhập mật khẩu';

  @override
  String get settingsSecuritySetPassword => 'Đặt mật khẩu';

  @override
  String get settingsSecurityChangePassword => 'Đổi mật khẩu';

  @override
  String get settingsSecurityPassword => 'Mật khẩu';

  @override
  String get settingsSecurityConfirmPassword => 'Xác nhận mật khẩu';

  @override
  String get settingsSecurityOldPassword => 'Mật khẩu cũ';

  @override
  String get settingsSecurityIncorrectPassword => 'Mật khẩu không đúng';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get requiredPrompt => 'Bắt buộc';

  @override
  String get settingsSecurityBiometricUnlock => 'Mở khóa sinh trắc học';

  @override
  String get unlockAppPrompt => 'Mở khóa ứng dụng';

  @override
  String get settingsAboutTitle => 'Giới thiệu';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get settingsLicense => 'Giấy phép';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Mã nguồn';

  @override
  String get settingsOpenSourceLicenses => 'Giấy phép mã nguồn mở';

  @override
  String get settingsMadeWithLove => 'Được tạo với ❤️';

  @override
  String get settingsConsiderSupporting => 'hãy cân nhắc ủng hộ';

  @override
  String get imagesTitle => 'Hình ảnh';

  @override
  String get audioTitle => 'Âm thanh';

  @override
  String get videoTitle => 'Video';

  @override
  String get tagMoodTitle => 'Tâm trạng';

  @override
  String get calendarTagDisplayLabel => 'Thẻ';

  @override
  String get selectTagTitle => 'Chọn thẻ';

  @override
  String get labelPresentLabel => 'Có';

  @override
  String get labelAbsentLabel => 'Không có';

  @override
  String get labelCoverageLabel => 'Tỷ lệ phủ';

  @override
  String chartDistributionTitle(Object tag) {
    return 'Phân bố $tag';
  }

  @override
  String get shareAddToLogPickerTitle => 'Chọn một nhật ký';

  @override
  String get attachmentAddErrorDescription => 'Thêm tệp đính kèm thất bại!';

  @override
  String get attachmentLoadFailed => 'Không thể mở tệp đính kèm này';

  @override
  String get attachmentNoAppToOpen =>
      'Không có ứng dụng nào mở được tệp đính kèm này';

  @override
  String get recorderDiscardTitle => 'Hủy bản ghi âm?';

  @override
  String get recorderDiscardDescription => 'Bản ghi âm này sẽ bị xóa.';

  @override
  String get recorderDiscardAction => 'Hủy bỏ';

  @override
  String get recorderPermissionDenied => 'Cần quyền truy cập micro để ghi âm';

  @override
  String get recorderErrorDescription => 'Ghi âm thất bại!';
}
