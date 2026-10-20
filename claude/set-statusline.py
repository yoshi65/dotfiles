#!/usr/bin/env python3
"""Point ~/.claude/settings.json at statusline-simple.sh, keeping every other setting."""
import json
import os
from pathlib import Path
import shutil
import tempfile
import time

root = Path.home() / '.claude'
settings = root / 'settings.json'
data = json.loads(settings.read_text()) if settings.exists() else {}
statusline = {'type': 'command', 'command': 'bash $HOME/.claude/statusline-simple.sh'}
if data.get('statusLine') == statusline:
    print('    statusline already configured')
else:
    data['statusLine'] = statusline
    if settings.exists():
        backup = root / f'settings.json.backup-statusline-{time.time_ns()}'
        shutil.copy2(settings, backup)
        print(f'    settings backup: {backup.name}')
    fd, temporary = tempfile.mkstemp(prefix='.settings-', suffix='.json', dir=root)
    try:
        with os.fdopen(fd, 'w') as out:
            json.dump(data, out, ensure_ascii=False, indent=2)
            out.write('\n')
        if settings.exists():
            os.chmod(temporary, settings.stat().st_mode & 0o777)
        os.replace(temporary, settings)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)
    print('    statusline configured')
