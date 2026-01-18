# session_end.ps1
# Logs session end and cleans up .current_session file

$ErrorActionPreference = "SilentlyContinue"

$baseDir = "C:\Screenshots"
$currentSessionFile = Join-Path $baseDir ".current_session"

# Get session folder path before cleanup
$sessionDir = $null
if (Test-Path $currentSessionFile) {
    $sessionDir = (Get-Content $currentSessionFile -Raw).Trim()
}

# Log session end
$logFile = Join-Path $baseDir "_session_log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($sessionDir) {
    $sessionName = Split-Path $sessionDir -Leaf

    # Count screenshots in session folder
    $screenshotCount = 0
    if (Test-Path $sessionDir) {
        $screenshotCount = (Get-ChildItem -Path $sessionDir -Filter "*.jpg" -ErrorAction SilentlyContinue | Measure-Object).Count
    }

    "[$timestamp] Session ended: $sessionName (Screenshots: $screenshotCount)" | Out-File -FilePath $logFile -Encoding UTF8 -Append
} else {
    "[$timestamp] Session ended: (unknown session)" | Out-File -FilePath $logFile -Encoding UTF8 -Append
}

# Clean up .current_session file (optional - uncomment to enable)
# if (Test-Path $currentSessionFile) {
#     Remove-Item $currentSessionFile -Force
# }

exit 0
