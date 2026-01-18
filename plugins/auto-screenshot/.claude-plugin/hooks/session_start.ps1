# session_start.ps1
# Creates session folder and saves path to .current_session file

$ErrorActionPreference = "SilentlyContinue"

# Read JSON from stdin
$jsonInput = [Console]::In.ReadToEnd()

# Parse session_id from JSON
try {
    $data = $jsonInput | ConvertFrom-Json
    $sessionId = $data.session_id
} catch {
    # Fallback: generate timestamp-based session ID
    $sessionId = "session_" + (Get-Date -Format "yyyyMMdd_HHmmss")
}

# Ensure session_id is valid
if ([string]::IsNullOrWhiteSpace($sessionId)) {
    $sessionId = "session_" + (Get-Date -Format "yyyyMMdd_HHmmss")
}

# Create session folder
$baseDir = "C:\Screenshots"
$sessionDir = Join-Path $baseDir $sessionId

if (-not (Test-Path $baseDir)) {
    New-Item -ItemType Directory -Path $baseDir -Force | Out-Null
}

if (-not (Test-Path $sessionDir)) {
    New-Item -ItemType Directory -Path $sessionDir -Force | Out-Null
}

# Save session path to .current_session file
$currentSessionFile = Join-Path $baseDir ".current_session"
$sessionDir | Out-File -FilePath $currentSessionFile -Encoding UTF8 -NoNewline

# Enable screenshot capture by default (create state file)
$stateFile = Join-Path $baseDir ".screenshot_enabled"
if (-not (Test-Path $stateFile)) {
    "enabled" | Out-File -FilePath $stateFile -Encoding UTF8 -NoNewline
}

# Log session start
$logFile = Join-Path $baseDir "_session_log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$timestamp] Session started: $sessionId" | Out-File -FilePath $logFile -Encoding UTF8 -Append

exit 0
