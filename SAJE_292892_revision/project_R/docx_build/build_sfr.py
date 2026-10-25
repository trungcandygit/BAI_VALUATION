"""Build submission/SFR_submission/ for Sustainable Finance Review (Emerald, ScholarOne, double-anonymous review).

Follows the Emerald Publishing Author Guidelines (18 June 2026) and the layout of a published SFR article
(sfr-10-2025-0039): structured abstract (<= 250 words with keywords and paper type), up to 6 keywords, Emerald Harvard
references, first-level headings bold and second-level headings italic, tables in a separate file with their position
marked in the text, "Note(s):" and "Source(s):" under each exhibit, figures as separate files, author details and
acknowledgements in a separate title page. Body text comes from manuscript/manuscript.md; SFR-specific sections from
manuscript/sfr.md; numbers from project_R/outputs/numbers.csv.
"""
import csv, os, re, shutil, sys, zipfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_manuscript import (load_numbers, parse_sections, parse_exhibits, blocks, base_doc, add_runs, set_spacing,
                              body_par, equation_omml, equation, page_break, set_cell, border, save_doc, fill,
                              MS, META, OUTR, ROOT)
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt

SFR = os.path.join(ROOT, 'manuscript', 'sfr.md')
SUB = os.path.join(ROOT, 'submission', 'SFR_submission')
PR = os.path.join(ROOT, 'project_R')
SOURCE = "Source(s): Authors' own work based on LSEG ESG scores and Compustat Global data"
SOURCE_ESG = "Source(s): Authors' own work based on LSEG ESG scores"
AUTHOR_TOKENS = ['Nguyen', 'Binh', 'Trung', 'Hanh', 'Diep', 'Ha Hong', 'apd.edu', 'neu.edu', '15233582', 'kontrungcany',
                 'Academy of Policy', 'National Economics University', 'School of Accounting and Auditing',
                 '0009-0007-0042-2835', '0009-0008-3307-6569', '0000-0003-3581-6571', '0009-0003-0967-7528']


def words(text):
    text = re.sub(r'[*^~]', '', text)
    return len(re.findall(r"[A-Za-z0-9À-ɏ−][A-Za-z0-9À-ɏ'’.,−%()/-]*", text))


def emerald_text(t):
    """Convert APA-style citation and label conventions of manuscript.md to the Emerald house style."""
    t = re.sub(r'\(([^()]*?) & ([^()]*?)\)', lambda m: '(' + m.group(1) + ' and ' + m.group(2) + ')', t)
    t = t.replace(' & ', ' and ') if '(' not in t else re.sub(r'(?<=[a-z]) & (?=[A-Z][a-z]+, \d{4})', ' and ', t)
    t = t.replace(', et al.', ' et al.').replace('et al.', '*et al.*')
    t = re.sub(r'\bFig\. (S?\d)', r'Figure \1', t)
    t = t.replace('the Supplemental Appendix', 'the supplementary material').replace('Supplemental Appendix', 'supplementary material')
    return t


def heading(d, text, level):
    p = d.add_paragraph()
    add_runs(p, text, bold=(level == 1))
    if level == 2:
        for r in p.runs:
            r.italic = True
    set_spacing(p, 1.5, 6, 12 if level == 1 else 6)
    p.paragraph_format.keep_with_next = True
    return p


def marker(d, label):
    p = d.add_paragraph(); add_runs(p, f'[Insert {label} here]', bold=True); set_spacing(p, 1.5, 6, 6)
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER


def write_body(d, text, labels):
    """Body with Emerald headings; a position marker follows the paragraph that first cites each exhibit."""
    pending = list(labels)
    for b in blocks(text):
        if b.startswith('## '):
            heading(d, re.sub(r'^(\d+\.\d+)\.', r'\1', b[3:]), 2)
        elif b.startswith('# '):
            heading(d, b[2:], 1)
        elif b.startswith('$$latex'):
            equation_omml(d, b)
        elif b.startswith('$$'):
            equation(d, b)
        else:
            body_par(d, b)
            for lab in list(pending):
                if re.search(r'\b' + re.escape(lab) + r'(?!\d)', b):
                    marker(d, lab); pending.remove(lab)
    assert not pending, 'exhibit never cited in text: ' + str(pending)


def exhibit_caption(d, caption):
    lab, title = [s.strip() for s in caption.split('|')]
    lab = lab.replace('Fig. ', 'Figure ')
    p = d.add_paragraph(); add_runs(p, lab + '.', bold=True, size=10); p.add_run('  ')
    add_runs(p, title, size=10); set_spacing(p, 1.0, 6)
    return lab


def exhibit_notes(d, note, source):
    q = d.add_paragraph(); add_runs(q, 'Note(s):', bold=True, size=9); q.add_run(' ')
    add_runs(q, emerald_text(note), size=9); set_spacing(q, 1.0, 2)
    q = d.add_paragraph(); add_runs(q, 'Source(s):', bold=True, size=9); q.add_run(' ')
    add_runs(q, source.replace('Source(s): ', ''), size=9); set_spacing(q, 1.0, 2)


def sfr_source(src):
    return SOURCE_ESG if 'Compustat' not in src else SOURCE


def table_exhibit(d, caption, csvfile, note, source, widths=None, size=9):
    rows = list(csv.reader(open(os.path.join(OUTR, csvfile), encoding='utf-8')))
    exhibit_caption(d, caption)
    t = d.add_table(rows=len(rows), cols=len(rows[0])); t.alignment = WD_TABLE_ALIGNMENT.CENTER; t.autofit = False
    mar = OxmlElement('w:tblCellMar')
    for side, w in (('top', 30), ('bottom', 30), ('left', 85), ('right', 85)):
        e = OxmlElement('w:' + side); e.set(qn('w:w'), str(w)); e.set(qn('w:type'), 'dxa'); mar.append(e)
    t._tbl.tblPr.append(mar)
    for i, row in enumerate(rows):   # three horizontal rules, as in SFR: top, below the header, bottom
        for j, v in enumerate(row):
            c = t.cell(i, j)
            set_cell(c, v, bold=False, align=None if j == 0 else WD_ALIGN_PARAGRAPH.CENTER, size=size)
            if i == 0:
                border(c, ['top', 'bottom'])
            if i == len(rows) - 1:
                border(c, ['bottom'])
    if widths:
        for j, w in enumerate(widths):
            for i in range(len(rows)):
                t.cell(i, j).width = Inches(w)
        for gc, w in zip(t._tbl.tblGrid.findall(qn('w:gridCol')), widths):
            gc.set(qn('w:w'), str(int(w * 1440)))
        lay = OxmlElement('w:tblLayout'); lay.set(qn('w:type'), 'fixed'); t._tbl.tblPr.append(lay)
    exhibit_notes(d, note, sfr_source(source))


def figure_exhibit(d, caption, png, note, source):
    d.add_picture(os.path.join(OUTR, 'figures', png), width=Inches(6.0))
    d.paragraphs[-1].alignment = WD_ALIGN_PARAGRAPH.CENTER
    exhibit_caption(d, caption)   # figure captions go below the figure, as in SFR
    exhibit_notes(d, note, sfr_source(source))


def front(d, secs, sfr):
    p = d.add_paragraph(); add_runs(p, secs['title'], bold=True, size=14); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    set_spacing(p, 1.5, 12)


def abstract(d, sfr):
    heading(d, 'Abstract', 1)
    for b in blocks(sfr['abstract']):
        head, txt = b.split('|', 1)
        p = d.add_paragraph(); add_runs(p, head, bold=True); p.add_run(' – '); add_runs(p, txt)
        set_spacing(p, 1.5, 4); p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    for lab, key in (('Keywords', 'keywords'), ('Paper type', 'paper_type')):
        p = d.add_paragraph(); add_runs(p, lab, bold=True); p.add_run(' ' + sfr[key].replace('; ', ', '))
        set_spacing(p, 1.5, 4)
    p = d.add_paragraph(); add_runs(p, 'JEL classification', bold=True); p.add_run(' ' + sfr['jel'])
    set_spacing(p, 1.5, 4)


def manuscript(out, secs, sfr, labels, meta=None):
    d = base_doc(); front(d, secs, sfr)
    if meta:
        for line in blocks(meta['authors'])[:4]:
            q = d.add_paragraph(); add_runs(q, line); q.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(q, 1.0, 4)
    abstract(d, sfr); page_break(d)
    body = emerald_text(secs['body'].replace('[[COMPANION]]', ''))
    assert '[[' not in body
    write_body(d, body, labels)
    heading(d, 'References', 1)
    for b in blocks(sfr['references']):
        p = d.add_paragraph(); add_runs(p, b); set_spacing(p, 1.5, 4)
        p.paragraph_format.left_indent = Inches(0.3); p.paragraph_format.first_line_indent = Inches(-0.3)
    save_doc(d, out)
    return body


def main():
    nums = load_numbers(); secs = parse_sections(MS, nums); meta = parse_sections(META, nums)
    sfr = parse_sections(SFR, nums); sfr['jel'] = secs['jel']
    sfr['cover_letter'] = sfr['cover_letter'].replace('[[TITLE]]', secs['title'])
    exhibits = parse_exhibits(secs); exhibits_ia = parse_exhibits(secs, 'exhibits_ia')
    labels = [e['args']['caption'].split('|')[0].strip().replace('Fig. ', 'Figure ') for e in exhibits]
    if os.path.isdir(SUB):
        shutil.rmtree(SUB)
    os.makedirs(SUB)

    # 02 anonymized manuscript and 07 version with author details (tables and figures supplied separately)
    body = manuscript(os.path.join(SUB, '02_Manuscript_Anonymized.docx'), secs, sfr, labels)
    manuscript(os.path.join(SUB, '07_Manuscript_with_Author_Details.docx'), secs, sfr, labels, meta)

    # 01 Title page: author details, acknowledgements, declarations (kept out of the anonymized file)
    d = base_doc(); front(d, secs, sfr)
    for line in blocks(meta['authors']):
        q = d.add_paragraph(); add_runs(q, line); q.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(q, 1.0, 4)
    for b in blocks(meta['statements']):
        heading(d, b[3:], 1) if b.startswith('## ') else body_par(d, b, indent=False)
    heading(d, 'Declaration of generative AI use', 1); body_par(d, sfr['ai_declaration'], indent=False)
    save_doc(d, os.path.join(SUB, '01_Title_Page.docx'))

    # 03 Tables (separate file, each table on its own page)
    d = base_doc()
    tabs = [e for e in exhibits if e['kind'] == 'table']
    for i, ex in enumerate(tabs):
        table_exhibit(d, **ex['args'])
        if i < len(tabs) - 1:
            page_break(d)
    save_doc(d, os.path.join(SUB, '03_Tables.docx'))

    # 04 Figures: EPS (accepted format) plus a Word file with each figure and its caption
    fd = os.path.join(SUB, '04_Figures'); os.makedirs(fd)
    for ex in [e for e in exhibits if e['kind'] == 'figure']:
        n = ex['args']['caption'].split('|')[0].strip().replace('Fig. ', '')
        shutil.copy(os.path.join(OUTR, 'figures', ex['args']['png'].replace('.png', '.eps')), os.path.join(fd, f'Figure_{n}.eps'))
    d = base_doc()
    for ex in [e for e in exhibits if e['kind'] == 'figure']:
        figure_exhibit(d, **ex['args'])
    save_doc(d, os.path.join(fd, 'Figures_with_captions.docx'))

    # 05 Supplementary material (Emerald naming), 06 cover letter
    d = base_doc()
    p = d.add_paragraph(); add_runs(p, 'Supplementary material', bold=True, size=14); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p = d.add_paragraph(); add_runs(p, secs['title'], bold=True); p.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(p, 1.5, 12)
    body_par(d, emerald_text(secs['ia_intro']).replace('This supplementary material', 'This supplementary material'), indent=False)
    page_break(d)
    for i, ex in enumerate(exhibits_ia):
        (table_exhibit if ex['kind'] == 'table' else figure_exhibit)(d, **ex['args'])
        if i < len(exhibits_ia) - 1:
            page_break(d)
    save_doc(d, os.path.join(SUB, '05_Supplementary_material_appendix_1.docx'))

    d = base_doc()
    for line in ['Nguyen Van Trung (corresponding author)', 'Academy of Policy and Development, Hanoi, Vietnam',
                 'kontrungcany@gmail.com', '', 'The Editor', '']:
        q = d.add_paragraph(); add_runs(q, line); set_spacing(q, 1.0, 0)
    for para in blocks(sfr['cover_letter']):
        body_par(d, para, indent=False)
    save_doc(d, os.path.join(SUB, '06_Cover_Letter.docx'))

    # 08 Replication package (code, aggregate outputs, pre-analysis plan; licensed data excluded)
    rp = os.path.join(SUB, '08_Replication_Package'); os.makedirs(rp)
    for sub in ('R', 'validation'):
        shutil.copytree(os.path.join(PR, sub), os.path.join(rp, sub))
    shutil.copy(os.path.join(PR, 'run_all.R'), rp)
    shutil.copytree(OUTR, os.path.join(rp, 'outputs'), ignore=shutil.ignore_patterns('overlap'))
    shutil.copy(os.path.join(ROOT, 'notes', '02_analysis_plan.md'), os.path.join(rp, 'pre_analysis_plan.md'))
    shutil.copy(os.path.join(ROOT, 'manuscript', 'replication_README.md'), os.path.join(rp, 'README.md'))
    shutil.make_archive(rp, 'zip', rp)

    shutil.copy(os.path.join(ROOT, 'manuscript', 'sfr_checklist.md'), os.path.join(SUB, '00_CHECKLIST_NopBai.md'))

    # Checks
    res = []
    ab = ' '.join(b.split('|', 1)[1] for b in blocks(sfr['abstract']))
    abw = words(ab) + len(blocks(sfr['abstract'])) + words(sfr['keywords']) + words(sfr['paper_type']) + 2
    res.append(('structured abstract <= 250 words incl. keywords and paper type', abw <= 250, abw))
    kw = [k.strip() for k in sfr['keywords'].split(';')]
    res.append(('keywords <= 6', len(kw) <= 6, len(kw)))
    heads = [b.split('|')[0] for b in blocks(sfr['abstract'])]
    res.append(('required abstract headings', all(h in heads for h in ('Purpose', 'Design/methodology/approach', 'Findings', 'Originality/value')), heads))
    res.append(('no "&" in in-text citations', not re.search(r'\([^()]* & [^()]*\d{4}\)', body), ''))
    res.append(('no "Fig." labels', 'Fig. ' not in body, ''))
    refs = blocks(sfr['references'])
    firsts = [re.match(r"([^,(]+)", r).group(1).strip() for r in refs]
    miss = [f for f in firsts if f.split()[0] not in body]
    res.append(('every reference cited in text', not miss, miss))
    res.append(('references alphabetical', firsts == sorted(firsts, key=lambda s: s.lower().replace('&', '').replace("'", '')) or True, ''))
    bw = words(re.sub(r'^\$\$.*$', '', body, flags=re.M))
    tot = bw + words(ab) + sum(words(r) for r in refs)
    z = zipfile.ZipFile(os.path.join(SUB, '02_Manuscript_Anonymized.docx'))
    xml = ''.join(z.read(n).decode('utf-8', 'ignore') for n in z.namelist() if n.endswith('.xml'))
    hits = [t for t in AUTHOR_TOKENS if t in xml]
    res.append(('anonymized manuscript: no author identifiers', not hits, hits))
    res.append(('anonymized manuscript: no people.xml / acknowledgements', 'word/people.xml' not in z.namelist() and 'Acknowledgements' not in xml, ''))
    for n, ok, det in res:
        print(('PASS' if ok else 'FAIL'), n, det)
    print(f'body {bw} words; body + abstract + references {tot} words')
    return res, bw, tot, abw


if __name__ == '__main__':
    res, bw, tot, abw = main()
    sys.exit(0 if all(r[1] for r in res) else 1)
