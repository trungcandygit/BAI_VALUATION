"""Check the blue marking of a marked .docx against the round-0 submission, sentence by sentence.

Usage: python3 check_blue.py MARKED.docx ORIGINAL.docx [ORIGINAL2.docx ...]
A sentence is 'blue' if every non-space character in it is in a blue run. Reports new sentences that are not
blue and unchanged sentences that are blue."""
import re, sys
from docx import Document
SPLIT = re.compile(r'(?<!\bal\.)(?<!\be\.g\.)(?<!\bi\.e\.)(?<!\bEq\.)(?<!\bEqs\.)(?<!\bNo\.)(?<!\bvs\.)(?<=[.?!])\s+(?=[A-Z(\[0-9H])')


def norm(s):
    s = s.replace('’', "'").replace('‘', "'").replace('“', '"').replace('”', '"').replace(' ', ' ')
    s = re.sub(r'^(\d+(?:\.\d+)*)\.?\s', r'\1 ', s.strip())
    return re.sub(r'\s+', ' ', s).strip()


def paras(d):
    for p in d.paragraphs:
        yield p
    for t in d.tables:
        for row in t.rows:
            for c in row.cells:
                yield from c.paragraphs


orig = set()
for f in sys.argv[2:]:
    for p in paras(Document(f)):
        for s in SPLIT.split(p.text):
            if norm(s):
                orig.add(norm(s))
miss, over, n = [], [], 0
for p in paras(Document(sys.argv[1])):
    chars = []
    for r in p.runs:
        blue = r.font.color is not None and r.font.color.rgb is not None and str(r.font.color.rgb) == '0000FF'
        chars += [(ch, blue) for ch in r.text]
    text = ''.join(c for c, _ in chars)
    pos = 0
    for s in SPLIT.split(text):
        k = text.find(s, pos); pos = k + len(s)
        seg = chars[k:k + len(s)]
        nb = [b for c, b in seg if not c.isspace()]
        if not nb or not norm(s):
            continue
        n += 1
        is_new = norm(s) not in orig
        if is_new and not all(nb):
            miss.append(s)
        if not is_new and any(nb):
            over.append(s)
print(f"sentences {n}; new but not fully blue {len(miss)}; unchanged but blue {len(over)}")
for s in miss[:40]:
    print('  MISS:', s[:140])
for s in over[:40]:
    print('  OVER:', s[:140])
