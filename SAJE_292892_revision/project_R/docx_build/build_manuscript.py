"""Build the JF:IP manuscript DOCX files from manuscript/manuscript.md and R outputs.

Every number in the text is a {{key}} placeholder resolved from project_R/outputs/numbers.csv (written by R);
every table cell comes from project_R/outputs/table*_formatted.csv. Unknown placeholders stop the build.

Markup in manuscript.md:
  % comment line (ignored)
  #  Heading 1       ## Heading 2
  $$ equation text | (n)      display equation, number right-aligned
  [[TABLE:n]] [[FIGURE:n]]    exhibit anchors are not placed in text (JF:IP: exhibits after references)
  *italic*  ^superscript^  ~subscript~
  Sections are delimited by lines '@@ name' (title, abstract, keywords, jel, body, references, ia).
"""
import csv, os, re, sys
from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_BREAK, WD_TAB_ALIGNMENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
OUTR = os.path.join(ROOT, 'project_R', 'outputs')
MS = os.path.join(ROOT, 'manuscript', 'manuscript.md')
META = os.path.join(ROOT, 'manuscript', 'meta.md')


def load_numbers():
    with open(os.path.join(OUTR, 'numbers.csv'), encoding='utf-8') as f:
        return {r['key']: r['value'] for r in csv.DictReader(f)}


def fill(text, nums):
    def rep(m):
        k = m.group(1)
        if k not in nums:
            sys.exit('Unknown placeholder {{%s}}' % k)
        return nums[k]
    return re.sub(r'\{\{([A-Za-z0-9_]+)\}\}', rep, text)


def parse_sections(path, nums):
    secs, cur = {}, None
    for line in open(path, encoding='utf-8').read().splitlines():
        if line.startswith('%'):
            continue
        if line.startswith('@@ '):
            cur = line[3:].strip(); secs[cur] = []; continue
        if cur is not None:
            secs[cur].append(fill(line, nums))
    return {k: '\n'.join(v).strip() for k, v in secs.items()}


def blocks(text):
    return [b.strip() for b in re.split(r'\n\s*\n', text) if b.strip()]


TOKEN = re.compile(r'(\*[^*]+\*|\^[^^]+\^|~[^~]+~)')


STAR = '\u2217'   # placeholder for a literal asterisk written as \* in the source


def add_runs(p, text, bold=False, size=None):
    text = text.replace('\\*', STAR)
    for part in TOKEN.split(text.replace('\n', ' ')):
        if not part:
            continue
        part_out = None
        r = p.add_run()
        if part.startswith('*') and part.endswith('*') and len(part) > 2:
            r.text = part[1:-1]; r.italic = True
        elif part.startswith('^') and part.endswith('^') and len(part) > 2:
            r.text = part[1:-1]; r.font.superscript = True
        elif part.startswith('~') and part.endswith('~') and len(part) > 2:
            r.text = part[1:-1]; r.font.subscript = True
        else:
            r.text = part
        r.text = r.text.replace(STAR, '*')
        r.bold = bold or None
        if size:
            r.font.size = Pt(size)
    return p


def set_spacing(p, line=1.5, after=6, before=0):
    pf = p.paragraph_format
    pf.line_spacing = line; pf.space_after = Pt(after); pf.space_before = Pt(before)


M_NS = 'http://schemas.openxmlformats.org/officeDocument/2006/math'
W_NS = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
SCHEMA_ORDER = {   # child order required by the OOXML schema (python-docx and pandoc output violate it)
    f'{{{M_NS}}}rPr': [f'{{{M_NS}}}{t}' for t in ('lit', 'nor', 'scr', 'sty', 'brk', 'aln')],
    f'{{{M_NS}}}dPr': [f'{{{M_NS}}}{t}' for t in ('begChr', 'sepChr', 'endChr', 'grow', 'shp', 'ctrlPr')],
    f'{{{W_NS}}}tblPr': [f'{{{W_NS}}}{t}' for t in (
        'tblStyle', 'tblpPr', 'tblOverlap', 'bidiVisual', 'tblStyleRowBandSize', 'tblStyleColBandSize', 'tblW', 'jc',
        'tblCellSpacing', 'tblInd', 'tblBorders', 'shd', 'tblLayout', 'tblCellMar', 'tblLook', 'tblCaption',
        'tblDescription')],
    f'{{{W_NS}}}tblCellMar': [f'{{{W_NS}}}{t}' for t in ('top', 'start', 'left', 'bottom', 'end', 'right')],
}


def save_doc(d, out):
    """Save after putting children in schema order and completing w:zoom, so the file passes XSD validation."""
    for parent_tag, order in SCHEMA_ORDER.items():
        rank = {t: i for i, t in enumerate(order)}
        for el in d.element.body.iter(parent_tag):
            seen = {}
            for k in list(el):   # a property may appear once; keep the last setting
                if k.tag in seen:
                    el.remove(seen[k.tag])
                seen[k.tag] = k
            kids = sorted(el, key=lambda k: rank.get(k.tag, len(order)))
            for k in kids:
                el.append(k)
    for z in d.settings.element.iter(f'{{{W_NS}}}zoom'):
        if z.get(f'{{{W_NS}}}percent') is None:
            z.set(f'{{{W_NS}}}percent', '100')
    d.save(out)


def base_doc():
    d = Document()
    st = d.styles['Normal']; st.font.name = 'Times New Roman'; st.font.size = Pt(12)
    st.element.rPr.rFonts.set(qn('w:eastAsia'), 'Times New Roman')
    for s in d.sections:
        s.left_margin = s.right_margin = Inches(1); s.top_margin = s.bottom_margin = Inches(1.5)
    add_page_numbers(d)
    cp = d.core_properties; cp.author = ''; cp.last_modified_by = ''; cp.title = ''; cp.comments = ''
    return d


def add_page_numbers(d):
    footer = d.sections[0].footer
    p = footer.paragraphs[0]; p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run()
    for tag, txt in (('begin', None), (None, 'PAGE'), ('end', None)):
        if tag:
            el = OxmlElement('w:fldChar'); el.set(qn('w:fldCharType'), tag); r._r.append(el)
        else:
            el = OxmlElement('w:instrText'); el.set(qn('xml:space'), 'preserve'); el.text = txt; r._r.append(el)


def heading(d, text, level):
    p = d.add_paragraph(); add_runs(p, text, bold=True, size=12 if level == 1 else 12)
    if level == 2:
        for r in p.runs:
            r.italic = True
    set_spacing(p, 1.5, 6, 12 if level == 1 else 6)
    p.paragraph_format.keep_with_next = True
    return p


def body_par(d, text, indent=True):
    p = d.add_paragraph(); add_runs(p, text); set_spacing(p)
    p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    if indent:
        p.paragraph_format.first_line_indent = Inches(0.3)
    return p


_OMML_CACHE = {}


def latex_to_omml(latex):
    """Convert one LaTeX display equation to an OMML <m:oMath> element using pandoc."""
    import copy, subprocess, tempfile, zipfile
    from lxml import etree
    if latex in _OMML_CACHE:
        return copy.deepcopy(_OMML_CACHE[latex])
    with tempfile.TemporaryDirectory() as td:
        src, out = os.path.join(td, 'eq.md'), os.path.join(td, 'eq.docx')
        open(src, 'w', encoding='utf-8').write('$$' + latex + '$$\n')
        subprocess.run(['pandoc', src, '-o', out], check=True)
        xml = zipfile.ZipFile(out).read('word/document.xml')
    root = etree.fromstring(xml)
    M = '{http://schemas.openxmlformats.org/officeDocument/2006/math}'
    om = root.find('.//' + M + 'oMath')
    assert om is not None, 'pandoc produced no OMML for: ' + latex
    _OMML_CACHE[latex] = om
    return copy.deepcopy(om)


def equation_omml(d, text):
    eq, num = [s.strip() for s in text[len('$$latex'):].rsplit('|', 1)]
    p = d.add_paragraph(); set_spacing(p, 1.5, 6, 6)
    ts = p.paragraph_format.tab_stops
    ts.add_tab_stop(Inches(3.25), WD_TAB_ALIGNMENT.CENTER); ts.add_tab_stop(Inches(6.5), WD_TAB_ALIGNMENT.RIGHT)
    p.add_run('\t')
    p._p.append(latex_to_omml(eq))
    p.add_run('\t' + num)
    return p


def equation(d, text):
    eq, num = [s.strip() for s in text[2:].split('|')]
    p = d.add_paragraph(); set_spacing(p, 1.5, 6, 6)
    ts = p.paragraph_format.tab_stops
    ts.add_tab_stop(Inches(3.25), WD_TAB_ALIGNMENT.CENTER); ts.add_tab_stop(Inches(6.5), WD_TAB_ALIGNMENT.RIGHT)
    p.add_run('\t'); add_runs(p, eq); p.add_run('\t' + num)
    return p


def write_body(d, text, inline=None):
    for b in blocks(text):
        if b.startswith('## '):
            heading(d, b[3:], 2)
        elif b.startswith('# '):
            heading(d, b[2:], 1)
        elif b.startswith('$$latex'):
            equation_omml(d, b)
        elif b.startswith('$$'):
            equation(d, b)
        else:
            body_par(d, b)
            # Reading copy only: place each exhibit after the paragraph that first cites it.
            for ex in list(inline or []):
                lab = ex['args']['caption'].split('|')[0].strip()
                if re.search(r'\b' + re.escape(lab) + r'(?!\d)', b):
                    n0 = len(d.paragraphs)
                    (table_exhibit if ex['kind'] == 'table' else figure_exhibit)(d, **ex['args'])
                    d.paragraphs[n0].paragraph_format.page_break_before = True   # caption starts a new page
                    inline.remove(ex)


def page_break(d):
    d.add_paragraph().add_run().add_break(WD_BREAK.PAGE)


def set_cell(cell, text, bold=False, align=None, size=10):
    cell.text = ''
    p = cell.paragraphs[0]; add_runs(p, text, bold=bold, size=size)
    p.paragraph_format.space_after = Pt(0); p.paragraph_format.line_spacing = 1.0
    if align:
        p.alignment = align


def border(cell, sides):
    tcPr = cell._tc.get_or_add_tcPr()
    b = tcPr.find(qn('w:tcBorders'))
    if b is None:
        b = OxmlElement('w:tcBorders'); tcPr.append(b)
    for side in sides:
        e = OxmlElement('w:' + side); e.set(qn('w:val'), 'single'); e.set(qn('w:sz'), '6'); e.set(qn('w:color'), '000000')
        b.append(e)


def table_exhibit(d, caption, csvfile, note, source, widths=None, size=9):
    rows = list(csv.reader(open(os.path.join(OUTR, csvfile), encoding='utf-8')))
    p = d.add_paragraph(); add_runs(p, caption.split('|')[0].strip(), bold=True); p.add_run(' ')
    add_runs(p, caption.split('|')[1].strip()); set_spacing(p, 1.0, 6)
    t = d.add_table(rows=len(rows), cols=len(rows[0])); t.alignment = WD_TABLE_ALIGNMENT.CENTER
    t.autofit = False
    mar = OxmlElement('w:tblCellMar')   # cell padding for readable row and column spacing
    for side, w in (('top', 40), ('bottom', 40), ('left', 85), ('right', 85)):
        e = OxmlElement('w:' + side); e.set(qn('w:w'), str(w)); e.set(qn('w:type'), 'dxa'); mar.append(e)
    t._tbl.tblPr.append(mar)
    for i, row in enumerate(rows):
        for j, v in enumerate(row):
            c = t.cell(i, j)
            set_cell(c, v, bold=(i == 0), align=None if j == 0 else WD_ALIGN_PARAGRAPH.CENTER, size=size)
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
        tblPr = t._tbl.tblPr
        lay = OxmlElement('w:tblLayout'); lay.set(qn('w:type'), 'fixed'); tblPr.append(lay)
    for txt in (note, 'Source: ' + source):
        q = d.add_paragraph(); add_runs(q, txt, size=10); set_spacing(q, 1.0, 2)
    page_break(d)


def figure_exhibit(d, caption, png, note, source):
    p = d.add_paragraph(); add_runs(p, caption.split('|')[0].strip(), bold=True); p.add_run(' ')
    add_runs(p, caption.split('|')[1].strip()); set_spacing(p, 1.0, 6)
    d.add_picture(os.path.join(OUTR, 'figures', png), width=Inches(6.3))
    d.paragraphs[-1].alignment = WD_ALIGN_PARAGRAPH.CENTER
    for txt in (note, 'Source: ' + source):
        q = d.add_paragraph(); add_runs(q, txt, size=10); set_spacing(q, 1.0, 2)
    page_break(d)


def build(anonymized, out, meta, secs, exhibits, inline=False):
    d = base_doc()
    p = d.add_paragraph(); add_runs(p, secs['title'], bold=True, size=14); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    set_spacing(p, 1.5, 12)
    if not anonymized:
        for line in blocks(meta['authors']):
            q = d.add_paragraph(); add_runs(q, line); q.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(q, 1.0, 4)
    q = d.add_paragraph(); add_runs(q, 'Running title: ' + secs['running_title']); set_spacing(q, 1.0, 12)
    q.alignment = WD_ALIGN_PARAGRAPH.CENTER
    heading(d, 'Abstract', 1); body_par(d, secs['abstract'], indent=False)
    q = d.add_paragraph(); add_runs(q, '*Keywords:* ' + secs['keywords']); set_spacing(q)
    q = d.add_paragraph(); add_runs(q, '*JEL classification:* ' + secs['jel']); set_spacing(q)
    if not anonymized:
        for b in blocks(meta['statements']):
            if b.startswith('## '):
                heading(d, b[3:], 2)
            else:
                body_par(d, b, indent=False)
    page_break(d)
    body = secs['body'].replace('[[COMPANION]]', meta['companion_blind' if anonymized else 'companion_named'])
    assert '[[' not in body, 'unresolved anchor in body'
    left = list(exhibits) if inline else None
    write_body(d, body, left)
    if inline:
        assert not left, 'exhibit not cited in body: ' + str([e['args']['caption'] for e in left])
    heading(d, 'References', 1)
    for b in blocks(secs['references']):
        p = d.add_paragraph(); add_runs(p, b); set_spacing(p, 1.5, 4)
        p.paragraph_format.left_indent = Inches(0.3); p.paragraph_format.first_line_indent = Inches(-0.3)
    if not inline:
        page_break(d)
        for ex in exhibits:
            (table_exhibit if ex['kind'] == 'table' else figure_exhibit)(d, **ex['args'])
    save_doc(d, out)


def build_ia(out, secs, exhibits_ia):
    d = base_doc()
    p = d.add_paragraph(); add_runs(p, 'Supplemental Appendix', bold=True, size=14); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p = d.add_paragraph(); add_runs(p, secs['title'], bold=True); p.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(p, 1.5, 12)
    body_par(d, secs['ia_intro'], indent=False)
    page_break(d)
    for ex in exhibits_ia:
        (table_exhibit if ex['kind'] == 'table' else figure_exhibit)(d, **ex['args'])
    save_doc(d, out)


def parse_exhibits(secs, key='exhibits'):
    exs = []
    for b in blocks(secs[key]):
        kv = dict(line.split(':=', 1) for line in b.splitlines())
        kv = {k.strip(): v.strip() for k, v in kv.items()}
        kind = kv.pop('kind')
        if 'widths' in kv:
            kv['widths'] = [float(x) for x in kv['widths'].split(',')]
        if 'size' in kv:
            kv['size'] = int(kv['size'])
        exs.append({'kind': kind, 'args': kv})
    return exs


if __name__ == '__main__':
    nums = load_numbers()
    secs = parse_sections(MS, nums)
    meta = parse_sections(META, nums)
    exhibits = parse_exhibits(secs)
    outdir = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'manuscript')
    os.makedirs(outdir, exist_ok=True)
    build(False, os.path.join(outdir, 'Manuscript_with_Author_Details.docx'), meta, secs, exhibits)
    build(True, os.path.join(outdir, 'Manuscript_Anonymized.docx'), meta, secs, exhibits)
    # Reading copy with exhibits placed in the text (JF:IP submission files keep tables and figures after the references).
    build(False, os.path.join(outdir, 'Reading_Copy_Exhibits_in_Text.docx'), meta, secs, exhibits, inline=True)
    build_ia(os.path.join(outdir, 'Supplemental_Appendix.docx'), secs, parse_exhibits(secs, 'exhibits_ia'))
    print('built', outdir)
