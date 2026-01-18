---
name: stop-screenshot
description: Disable automatic screenshot capture
command: powershell -NoProfile -ExecutionPolicy Bypass -File "C:\claude-code-test\screenshot-hooks\.claude-plugin\scripts\stop-screenshot.ps1"
---

Disable automatic screenshot capture by removing the state file.

After running this command, no screenshots will be captured until you run `/start-screenshot` again.
