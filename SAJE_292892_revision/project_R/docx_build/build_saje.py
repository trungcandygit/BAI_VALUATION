"""Build the Southeast Asian Journal of Economics (SAJE) revision package for manuscript 292892.

Sources: manuscript/manuscript_saje.md (text, {{key}} numbers, exhibits), project_R/outputs/numbers.csv and
numbers_saje.csv (numbers), project_R/outputs/*_formatted.csv (tables), outputs/figures (figures).
Markup in addition to build_manuscript.py: {+ ... +} marks text that is new or changed in this revision. The marked
manuscript prints it in blue (editor's instruction), the clean manuscript in black.
SAJE guidelines: blinded article, separate title page, abstract of 150 words or less, tables and figures within the
text at the appropriate points.
Usage: python3 build_saje.py OUTDIR
"""
import csv, os, re, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_manuscript import (blocks, base_doc, set_spacing, latex_to_omml, save_doc, border, OUTR, ROOT)
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_TAB_ALIGNMENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor

MS = os.path.join(ROOT, 'manuscript', 'manuscript_saje.md')
BLUE = RGBColor(0, 0, 0xFF)
TOKEN = re.compile(r'(\*[^*]+\*|\^[^^]+\^|~[^~]+~)')
STAR = '∗'


def load_numbers():
    nums = {}
    for f in ('numbers.csv', 'numbers_saje.csv'):
        with open(os.path.join(OUTR, f), encoding='utf-8') as fh:
            for r in csv.DictReader(fh):
                assert r['key'] not in nums or nums[r['key']] == r['value'], 'duplicate key ' + r['key']
                nums[r['key']] = r['value']
    return nums


def fill(text, nums):
    def rep(m):
        if m.group(1) not in nums:
            sys.exit('Unknown placeholder {{%s}}' % m.group(1))
        return nums[m.group(1)]
    return re.sub(r'\{\{([A-Za-z0-9_]+)\}\}', rep, text)


def parse(path, nums):
    secs, cur = {}, None
    for line in open(path, encoding='utf-8').read().splitlines():
        if line.startswith('%'):
            continue
        if line.startswith('@@ '):
            cur = line[3:].strip(); secs[cur] = []; continue
        if cur is not None:
            secs[cur].append(fill(line, nums))
    return {k: '\n'.join(v).strip() for k, v in secs.items()}


def strip_marks(t):
    return t.replace('{+', '').replace('+}', '')


class Writer:
    """Adds runs with italics, super- and subscripts, and blue for {+ ... +} when marked=True."""

    def __init__(self, marked):
        self.marked = marked

    def runs(self, p, text, bold=False, size=None, italic=False, force_blue=False):
        text = text.replace('\\*', STAR).replace('\n', ' ')
        blue = False
        for seg in re.split(r'(\{\+|\+\})', text):
            if seg == '{+':
                blue = True; continue
            if seg == '+}':
                blue = False; continue
            for part in TOKEN.split(seg):
                if not part:
                    continue
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
                if italic:
                    r.italic = True
                if size:
                    r.font.size = Pt(size)
                if self.marked and (blue or force_blue):
                    r.font.color.rgb = BLUE
        return p


def heading(d, w, text, level):
    p = d.add_paragraph(); w.runs(p, text, bold=True, size=13 if level == 1 else 12)
    set_spacing(p, 1.5, 6, 18 if level == 1 else 8)
    p.paragraph_format.keep_with_next = True
    return p


def body_par(d, w, text, indent=True):
    p = d.add_paragraph(); w.runs(p, text); set_spacing(p, 1.5, 6)
    p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    if indent:
        p.paragraph_format.first_line_indent = Inches(0.5)
    return p


def equation(d, w, text):
    blue = text.startswith('{+')
    text = strip_marks(text)
    eq, num = [s.strip() for s in text[len('$$latex'):].rsplit('|', 1)]
    p = d.add_paragraph(); set_spacing(p, 1.5, 6, 6)
    ts = p.paragraph_format.tab_stops
    ts.add_tab_stop(Inches(3.25), WD_TAB_ALIGNMENT.CENTER); ts.add_tab_stop(Inches(6.5), WD_TAB_ALIGNMENT.RIGHT)
    p.add_run('\t'); p._p.append(latex_to_omml(eq)); r = p.add_run('\t' + num)
    if blue and w.marked:
        r.font.color.rgb = BLUE
    return p


def set_cell(w, cell, text, bold=False, align=None, size=10, blue=False):
    cell.text = ''
    p = cell.paragraphs[0]; w.runs(p, text, bold=bold, size=size, force_blue=blue)
    p.paragraph_format.space_after = Pt(0); p.paragraph_format.line_spacing = 1.0
    if align:
        p.alignment = align


def table_exhibit(d, w, caption, csvfile, note, source, widths=None, size=10, blue=False):
    rows = list(csv.reader(open(os.path.join(OUTR, csvfile), encoding='utf-8')))
    lab, title = [s.strip() for s in caption.split('|')]
    p = d.add_paragraph(); w.runs(p, lab + '. ' + title, force_blue=blue, size=11)
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(p, 1.0, 6, 12); p.paragraph_format.keep_with_next = True
    t = d.add_table(rows=len(rows), cols=len(rows[0])); t.alignment = WD_TABLE_ALIGNMENT.CENTER; t.autofit = False
    mar = OxmlElement('w:tblCellMar')
    for side, v in (('top', 30), ('bottom', 30), ('left', 70), ('right', 70)):
        e = OxmlElement('w:' + side); e.set(qn('w:w'), str(v)); e.set(qn('w:type'), 'dxa'); mar.append(e)
    t._tbl.tblPr.append(mar)
    for i, row in enumerate(rows):
        for j, v in enumerate(row):
            c = t.cell(i, j)
            set_cell(w, c, v, bold=(i == 0), align=None if j == 0 else WD_ALIGN_PARAGRAPH.CENTER, size=size, blue=blue)
            if i == 0:
                border(c, ['top', 'bottom'])
            if i == len(rows) - 1:
                border(c, ['bottom'])
    if widths:
        for j, wd in enumerate(widths):
            for i in range(len(rows)):
                t.cell(i, j).width = Inches(wd)
        for gc, wd in zip(t._tbl.tblGrid.findall(qn('w:gridCol')), widths):
            gc.set(qn('w:w'), str(int(wd * 1440)))
        lay = OxmlElement('w:tblLayout'); lay.set(qn('w:type'), 'fixed'); t._tbl.tblPr.append(lay)
    q = d.add_paragraph(); w.runs(q, 'Note: ' + note, size=9, force_blue=blue); set_spacing(q, 1.0, 2, 4)
    q.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    q = d.add_paragraph(); w.runs(q, 'Source: ' + source, size=9, force_blue=blue); set_spacing(q, 1.0, 12)


def figure_exhibit(d, w, caption, png, note, source, blue=False, width=6.0):
    lab, title = [s.strip() for s in caption.split('|')]
    p = d.add_paragraph(); w.runs(p, lab + '. ' + title, force_blue=blue, size=11)
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(p, 1.0, 6, 12); p.paragraph_format.keep_with_next = True
    d.add_picture(os.path.join(OUTR, 'figures', png), width=Inches(float(width)))
    d.paragraphs[-1].alignment = WD_ALIGN_PARAGRAPH.CENTER; d.paragraphs[-1].paragraph_format.keep_with_next = True
    q = d.add_paragraph(); w.runs(q, 'Note: ' + note, size=9, force_blue=blue); set_spacing(q, 1.0, 2, 4)
    q.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    q = d.add_paragraph(); w.runs(q, 'Source: ' + source, size=9, force_blue=blue); set_spacing(q, 1.0, 12)


def parse_exhibits(text):
    exs = []
    for b in blocks(text):
        kv = dict(line.split(':=', 1) for line in b.splitlines())
        kv = {k.strip(): v.strip() for k, v in kv.items()}
        kind = kv.pop('kind')
        if 'widths' in kv:
            kv['widths'] = [float(x) for x in kv['widths'].split(',')]
        if 'size' in kv:
            kv['size'] = int(kv['size'])
        kv['blue'] = kv.get('blue', '0') == '1'
        exs.append({'kind': kind, 'args': kv})
    return exs


def place(d, w, ex):
    (table_exhibit if ex['kind'] == 'table' else figure_exhibit)(d, w, **ex['args'])


def write_body(d, w, text, exhibits):
    left = list(exhibits)
    for b in blocks(text):
        plain = strip_marks(b)
        if plain.startswith('## '):
            heading(d, w, b.replace('## ', '', 1), 2)
        elif plain.startswith('# '):
            heading(d, w, b.replace('# ', '', 1), 1)
        elif plain.startswith('$$latex'):
            equation(d, w, b)
        else:
            body_par(d, w, b)
            for ex in list(left):   # SAJE: each exhibit after the paragraph that first cites it
                lab = ex['args']['caption'].split('|')[0].strip()
                if re.search(r'\b' + re.escape(lab) + r'(?![\dA-Za-z])', plain):
                    place(d, w, ex); left.remove(ex)
    assert not left, 'exhibit never cited: ' + str([e['args']['caption'] for e in left])


def references(d, w, text):
    heading(d, w, 'References', 1)
    for b in blocks(text):
        p = d.add_paragraph(); w.runs(p, b); set_spacing(p, 1.5, 4)
        p.paragraph_format.left_indent = Inches(0.5); p.paragraph_format.first_line_indent = Inches(-0.5)


def words(t):
    t = strip_marks(t)
    t = re.sub(r'\$\$latex.*', '', t)
    return len(re.findall(r'\S+', re.sub(r'^#+ .*$', '', t, flags=re.M)))


def manuscript(out, secs, marked):
    w = Writer(marked); d = base_doc()
    for s in d.sections:
        s.top_margin = s.bottom_margin = Inches(1)
    p = d.add_paragraph(); w.runs(p, secs['title'], bold=True, size=14); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    set_spacing(p, 1.5, 18)
    p = d.add_paragraph(); w.runs(p, 'Abstract', bold=True, size=13); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    set_spacing(p, 1.5, 6)
    body_par(d, w, secs['abstract'], indent=True)
    p = d.add_paragraph(); w.runs(p, 'Keywords:', bold=True); w.runs(p, ' ' + secs['keywords'])
    set_spacing(p, 1.5, 6); p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    p = d.add_paragraph(); w.runs(p, 'JEL Classification:', bold=True); w.runs(p, ' ' + secs['jel']); set_spacing(p, 1.5, 6)
    d.add_page_break()
    write_body(d, w, secs['body'], parse_exhibits(secs['exhibits']))
    heading(d, w, secs['ack_head'], 1); body_par(d, w, secs['ack_blind'], indent=False)
    references(d, w, secs['references'])
    save_doc(d, out)


def supplement(out, secs, marked):
    w = Writer(marked); d = base_doc()
    for s in d.sections:
        s.top_margin = s.bottom_margin = Inches(1)
    p = d.add_paragraph(); w.runs(p, 'Supplementary material', bold=True, size=14); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p = d.add_paragraph(); w.runs(p, secs['title'], bold=True); p.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(p, 1.5, 12)
    body_par(d, w, secs['supp_intro'], indent=False)
    write_body(d, w, secs['supp_body'], [])
    for ex in parse_exhibits(secs['exhibits_supp']):   # all exhibits after Appendix B, in numbered order
        place(d, w, ex)
    save_doc(d, out)


def title_page(out, secs):
    """Title page through pandoc, which writes a real Word footnote for the acknowledgement."""
    md = os.path.join(os.path.dirname(out), '_title_page.md')
    open(md, 'w', encoding='utf-8').write(secs['title_page'] + '\n')
    ref = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'saje_reference.docx')
    subprocess.run(['pandoc', md, '-f', 'markdown', '-o', out, '--reference-doc', ref], check=True)
    os.remove(md)


def reference_doc():
    """Pandoc reference document with Times New Roman 12 pt and 1.5 line spacing."""
    from docx import Document
    ref = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'saje_reference.docx')
    data = subprocess.run(['pandoc', '-o', '-', '--print-default-data-file', 'reference.docx'], check=True,
                          capture_output=True).stdout
    open(ref, 'wb').write(data)
    d = Document(ref)
    for st in d.styles:
        try:
            if st.font is not None:
                st.font.name = 'Times New Roman'
                st.element.get_or_add_rPr().get_or_add_rFonts().set(qn('w:eastAsia'), 'Times New Roman')
                if st.name in ('Normal', 'Body Text', 'First Paragraph', 'Compact'):
                    st.font.size = Pt(12)
                if st.name.startswith('Heading') or st.name == 'Title':
                    st.font.color.rgb = RGBColor(0, 0, 0)
        except (AttributeError, ValueError):
            pass
    for name in ('Body Text', 'First Paragraph'):
        d.styles[name].paragraph_format.line_spacing = 1.5
    d.save(ref)
    return ref


LETTER = os.path.join(ROOT, 'manuscript', 'response_letter_saje.md')


def letter(out, nums, secs):
    """Response letter through pandoc; numbers from the same files, abstract text and word count from the manuscript."""
    n2 = dict(nums)
    n2['s_abstract_text'] = strip_marks(secs['abstract']); n2['s_abstract_words'] = str(words(secs['abstract']))
    body = parse(LETTER, n2)['letter']
    md = os.path.join(os.path.dirname(out), '_letter.md')
    open(md, 'w', encoding='utf-8').write(body + '\n')
    ref = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'saje_reference.docx')
    subprocess.run(['pandoc', md, '-f', 'markdown', '-o', out, '--reference-doc', ref], check=True)
    os.remove(md)
    return body


if __name__ == '__main__':
    outdir = sys.argv[1]
    os.makedirs(outdir, exist_ok=True)
    nums = load_numbers(); secs = parse(MS, nums)
    reference_doc()
    manuscript(os.path.join(outdir, '02_Manuscript_Revised_Marked_blue.docx'), secs, True)
    manuscript(os.path.join(outdir, '03_Manuscript_Revised_Clean.docx'), secs, False)
    supplement(os.path.join(outdir, '04_Supplementary_Material_Marked_blue.docx'), secs, True)
    supplement(os.path.join(outdir, '05_Supplementary_Material_Clean.docx'), secs, False)
    title_page(os.path.join(outdir, '01_Title_Page.docx'), secs)
    lt = letter(os.path.join(outdir, '06_Response_to_Editor_and_Reviewer.docx'), nums, secs)
    print('letter words:', len(re.findall(r'\S+', lt)))
    ab = words(secs['abstract']); body = words(secs['body'])
    print('abstract words:', ab, '| body words (excl. headings, equations):', body)
    assert ab <= 150, 'abstract over 150 words'
    for k in ('{{', '[[', 'AUTHOR_INPUT'):
        for s in ('body', 'abstract'):
            assert k not in secs[s], 'unresolved %s in %s' % (k, s)
