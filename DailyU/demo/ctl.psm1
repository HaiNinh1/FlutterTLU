Add-Type -AssemblyName System.Drawing, System.Windows.Forms
Add-Type @'
using System; using System.Text; using System.Runtime.InteropServices;
public class U {
  public delegate bool EnumProc(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc f, IntPtr p);
  [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr h, int x, int y, int w, int hh, bool r);
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
  [DllImport("user32.dll")] public static extern void mouse_event(int f, int dx, int dy, int d, int e);
  [DllImport("user32.dll")] public static extern void keybd_event(byte k, byte s, int f, int e);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  public struct R { public int L, T, Ri, B; }
}
'@
[U]::SetProcessDPIAware() | Out-Null

function Find-Win([string]$title) {
    $script:found = [IntPtr]::Zero
    $cb = [U+EnumProc] {
        param($h, $p)
        if ([U]::IsWindowVisible($h)) {
            $sb = New-Object System.Text.StringBuilder 256
            [U]::GetWindowText($h, $sb, 256) | Out-Null
            if ($sb.ToString() -like $title) { $script:found = $h; return $false }
        }
        return $true
    }
    [U]::EnumWindows($cb, [IntPtr]::Zero) | Out-Null
    $script:found
}

function Focus-Win([string]$title, [switch]$Max, [switch]$Restore) {
    $h = Find-Win $title
    if ($h -eq [IntPtr]::Zero) { throw "khong thay cua so: $title" }
    # nhan ALT de Windows cho phep doi cua so tren cung
    [U]::keybd_event(0x12, 0, 0, 0); [U]::keybd_event(0x12, 0, 2, 0)
    if ($Max) { [U]::ShowWindow($h, 3) | Out-Null } elseif ($Restore) { [U]::ShowWindow($h, 9) | Out-Null }
    [U]::SetForegroundWindow($h) | Out-Null
    Start-Sleep -Milliseconds 400
    $h
}

function App-Rect {
    $h = Find-Win 'Daily You'
    $r = New-Object U+R
    [U]::GetWindowRect($h, [ref]$r) | Out-Null
    $r
}

# (x, y) tinh theo anh chup cua so app (goc tren-trai cua so = 0,0)
function App-Click([int]$x, [int]$y, [double]$wait = 1.2) {
    $r = App-Rect
    [U]::SetCursorPos($r.L + $x, $r.T + $y) | Out-Null
    Start-Sleep -Milliseconds 250
    [U]::mouse_event(0x02, 0, 0, 0, 0); [U]::mouse_event(0x04, 0, 0, 0, 0)
    Start-Sleep -Milliseconds ([int]($wait * 1000))
}

function App-Move([int]$x, [int]$y) {
    $r = App-Rect
    [U]::SetCursorPos($r.L + $x, $r.T + $y) | Out-Null
}

function App-Scroll([int]$x, [int]$y, [int]$delta, [double]$wait = 1) {
    App-Move $x $y
    Start-Sleep -Milliseconds 200
    [U]::mouse_event(0x0800, 0, 0, $delta, 0)
    Start-Sleep -Milliseconds ([int]($wait * 1000))
}

function Send([string]$keys, [double]$wait = 0.8) {
    [System.Windows.Forms.SendKeys]::SendWait($keys)
    Start-Sleep -Milliseconds ([int]($wait * 1000))
}

function Shot([string]$out, [switch]$App) {
    if ($App) { $r = App-Rect; $x = $r.L; $y = $r.T; $w = $r.Ri - $r.L; $hh = $r.B - $r.T }
    else { $b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds; $x = 0; $y = 0; $w = $b.Width; $hh = $b.Height }
    $bmp = New-Object System.Drawing.Bitmap $w, $hh
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($x, $y, 0, 0, $bmp.Size)
    # thu nho anh toan man hinh de doc nhanh
    if (-not $App) {
        $s = New-Object System.Drawing.Bitmap ([int]($w * 0.6)), ([int]($hh * 0.6))
        $g2 = [System.Drawing.Graphics]::FromImage($s); $g2.DrawImage($bmp, 0, 0, $s.Width, $s.Height); $bmp = $s
    }
    $bmp.Save($out)
}

Export-ModuleMember -Function *
