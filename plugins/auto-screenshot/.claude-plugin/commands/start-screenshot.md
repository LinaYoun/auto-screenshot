---
name: start-screenshot
description: Enable automatic screenshot capture
command: powershell -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/start-screenshot.ps1"
---

Enable automatic screenshot capture by creating the state file.

After running this command, screenshots will be captured automatically on:
- User prompt submission
- Bash command execution

To disable, use `/stop-screenshot`.

