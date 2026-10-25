"""Write the new manuscript's sections (filled text) to project_R/overlap/new_manuscript_sections.tsv for overlap_audit.R."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_manuscript import load_numbers, parse_sections, MS, META, ROOT
nums = load_numbers(); secs = parse_sections(MS, nums); meta = parse_sections(META, nums)
body = secs['body'].replace('[[COMPANION]]', meta['companion_named'])
parts = re.split(r'^# (\d+)\. ([^\n]+)$', body, flags=re.M)
rows = [('Title', secs['title']), ('Abstract', secs['abstract'])]
for i in range(1, len(parts), 3):
    rows.append((parts[i + 1].strip(), parts[i + 2]))
rows.append(('Exhibit captions and notes', secs['exhibits']))
clean = lambda t: re.sub(r'\s+', ' ', t.replace('\t', ' ')).strip()
with open(os.path.join(ROOT, 'project_R', 'overlap', 'new_manuscript_sections.tsv'), 'w', encoding='utf-8') as f:
    f.write('section\ttext\n')
    for s, t in rows:
        f.write(f'{s}\t{clean(t)}\n')
print([r[0] for r in rows])
