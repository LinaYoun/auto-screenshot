$baseDir = "C:\Screenshots"
$stateFile = Join-Path $baseDir ".screenshot_enabled"
$currentSessionFile = Join-Path $baseDir ".current_session"

# Ensure base directory exists
if (-not (Test-Path $baseDir)) {
    New-Item -ItemType Directory -Path $baseDir -Force | Out-Null
}

# Create state file to enable screenshots
"enabled" | Out-File -FilePath $stateFile -Encoding UTF8 -NoNewline

# Create session folder if not exists
if (-not (Test-Path $currentSessionFile)) {
    # Generate new session ID
    $sessionId = "session_" + (Get-Date -Format "yyyyMMdd_HHmmss")
    $sessionDir = Join-Path $baseDir $sessionId

    # Create session folder
    New-Item -ItemType Directory -Path $sessionDir -Force | Out-Null

    # Save session path
    $sessionDir | Out-File -FilePath $currentSessionFile -Encoding UTF8 -NoNewline

    # Log
    $logFile = Join-Path $baseDir "_session_log.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$timestamp] Session started (via /start-screenshot): $sessionId" | Out-File -FilePath $logFile -Encoding UTF8 -Append

    Write-Host "Screenshot capture enabled. Session folder: $sessionId"
} else {
    $existingSession = Get-Content $currentSessionFile -Raw
    Write-Host "Screenshot capture enabled. Using existing session: $(Split-Path $existingSession -Leaf)"
}
