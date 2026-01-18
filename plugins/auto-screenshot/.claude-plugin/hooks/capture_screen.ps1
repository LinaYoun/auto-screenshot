# capture_screen.ps1
# Captures active window screenshot and saves as JPG
# Fixed: DPI awareness and accurate window boundaries using DWM API

$ErrorActionPreference = "SilentlyContinue"

# Check if screenshot capture is enabled
$stateFile = "C:\Screenshots\.screenshot_enabled"
if (-not (Test-Path $stateFile)) {
    # Screenshot capture is disabled, exit silently
    exit 0
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Win32 API for getting foreground window with DPI awareness and DWM support
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("dwmapi.dll")]
    public static extern int DwmGetWindowAttribute(IntPtr hwnd, int dwAttribute, out RECT pvAttribute, int cbAttribute);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    public const int DWMWA_EXTENDED_FRAME_BOUNDS = 9;
}
"@

# Set DPI awareness to get correct window coordinates on high-DPI displays
[Win32]::SetProcessDPIAware() | Out-Null

# Read session folder from .current_session file
$currentSessionFile = "C:\Screenshots\.current_session"

if (-not (Test-Path $currentSessionFile)) {
    # Fallback: save to base directory
    $sessionDir = "C:\Screenshots"
} else {
    $sessionDir = (Get-Content $currentSessionFile -Raw).Trim()
}

# Ensure session directory exists
if (-not (Test-Path $sessionDir)) {
    New-Item -ItemType Directory -Path $sessionDir -Force | Out-Null
}

# Get foreground window rectangle using DWM API for accurate boundaries
$hwnd = [Win32]::GetForegroundWindow()
$rect = New-Object Win32+RECT

# Try DWM API first (more accurate, accounts for window shadows and DPI)
$rectSize = [System.Runtime.InteropServices.Marshal]::SizeOf($rect)
$result = [Win32]::DwmGetWindowAttribute($hwnd, [Win32]::DWMWA_EXTENDED_FRAME_BOUNDS, [ref]$rect, $rectSize)

if ($result -ne 0) {
    # DWM failed, fall back to GetWindowRect
    [Win32]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
}

$width = $rect.Right - $rect.Left
$height = $rect.Bottom - $rect.Top

# Validate window dimensions
if ($width -le 0 -or $height -le 0) {
    # Fallback to full screen capture
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $width = $screen.Width
    $height = $screen.Height
    $left = 0
    $top = 0
} else {
    $left = $rect.Left
    $top = $rect.Top
}

# Create bitmap and capture
$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($left, $top, 0, 0, [System.Drawing.Size]::new($width, $height))

# Generate filename with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss_fff"
$filename = "screenshot_$timestamp.jpg"
$filepath = Join-Path $sessionDir $filename

# Save as JPEG with 85% quality
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 85L)

$bitmap.Save($filepath, $jpegCodec, $encoderParams)

# Cleanup
$graphics.Dispose()
$bitmap.Dispose()

exit 0
