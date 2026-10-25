"""Export the filled manuscript (text + exhibits as Markdown tables) for reviewers: notes/review_independent/input/."""
import csv, os, re, shutil, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_manuscript import load_numbers, parse_sections, parse_exhibits, blocks, MS, META, OUTR, ROOT

out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'notes', 'review_independent', 'input')
os.makedirs(out, exist_ok=True)
nums = load_numbers(); secs = parse_sections(MS, nums); meta = parse_sections(META, nums)
body = secs['body'].replace('[[COMPANION]]', meta['companion_blind'])
def md_table(f):
    rows = list(csv.reader(open(os.path.join(OUTR, f), encoding='utf-8')))
    lines = ['| ' + ' | '.join(rows[0]) + ' |', '|' + '---|' * len(rows[0])]
    lines += ['| ' + ' | '.join(r) + ' |' for r in rows[1:]]
    return '\n'.join(lines)
parts = ['# ' + secs['title'], '', 'Running title: ' + secs['running_title'], '', '## Abstract', '', secs['abstract'], '',
         'Keywords: ' + secs['keywords'], '', 'JEL classification: ' + secs['jel'], '', re.sub(r'^(#+) ', lambda m: '#' + m.group(1) + ' ', body, flags=re.M), '',
         '## References', '']
parts += [b + '\n' for b in blocks(secs['references'])]
for key, title in (('exhibits', 'Exhibits'), ('exhibits_ia', 'Supplemental Appendix exhibits')):
    parts += ['', '## ' + title, '']
    for ex in parse_exhibits(secs, key):
        a = ex['args']; cap = a['caption'].replace('|', ' ')
        parts += ['### ' + cap, '']
        if ex['kind'] == 'table':
            parts += [md_table(a['csvfile']), '']
        else:
            shutil.copy(os.path.join(OUTR, 'figures', a['png']), os.path.join(out, a['png']))
            parts += [f'[Figure image file: {a["png"]} in this folder]', '']
        parts += ['Note: ' + a['note'].replace('\\*', '*'), '', 'Source: ' + a['source'], '']
open(os.path.join(out, 'manuscript_for_review.md'), 'w', encoding='utf-8').write('\n'.join(parts))
print('exported', out)
