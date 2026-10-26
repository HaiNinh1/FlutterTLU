# Cua so thu hai trong video: build va chay ung dung tren Windows.
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
Set-Location (Join-Path (Split-Path $PSScriptRoot) 'src')
Write-Host "PS $((Get-Location).Path)> flutter run -d windows" -ForegroundColor Green
# an danh sach chuoi chua dich cua cac ngon ngu khac (gen-l10n tu in ra) cho gon
flutter run -d windows 2>&1 | Where-Object { $_ -notmatch 'untranslated|^\s*$|detailed report|l10n.yaml file|messages-file|other option|JSON format|need to be translated|available\)$' }
