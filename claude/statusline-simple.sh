#!/bin/bash
# Statusline without OMC HUD — for profiles that don't use oh-my-claudecode
cat | python3 "$HOME/.claude/statusline.py" 2>/dev/null
