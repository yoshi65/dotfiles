#!/usr/bin/env python3
import sys
import json
from datetime import datetime, timezone

# Braille gauge characters (0/8 to 8/8 fill)
BRAILLE = " ⡀⡄⡆⡇⣇⣧⣷⣿"

def gradient(pct):
    """Green(0%) -> Yellow(50%) -> Red(100%) true-color ANSI."""
    if pct <= 50:
        r = int(255 * pct / 50)
        g = 255
    else:
        r = 255
        g = int(255 * (100 - pct) / 50)
    return f"\033[38;2;{r};{g};0m"

RESET = "\033[0m"
DIM = "\033[38;2;160;160;160m"

def braille_gauge(pct, width=5):
    """Render a braille density gauge."""
    chars = []
    for i in range(width):
        segment_start = i * (100 / width)
        segment_end = (i + 1) * (100 / width)
        if pct >= segment_end:
            level = 8
        elif pct <= segment_start:
            level = 0
        else:
            level = int((pct - segment_start) / (100 / width) * 8)
        chars.append(BRAILLE[level])
    return "".join(chars)

def fmt_reset(ts):
    """Format reset time as relative duration."""
    now = datetime.now(timezone.utc)
    reset = datetime.fromtimestamp(ts, tz=timezone.utc)
    delta = reset - now
    secs = int(delta.total_seconds())
    if secs <= 0:
        return "now"
    h, m = divmod(secs // 60, 60)
    if h > 24:
        return f"{secs // 86400}d"
    if h > 0:
        return f"{h}h{m:02d}m"
    return f"{m}m"

try:
    data = json.load(sys.stdin)
except Exception:
    data = {}

parts = []

# Model
model = data.get("model", {})
display = model.get("display_name", "")
if display:
    parts.append(f"\033[38;2;180;180;255m{display}{RESET}")

# Rate limits
rl = data.get("rate_limits", {})
for key, label in [("five_hour", "5h"), ("seven_day", "7d")]:
    info = rl.get(key) or {}
    pct = info.get("used_percentage")
    if pct is None:
        continue
    color = gradient(pct)
    gauge = braille_gauge(pct)
    reset = fmt_reset(info["resets_at"]) if info.get("resets_at") else "?"
    parts.append(f"{DIM}{label}{RESET} {color}{gauge} {pct:.0f}%{RESET} {DIM}{reset}{RESET}")

# Context window
ctx = data.get("context_window", {})
if ctx:
    pct = ctx.get("used_percentage", 0)
    color = gradient(pct)
    gauge = braille_gauge(pct, width=3)
    parts.append(f"{DIM}ctx{RESET} {color}{gauge} {pct:.0f}%{RESET}")

# Cost
cost = data.get("cost", {})
usd = cost.get("total_cost_usd") or 0
if usd > 0:
    parts.append(f"{DIM}${usd:.2f}{RESET}")

# 全項目欠損でも空行を返さない（combined.sh が「空=非表示」扱いするため）
print(" │ ".join(parts) if parts else f"{DIM}…{RESET}")
