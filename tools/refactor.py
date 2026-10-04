#!/usr/bin/env python3
"""Apply a rename spec to the decompiled AS3 client source.
usage: refactor.py SPEC.json [--src client-source/src] [--dry]
Spec keys:
  package_map : {oldPkg: newPkg}                (moves dirs, rewrites package/import/FQN)
  classes     : {oldClass: newClass}            (global; class names are unique repo-wide)
  members     : [{old,new,files:[oldClassName,...]|"*"}]   files = classes whose files get the rename;
                "*" = every file (only for tokens declared in exactly one file)
  locals      : {"auto": true, "scope": [oldClassNames], "overrides": [{class,func,old,new}]}
Files are matched by ORIGINAL class name. Run from repo root. Idempotent per spec."""
import re, os, sys, json, subprocess, collections

SRC = 'client-source/src'
args = [a for a in sys.argv[1:] if not a.startswith('--')]
DRY = '--dry' in sys.argv
if '--src' in sys.argv: SRC = sys.argv[sys.argv.index('--src') + 1]; args.remove(SRC)
spec = json.load(open(args[0]))

def rd(p):
    b = open(p, 'rb').read()
    bom = b.startswith(b'\xef\xbb\xbf')
    return b.decode('utf-8-sig', errors='surrogateescape'), bom
def wr(p, s, bom):
    open(p, 'wb').write((b'\xef\xbb\xbf' if bom else b'') + s.encode('utf-8', errors='surrogateescape'))

files = {}      # path -> [text, bom]
for r, _, fs in os.walk(SRC):
    for f in fs:
        if f.endswith('.as'):
            p = os.path.join(r, f); files[p] = list(rd(p))

# original class -> path
orig = {}
for p in files:
    orig[os.path.basename(p)[:-3]] = p
pkg_of = {}
for p, (t, _) in files.items():
    m = re.search(r'^\s*package\s+([\w.]*)\s*\{', t, re.M); pkg_of[p] = m.group(1) if m else ''

DECL = re.compile(r'\b(?:var|const|function(?:\s+(?:get|set))?)\s+([\w$]+)')
declared = collections.defaultdict(set)
for p_, (t_, _) in files.items():
    for m_ in DECL.finditer(t_): declared[m_.group(1)].add(p_)
users = {c: {p_ for p_, (t_, _) in files.items() if re.search(r'(?<![\w$])' + re.escape(c) + r'(?![\w$])', t_)} for c in orig}
BATCH = {orig[c] for c in spec.get('batch', []) if c in orig}
W = lambda tok: re.compile(r'(?<![\w$])' + re.escape(tok) + r'(?![\w$])')
log = collections.defaultdict(list)

# 1. classes (global)
for old, new in spec.get('classes', {}).items():
    rx = W(old)
    for p, v in files.items():
        n = len(rx.findall(v[0]))
        if n: v[0] = rx.sub(new, v[0]); log['class ' + old].append((p, n))

# 2. packages
for old, new in spec.get('package_map', {}).items():
    rx = re.compile(r'(?<![\w$.])' + re.escape(old) + r'(?=\.[A-Za-z_]|\s*\{|\s*$|\b)')
    for p, v in files.items():
        t = v[0]
        t2 = re.sub(r'(\bpackage\s+)' + re.escape(old) + r'\b', r'\g<1>' + new, t)
        t2 = re.sub(r'(\bimport\s+)' + re.escape(old) + r'(?=\.)', r'\g<1>' + new, t2)
        t2 = re.sub(r'(//\s*package\s+)' + re.escape(old) + r'\b', r'\g<1>' + new, t2)
        t2 = re.sub(r'^(//)' + re.escape(old) + r'(?=\.)', r'\g<1>' + new, t2, flags=re.M)
        t2 = re.sub(r'(?<![\w$.])' + re.escape(old) + r'(?=\.[A-Za-z_])', new, t2)  # FQN use
        if t2 != t: v[0] = t2; log['package ' + old].append((p, 1))

def strip_noise(s):
    out = []; i = 0; n = len(s)
    while i < n:
        c = s[i]
        if s.startswith('//', i):
            j = s.find('\n', i); j = n if j < 0 else j; out.append(' ' * (j - i)); i = j
        elif s.startswith('/*', i):
            j = s.find('*/', i + 2); j = n if j < 0 else j + 2; out.append(re.sub(r'[^\n]', ' ', s[i:j])); i = j
        elif c in '"\'':
            j = i + 1
            while j < n and s[j] != c:
                j += 2 if s[j] == '\\' else 1
            out.append(c + ' ' * (j - i - 1) + c); i = j + 1
        else: out.append(c); i += 1
    return ''.join(out)

# 3. members  (entry: old,new,classes:[origClass], users:bool)
for ent in spec.get('members', []):
    scope = {orig[c] for c in ent['classes']}
    if ent.get('users'):
        for c in ent['classes']: scope |= users[c]
    outside = declared.get(ent['old'], set()) - scope - BATCH
    if outside and ent.get('users'):
        print('REFUSED (public, shared token) %s -> %s: also declared in %s' % (ent['old'], ent['new'], sorted(outside)[:3])); continue
    if outside:   # token reused by obfuscator elsewhere: only OK if every use inside scope is own-member (bare or this.)
        amb = []
        for p in scope:
            tx = strip_noise(files[p][0])
            for mm in W(ent['old']).finditer(tx):
                pre = tx[:mm.start()].rstrip()
                if pre.endswith('.') and not pre[:-1].rstrip().endswith('this'): amb.append(p); break
        if amb:
            print('REFUSED (foreign receiver) %s -> %s in %s' % (ent['old'], ent['new'], [os.path.basename(a) for a in amb])); continue
    rx = W(ent['old'])
    for p in scope:
        n = len(rx.findall(files[p][0]))
        if n: files[p][0] = rx.sub(ent['new'], files[p][0]); log['member ' + ent['old']].append((p, n))

# 4. locals / args by declared type
PRIM = {'int','uint','Number','String','Boolean','Object','Array','*','void','Function','Class','Date','RegExp'}
def camel(t):
    t = t.split('.')[-1]
    if t in ('XML',): return 'xml'
    if t == 'XMLList': return 'xmlList'
    return t[0].lower() + t[1:] if t and not t.isupper() else t.lower()
def tname(t):
    t = t.strip()
    m = re.match(r'Vector\.<\s*([\w.]+)\s*>', t)
    if m:
        inner = m.group(1).split('.')[-1]
        if inner in PRIM: return None
        b = camel(inner); return b + ('es' if b.endswith('s') else 's')
    t = t.split('.')[-1]
    if t in PRIM or re.match(r'^_[0-9A-Za-z]{1,4}_?$', t): return None
    return camel(t)
RESERVED = set('as break case catch class const continue default delete do else extends false finally for function if implements import in instanceof interface internal is new null package private protected public return super switch this throw to true try typeof use var void while with each get set include namespace override static native dynamic final event object string number int uint xml xmlList array date error'.split()) - {'event', 'xml', 'xmlList', 'error'}
def functions(s):
    clean = strip_noise(s); res = []
    for m in re.finditer(r'\bfunction\s+(?:(?:get|set)\s+)?([\w$]+)\s*\(', clean):
        i = m.end(); d = 1
        while i < len(clean) and d:
            d += (clean[i] == '(') - (clean[i] == ')'); i += 1
        sig_end = i
        j = clean.find('{', sig_end); semi = clean.find(';', sig_end)
        if j < 0 or (0 <= semi < j): continue
        d = 0; k = j
        while k < len(clean):
            d += (clean[k] == '{') - (clean[k] == '}')
            k += 1
            if d == 0: break
        res.append((m.group(1), m.end(), k))
    return res, clean

loc = spec.get('locals', {})
renamed_locals = 0
if loc.get('auto'):
    scope = [orig[c] for c in (loc.get('scope') or spec.get('batch', [])) if c in orig]
    ov = loc.get('overrides', [])
    for p in scope:
        t = files[p][0]; fns, clean = functions(t)
        used = set(re.findall(r'[\w$]+', clean))
        edits = []   # (start,end,newtext)
        newtext = list(t)
        for fname, s0, e0 in fns:
            seg = clean[s0 - 1:e0]
            decl = {}
            for m in re.finditer(r'(?:\(|,|\bvar)\s*(_(?:arg|local)\d+)\s*:\s*([\w.]+(?:\.<[\w.]+>)?)', seg):
                decl.setdefault(m.group(1), m.group(2))
            names = {}; taken = set()
            for o in ov:
                if o['class'] == os.path.basename(p)[:-3] and o['func'] == fname and o['old'] in decl:
                    names[o['old']] = o['new']; taken.add(o['new'])
            for tok, ty in decl.items():
                if tok in names: continue
                nm = tname(ty)
                if not nm or nm in RESERVED: continue
                base = nm; i = 1
                while nm in used or nm in taken or nm in RESERVED:
                    i += 1; nm = base + str(i)
                names[tok] = nm; taken.add(nm)
            for tok, nm in names.items():
                for m in W(tok).finditer(clean, s0, e0):
                    edits.append((m.start(), m.end(), nm))
        for a, b, nm in sorted(edits, reverse=True):
            t = t[:a] + nm + t[b:]
        renamed_locals += len(edits)
        files[p][0] = t

# 5. write + move
moves = []
cls_new = spec.get('classes', {})
for old, p in orig.items():
    if BATCH and p not in BATCH: continue
    t, bom = files[p]
    m = re.search(r'^\s*package\s+([\w.]*)\s*\{', t, re.M); pk = m.group(1) if m else ''
    nname = cls_new.get(old, old)
    target = os.path.join(SRC, *pk.split('.'), nname + '.as') if pk else os.path.join(SRC, nname + '.as')
    if os.path.normpath(target) != os.path.normpath(p): moves.append((p, target))
if DRY:
    print('dry run:', {k: len(v) for k, v in log.items()}.__len__(), 'rename groups;', len(moves), 'file moves;', renamed_locals, 'local/arg edits'); sys.exit()
for p, (t, bom) in files.items(): wr(p, t, bom)
for a, b in moves:
    os.makedirs(os.path.dirname(b), exist_ok=True)
    subprocess.run(['git', 'mv', a, b], check=True)
# cleanup empty old dirs
for r, ds, fs in os.walk(SRC, topdown=False):
    if not os.listdir(r) and r != SRC: os.rmdir(r)
print('moved', len(moves), 'files;', renamed_locals, 'local/arg edits;', len(log), 'rename groups')
