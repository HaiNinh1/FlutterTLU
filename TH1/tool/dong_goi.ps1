# Đóng gói mã nguồn TH1 thành file .zip để nộp bài.
# Chỉ lấy mã nguồn + tài liệu, bỏ thư mục build và file sinh ra khi chạy.
# Cách dùng (đứng trong thư mục TH1):
#   powershell -ExecutionPolicy Bypass -File tool\dong_goi.ps1

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$output = Join-Path (Split-Path -Parent $root) 'TH1_QuanLyTaiLieu_NguyenHaiNinh.zip'

$excludedDirs = @('build', '.dart_tool', '.idea', '.omc', '.gradle', '.cxx',
  'ephemeral', '.plugin_symlinks', '.vscode')
$excludedFiles = @('*.iml', 'local.properties', '.flutter-plugins',
  '.flutter-plugins-dependencies', '*.log')

$staging = Join-Path ([System.IO.Path]::GetTempPath()) "TH1_dong_goi_$([guid]::NewGuid())"
$target = Join-Path $staging 'TH1'
New-Item -ItemType Directory -Path $target | Out-Null

Get-ChildItem -Path $root -Recurse -File -Force | Where-Object {
  $file = $_
  $folders = ($file.FullName.Substring($root.Length + 1) -split '[\\/]') | Select-Object -SkipLast 1
  $inExcludedDir = @($folders | Where-Object { $excludedDirs -contains $_ }).Count -gt 0
  $isExcludedFile = @($excludedFiles | Where-Object { $file.Name -like $_ }).Count -gt 0
  -not $inExcludedDir -and -not $isExcludedFile
} | ForEach-Object {
  $relative = $_.FullName.Substring($root.Length + 1)
  $destination = Join-Path $target $relative
  New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
  Copy-Item -LiteralPath $_.FullName -Destination $destination
}

if (Test-Path $output) { Remove-Item $output -Force }
Compress-Archive -Path $target -DestinationPath $output
Remove-Item $staging -Recurse -Force

$size = [math]::Round((Get-Item $output).Length / 1KB, 1)
Write-Host "Da tao $output ($size KB)"
