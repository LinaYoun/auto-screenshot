$baseDir = "C:\Screenshots"
$stateFile = Join-Path $baseDir ".screenshot_enabled"

# Ensure base directory exists
if (-not (Test-Path $baseDir)) {
    New-Item -ItemType Directory -Path $baseDir -Force | Out-Null
}

# Create state file to enable screenshots
"enabled" | Out-File -FilePath $stateFile -Encoding UTF8 -NoNewline

Write-Host "Screenshot capture enabled"
