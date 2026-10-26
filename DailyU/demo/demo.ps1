# Kich ban demo cho video: moi buoc doi file tin hieu demo\.signal\<so buoc> roi moi chay.
$ErrorActionPreference = 'Continue'
# doc dung UTF-8 tu git/flutter de tieng Viet khong bi loi font
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()
$root = Split-Path $PSScriptRoot
$src = Join-Path $root 'src'
$goc = Join-Path $root 'goc_ban_dau'
$sig = Join-Path $PSScriptRoot '.signal'
New-Item -ItemType Directory -Force $sig | Out-Null
Get-ChildItem $sig | Remove-Item -Force
Set-Location $src

function Wait-Step($n) {
    # bao cho script dieu khien biet buoc truoc da chay xong
    New-Item -ItemType File -Force (Join-Path $sig "done$($n - 1)") | Out-Null
    Write-Host "`n... san sang cho buoc tiep theo ..." -ForegroundColor DarkGray
    while (-not (Test-Path (Join-Path $sig $n))) { Start-Sleep -Milliseconds 300 }
    Clear-Host
}
function Title($t) {
    Write-Host ('=' * 78) -ForegroundColor Cyan
    Write-Host "  $t" -ForegroundColor Yellow
    Write-Host ('=' * 78) -ForegroundColor Cyan
}
function Note($t) { Write-Host "`n>> $t" -ForegroundColor Magenta }
function Run($cmd) {
    Write-Host "`nPS $((Get-Location).Path)> $cmd" -ForegroundColor Green
    Invoke-Expression $cmd
}
function Show-Diff($a, $b) {
    Write-Host "`nPS> git diff --no-index $a $b" -ForegroundColor Green
    git --no-pager diff --no-index --ignore-cr-at-eol --color=always $a $b
}
function Keys($file) {
    $j = Get-Content $file -Raw -Encoding utf8 | ConvertFrom-Json -AsHashtable
    $j.Keys | Where-Object { -not $_.StartsWith('@') }
}

Clear-Host
Title 'DO AN: XAY DUNG VA VIET HOA UNG DUNG DAILY YOU (Flutter)'
Write-Host "  Ma nguon goc: https://github.com/Demizo/Daily_You  (GPL-3.0)"
Write-Host "  Thu muc lam viec: $src"

# ---------------------------------------------------------------- BUOC 1
Wait-Step 1
Title 'BUOC 1 - THIET LAP MOI TRUONG & CAI DAT THU VIEN'
Note 'Ma nguon duoc clone tu GitHub:  git clone --depth 1 https://github.com/Demizo/Daily_You.git src'
Run 'flutter --version'
Run 'flutter doctor'
Note 'Cac thu vien ung dung can (pubspec.yaml):'
Get-Content pubspec.yaml | Select-Object -Skip 8 -First 24
Write-Host "`nPS $src> flutter pub get" -ForegroundColor Green
# an danh sach chuoi chua dich cua cac ngon ngu khac (gen-l10n tu in ra) cho gon
flutter pub get 2>&1 | Where-Object { $_ -notmatch 'untranslated|^\s*$|detailed report|l10n.yaml file|messages-file|other option|JSON format|need to be translated' }
Note 'Da cai dat xong toan bo thu vien.'

# ---------------------------------------------------------------- BUOC 2
Wait-Step 2
Title 'BUOC 2 - BUILD VA CHAY UNG DUNG TREN MAY CUC BO (Windows)'
Note 'Ma nguon goc KHONG build/chay duoc tren Windows. Da sua 2 loi trong windows/CMakeLists.txt:'
Write-Host '   1) MSVC (VS 2026) bao "error STL1011 <experimental/coroutine>" o plugin permission_handler_windows'
Write-Host '   2) App treo khi mo: "Failed to load dynamic library sqlite3.dll" (native assets khong duoc chep)'
Show-Diff "$goc\windows\CMakeLists.txt" "$src\windows\CMakeLists.txt"
Show-Diff "$goc\windows\runner\main.cpp" "$src\windows\runner\main.cpp"
Note 'Chay ung dung:  flutter run -d windows   (cua so "FLUTTER RUN")'

# ---------------------------------------------------------------- BUOC 3
Wait-Step 3
Title 'BUOC 3 - RA SOAT TEP NGON NGU, GIAO DIEN VA THONG BAO HE THONG'
Run 'Get-Content l10n.yaml'
Note 'Cac tep ngon ngu (ARB) trong lib/l10n:'
(Get-ChildItem lib\l10n\*.arb).Name -join '  '
$en = @(Keys "$src\lib\l10n\intl_en.arb")
$viGoc = @(Keys "$goc\lib\l10n\intl_vi.arb")
$thieu = @($en | Where-Object { $_ -notin $viGoc })
Note 'Thong ke tep tieng Viet BAN GOC:'
Write-Host ("   intl_en.arb (tep goc)   : {0} chuoi" -f $en.Count)
Write-Host ("   intl_vi.arb (ban goc)   : {0} chuoi da dich" -f $viGoc.Count)
Write-Host ("   => CON THIEU            : {0} chuoi van hien tieng Anh" -f $thieu.Count) -ForegroundColor Red
Write-Host ("   Vi du: " + (($thieu | Select-Object -First 12) -join ', ') + ' ...') -ForegroundColor DarkYellow
Note 'Tim chuoi tieng Anh viet cung trong code goc (thong bao he thong):'
Select-String -Path "$goc\lib\*.dart", "$goc\lib\utils\*.dart" -Pattern "'On This Day'|'Log Today'|`"Log Today!`"|'Backup Failed'" |
    ForEach-Object { "   {0}:{1}  {2}" -f $_.Filename, $_.LineNumber, $_.Line.Trim() }
Note 'Loi logic: noi dung mac dinh (nhat ky chao mung, the, mau) tao theo ngon ngu HE DIEU HANH, khong theo ngon ngu app:'
Select-String -Path "$goc\lib\database\app_database.dart", "$goc\lib\providers\tags_provider.dart", "$goc\lib\providers\templates_provider.dart" -Pattern 'platformDispatcher.locale' |
    ForEach-Object { "   {0}:{1}  {2}" -f $_.Filename, $_.LineNumber, $_.Line.Trim() }
Note 'MaterialApp goc: khong chon ngon ngu thi lay theo he dieu hanh, mac dinh tieng Anh (en):'
Select-String -Path "$goc\lib\main.dart" -Pattern "return const Locale\('en'\)|locale: configProvider" |
    ForEach-Object { "   {0}:{1}  {2}" -f $_.Filename, $_.LineNumber, $_.Line.Trim() }

# ---------------------------------------------------------------- BUOC 4
Wait-Step 4
Title 'BUOC 4 - DICH VA THAY THE TIENG ANH SANG TIENG VIET'
$enJ = Get-Content "$src\lib\l10n\intl_en.arb" -Raw -Encoding utf8 | ConvertFrom-Json -AsHashtable
$viJ = Get-Content "$src\lib\l10n\intl_vi.arb" -Raw -Encoding utf8 | ConvertFrom-Json -AsHashtable
$viMoi = @(Keys "$src\lib\l10n\intl_vi.arb")
$conThieu = @($en | Where-Object { $_ -notin $viMoi })
$lechPh = @($en | Where-Object {
    $p = { param($s) ([regex]::Matches($s, '\{(\w+)[,}]') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique) -join ',' }
    (& $p $enJ[$_]) -ne (& $p $viJ[$_]) })
Note 'Ket qua sau khi dich:'
Write-Host ("   intl_vi.arb : {0}/{1} chuoi da dich, con thieu {2}" -f ($en.Count - $conThieu.Count), $en.Count, $conThieu.Count) -ForegroundColor Green
Write-Host ("   Placeholder ({{count}}, {{tag}}, {{time}}...) khop voi ban tieng Anh: {0}/{1}" -f ($en.Count - $lechPh.Count), $en.Count) -ForegroundColor Green
Note 'Mot so chuoi da dich (tieng Anh -> tieng Viet):'
foreach ($k in 'pageSettingsTitle', 'writeSomethingHint', 'deleteLogDescription', 'settingsBackupRestoreTitle',
    'settingsDailyReminderTitle', 'flashbackYear', 'streakLongest', 'tagGratefulName', 'settingsSecurityIncorrectPassword',
    'backupErrorDescription', 'recorderPermissionDenied', 'settingsRestorePromptDescription') {
    Write-Host ("   {0,-34} {1}" -f $enJ[$k], $viJ[$k])
}
Run "flutter gen-l10n 2>&1 | Select-String '`"vi`"|`"de`"|`"fr`"'"
if (-not (flutter gen-l10n 2>&1 | Select-String '"vi"')) {
    Write-Host '   => "vi" KHONG con trong danh sach chuoi chua dich (cac ngon ngu khac van con thieu)' -ForegroundColor Green
}
Note 'Xem chi tiet tep intl_vi.arb (ban goc <-> ban da dich) trong VS Code.'

# ---------------------------------------------------------------- BUOC 4b
Wait-Step 5
Title 'BUOC 4 (tiep) - SUA CODE: MAC DINH TIENG VIET, VIET HOA THONG BAO HE THONG'
Note 'Them appLocale(): ngon ngu nguoi dung chon, mac dinh tieng Viet. Noi dung mac dinh tao theo ngon ngu cua app:'
Show-Diff "$goc\lib\config_provider.dart" "$src\lib\config_provider.dart"
Start-Sleep 6
Show-Diff "$goc\lib\database\app_database.dart" "$src\lib\database\app_database.dart"
Start-Sleep 7
Show-Diff "$goc\lib\main.dart" "$src\lib\main.dart"
Start-Sleep 7
Show-Diff "$goc\lib\notification_manager.dart" "$src\lib\notification_manager.dart"

# ---------------------------------------------------------------- BUOC 5
Wait-Step 6
Title 'BUOC 5 - KIEM TRA LAI TOAN BO CHUC NANG'
Run 'flutter analyze lib'
Note 'Kiem tra thu cong tren ung dung: xem/sua nhat ky, chen mau, tim kiem, thong ke, cai dat, hop thoai, doi ngon ngu.'

# ---------------------------------------------------------------- KET THUC
Wait-Step 7
Title 'TONG KET CHECKLIST'
Write-Host '  [x] 1. Thiet lap moi truong, cai thu vien (flutter doctor, flutter pub get)' -ForegroundColor Green
Write-Host '  [x] 2. Build va chay thanh cong tren may cuc bo (flutter run -d windows, sua 2 loi build)' -ForegroundColor Green
Write-Host '  [x] 3. Ra soat tep ngon ngu, UI, thong bao he thong (thieu 267 chuoi, chuoi viet cung, loi locale)' -ForegroundColor Green
Write-Host '  [x] 4. Dich 297/297 chuoi, Viet hoa thong bao, mac dinh tieng Viet' -ForegroundColor Green
Write-Host '  [x] 5. Kiem tra chuc nang: analyze sach, cac man hinh hoat dong, doi ngon ngu khong loi' -ForegroundColor Green
Write-Host ''
New-Item -ItemType File -Force (Join-Path $sig 'done7') | Out-Null
