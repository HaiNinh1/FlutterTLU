# Dieu khien toan bo video demo: mo cua so, chay tung buoc demo.ps1 va thao tac tren ung dung.
# Chay:  pwsh -File demo\chay_video.ps1   (khong cham chuot/ban phim cho den khi hien TONG KET)
param([int]$DelayStart = 10)
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'ctl.psm1') -Force -WarningAction SilentlyContinue
$root = Split-Path $PSScriptRoot
$src = Join-Path $root 'src'
$sig = Join-Path $PSScriptRoot '.signal'
$log = Join-Path $PSScriptRoot 'chay_video.log'
"" | Set-Content $log

function Log($m) { "{0:HH:mm:ss} $m" -f (Get-Date) | Add-Content $log }
function Signal($n) { New-Item -ItemType File -Force (Join-Path $sig $n) | Out-Null; Log "signal $n" }
function Wait-Done($n, [int]$timeout = 300) {
    $t = 0
    while (-not (Test-Path (Join-Path $sig "done$n"))) {
        Start-Sleep -Milliseconds 500; $t++
        if ($t -gt $timeout * 2) { throw "buoc $n chay qua lau" }
    }
    Log "done $n"
}
function Wait-Win($title, [int]$timeout = 300) {
    $t = 0
    while ((Find-Win $title) -eq [IntPtr]::Zero) {
        Start-Sleep -Milliseconds 500; $t++
        if ($t -gt $timeout * 2) { throw "khong thay cua so $title" }
    }
}
function Zoom-Terminal { Send '^=' 0.2; Send '^=' 0.2 }

try {
    # --- chuan bi: dong cua so/ung dung cua lan chay truoc, xoa du lieu cu de thay lan chay dau tien
    Get-CimInstance Win32_Process |
        Where-Object { $_.CommandLine -match 'demo\\demo\.ps1|demo\\run_app\.ps1' -or
            ($_.Name -eq 'dart.exe' -and $_.CommandLine -match 'flutter_tools' -and $_.CommandLine -match ' run ') } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
    Get-Process daily_you -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep 1
    foreach ($t in 'BUOC DEMO', 'FLUTTER RUN') {
        $h = Find-Win $t
        if ($h -ne [IntPtr]::Zero) { [U]::PostMessage($h, 0x10, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null }
    }
    Start-Sleep 1.5
    Remove-Item -Recurse -Force "$env:APPDATA\com.example\daily_you" -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force $sig | Out-Null
    Get-ChildItem $sig | Remove-Item -Force
    Log "cho $DelayStart giay de bat dau quay"
    Start-Sleep $DelayStart
    (New-Object -ComObject Shell.Application).MinimizeAll()
    Start-Sleep 1.5

    # --- BUOC 1: nguon ma + moi truong
    Start-Process 'https://github.com/Demizo/Daily_You'
    Start-Sleep 4
    try { Focus-Win '*Daily_You*' -Max | Out-Null } catch { Log 'khong focus duoc Chrome' }
    Start-Sleep 7
    # cuon trang GitHub xuong phan gioi thieu
    [U]::SetCursorPos(1100, 650) | Out-Null
    foreach ($i in 1..2) { [U]::mouse_event(0x0800, 0, 0, -480, 0); Start-Sleep 3 }
    wt -w demo --title 'BUOC DEMO' --suppressApplicationTitle pwsh -NoLogo -NoExit -File (Join-Path $PSScriptRoot 'demo.ps1')
    Wait-Win 'BUOC DEMO'
    Start-Sleep 1.5
    Focus-Win 'BUOC DEMO' -Max | Out-Null
    Zoom-Terminal
    Start-Sleep 4
    Signal 1; Wait-Done 1; Start-Sleep 18

    # --- BUOC 2: build va chay
    Signal 2; Wait-Done 2; Start-Sleep 20
    wt -w run --title 'FLUTTER RUN' --suppressApplicationTitle pwsh -NoLogo -NoExit -File (Join-Path $PSScriptRoot 'run_app.ps1')
    Wait-Win 'FLUTTER RUN'
    Start-Sleep 1.5
    Focus-Win 'FLUTTER RUN' -Max | Out-Null
    Zoom-Terminal
    Wait-Win 'Daily You' 400
    Start-Sleep 8
    Focus-Win 'Daily You' | Out-Null
    Start-Sleep 6

    # --- BUOC 3: ra soat
    Focus-Win 'BUOC DEMO' | Out-Null
    Signal 3; Wait-Done 3; Start-Sleep 30

    # --- BUOC 4: dich
    Signal 4; Wait-Done 4; Start-Sleep 22
    & code -d (Join-Path $root 'goc_ban_dau\lib\l10n\intl_vi.arb') (Join-Path $src 'lib\l10n\intl_vi.arb')
    Start-Sleep 5
    try { Focus-Win '*intl_vi.arb*' -Max | Out-Null } catch { Log 'khong focus duoc VS Code' }
    Start-Sleep 8
    [U]::SetCursorPos(1400, 600) | Out-Null
    foreach ($i in 1..3) { [U]::mouse_event(0x0800, 0, 0, -600, 0); Start-Sleep 3.5 }
    Focus-Win 'BUOC DEMO' | Out-Null
    Signal 5; Wait-Done 5; Start-Sleep 12

    # --- BUOC 5: kiem tra (flutter analyze chay trong luc thao tac ung dung)
    Signal 6
    Start-Sleep 5
    Focus-Win 'Daily You' | Out-Null
    Start-Sleep 1
    App-Click 123 212 2          # Thu vien
    App-Click 700 150 0.8        # o tim kiem
    Send 'Daily' 2.5
    App-Click 1256 149 1.5       # xoa tu khoa
    App-Click 540 330 3.5        # mo nhat ky chao mung
    App-Scroll 800 600 -360 2.5
    App-Scroll 800 600 360 1
    App-Click 1560 72 2.5        # sua
    App-Click 702 830 2.5        # chon mau
    App-Click 1485 455 2         # them mau "Suy ngam"
    App-Scroll 800 600 -3000 3.5
    App-Click 1560 72 2.5        # luu
    App-Click 43 72 2            # quay lai
    App-Click 126 280 4.5        # Thong ke
    App-Click 117 848 2.5        # Cai dat
    App-Click 139 147 3          # Giao dien
    App-Click 1480 134 2.5       # mo danh sach chu de
    Send '{ESC}' 1.5
    App-Click 43 72 1.5
    App-Click 183 522 3          # Luu tru & Dong bo
    App-Click 1540 527 4         # hop thoai xoa tat ca
    App-Click 975 580 1.5        # Huy
    App-Click 43 72 1.5
    App-Click 190 672 3          # Sao luu & Khoi phuc
    App-Click 43 72 1.5
    App-Click 141 222 2.5        # Ngon ngu
    App-Click 1480 134 2         # danh sach ngon ngu
    App-Click 1399 620 4         # English
    App-Click 43 72 3.5          # Settings (tieng Anh)
    App-Click 141 222 2          # Language
    App-Click 1480 134 2
    App-Scroll 1460 600 -6000 2
    App-Click 1412 673 4         # Tieng Viet
    App-Click 43 72 3
    App-Click 43 72 2
    App-Click 128 145 3          # Trang chu

    # --- KET THUC
    Focus-Win 'BUOC DEMO' | Out-Null
    Wait-Done 6; Start-Sleep 7
    Signal 7; Wait-Done 7
    Log 'XONG'
}
catch {
    Log "LOI: $_"
    throw
}
