---
name: stop-screenshot
description: Disable automatic screenshot capture
command: powershell -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/stop-screenshot.ps1"
---

Disable automatic screenshot capture by removing the state file.

After running this command, no screenshots will be captured until you run `/start-screenshot` again.

