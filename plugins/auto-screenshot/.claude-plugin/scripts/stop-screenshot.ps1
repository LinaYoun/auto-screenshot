$stateFile = "C:\Screenshots\.screenshot_enabled"

# Remove state file to disable screenshots
if (Test-Path $stateFile) {
    Remove-Item -Path $stateFile -Force
    Write-Host "Screenshot capture disabled"
} else {
    Write-Host "Screenshot capture was already disabled"
}
