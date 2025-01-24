Start-Process "C:\Users\mahat\AppData\Local\Microsoft\WindowsApps\wt.exe"
Start-Sleep -Milliseconds 300
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
}
"@
$hwnd = [WinAPI]::FindWindow("CASCADIA_HOSTING_WINDOW_CLASS", $null)
if ($hwnd -ne [IntPtr]::Zero) {
    [WinAPI]::SetForegroundWindow($hwnd)
}

