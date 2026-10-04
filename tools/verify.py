#!/usr/bin/env python3
"""Static checks: every repo import resolves, no stale tokens. usage: verify.py [--stale tok1,tok2,...]"""
import re, os, sys
SRC = 'client-source/src'
files = {}
for r, _, fs in os.walk(SRC):
    for f in fs:
        if f.endswith('.as'): p = os.path.join(r, f); files[p] = open(p, encoding='utf-8-sig', errors='replace').read()
tops = {d for d in os.listdir(SRC) if os.path.isdir(os.path.join(SRC, d))}
bad = []
for p, t in files.items():
    for m in re.finditer(r'^\s*import\s+([\w.]+)\s*;', t, re.M):
        parts = m.group(1).split('.')
        if parts[0] in tops and not os.path.exists(os.path.join(SRC, *parts) + '.as'):
            bad.append((p, m.group(1)))
    mp = re.search(r'^\s*package\s+([\w.]*)\s*\{', t, re.M)
    if mp is not None:
        pk = mp.group(1); exp = os.path.dirname(os.path.relpath(p, SRC)).replace(os.sep, '.')
        if pk != exp: bad.append((p, 'package mismatch: %s vs dir %s' % (pk, exp)))
        cn = re.search(r'\b(?:class|interface)\s+([\w$]+)', t)
        if cn and cn.group(1) != os.path.basename(p)[:-3]: bad.append((p, 'class %s != filename' % cn.group(1)))
print('files:', len(files), '| problems:', len(bad))
for b in bad[:40]: print('  ', *b)
if '--stale' in sys.argv:
    for tok in sys.argv[sys.argv.index('--stale') + 1].split(','):
        rx = re.compile(r'(?<![\w$])' + re.escape(tok) + r'(?![\w$])')
        hits = [p for p, t in files.items() if rx.search(t)]
        print('stale', tok, '->', len(hits), 'files', hits[:4])
sys.exit(1 if bad else 0)
