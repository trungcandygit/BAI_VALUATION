"""Build submission/JFIP_submission/ for Journal of Finance: Insights and Perspectives.

Files: 00_CHECKLIST_NopBai.md, 01_Title_Page.docx, 02_Manuscript_Anonymized.docx, 03_Figures/,
04_Declaration_of_Competing_Interest.docx, 05_Replication_Package/ (+ .zip), 06_Cover_Letter.docx,
07_Manuscript_with_Author_Details.docx, 08_Supplemental_Appendix.docx, 09_Word_Count.docx/.pdf.
Highlights are not required by JF:IP and are not produced."""
import os, re, shutil, subprocess, sys, zipfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_manuscript import (load_numbers, parse_sections, parse_exhibits, blocks, base_doc, add_runs, set_spacing,
                              heading, body_par, write_body, build, build_ia, fill, save_doc, MS, META, OUTR, ROOT)
from docx.enum.text import WD_ALIGN_PARAGRAPH

SUB = os.path.join(ROOT, 'submission', 'JFIP_submission')
PR = os.path.join(ROOT, 'project_R')
AUTHOR_TOKENS = ['Nguyen', 'Binh', 'Trung', 'Hanh', 'Diep', 'Ha Hong', 'apd.edu', 'neu.edu', '15233582', 'kontrungcany', 'Academy of Policy',
                 'National Economics University', 'School of Accounting and Auditing', '0009-0007-0042-2835',
                 '0009-0008-3307-6569', '0000-0003-3581-6571', '0009-0003-0967-7528']


def words(text):
    text = re.sub(r'[*^~]', '', text)
    return len(re.findall(r"[A-Za-z0-9À-ɏ−][A-Za-z0-9À-ɏ'’.,−%()/-]*", text))


def pdf(docx_path):
    subprocess.run(['soffice', '--headless', '--convert-to', 'pdf', '--outdir', os.path.dirname(docx_path), docx_path],
                   env=dict(os.environ, HOME='/tmp/lohome'), check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    assert os.path.exists(docx_path[:-5] + '.pdf'), 'PDF export failed (is libreoffice-writer installed?)'


def main():
    nums = load_numbers(); secs = parse_sections(MS, nums); meta = parse_sections(META, nums)
    exhibits = parse_exhibits(secs); exhibits_ia = parse_exhibits(secs, 'exhibits_ia')
    if os.path.isdir(SUB):
        shutil.rmtree(SUB)
    os.makedirs(SUB)

    # 02 / 07 manuscripts, 08 Supplemental Appendix
    build(True, os.path.join(SUB, '02_Manuscript_Anonymized.docx'), meta, secs, exhibits)
    build(False, os.path.join(SUB, '07_Manuscript_with_Author_Details.docx'), meta, secs, exhibits)
    build_ia(os.path.join(SUB, '08_Supplemental_Appendix.docx'), secs, exhibits_ia)

    # 01 Title page
    d = base_doc()
    p = d.add_paragraph(); add_runs(p, secs['title'], bold=True, size=14); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    for line in blocks(meta['authors']):
        q = d.add_paragraph(); add_runs(q, line); q.alignment = WD_ALIGN_PARAGRAPH.CENTER; set_spacing(q, 1.0, 4)
    q = d.add_paragraph(); add_runs(q, 'Running title: ' + secs['running_title']); set_spacing(q)
    q = d.add_paragraph(); add_runs(q, '*Keywords:* ' + secs['keywords']); set_spacing(q)
    q = d.add_paragraph(); add_runs(q, '*JEL classification:* ' + secs['jel']); set_spacing(q)
    for b in blocks(meta['statements']):
        heading(d, b[3:], 2) if b.startswith('## ') else body_par(d, b, indent=False)
    save_doc(d, os.path.join(SUB, '01_Title_Page.docx'))

    # 04 Competing interest declaration (one disclosure per author, as JF:IP requires)
    d = base_doc()
    heading(d, 'Declaration of Competing Interest', 1)
    body_par(d, 'Manuscript: ' + secs['title'], indent=False)
    coi = [b for b in blocks(meta['statements']) if b.startswith('Nguyen Thanh Binh has')][0]
    for s in re.split(r'(?<=\.) ', coi):
        body_par(d, s, indent=False)
    body_par(d, 'None of the authors is an Editor or Editorial Board member of the Journal of Finance: Insights and Perspectives.', indent=False)
    save_doc(d, os.path.join(SUB, '04_Declaration_of_Competing_Interest.docx'))

    # 09 Word count file: main body only (no title, authors, abstract, acknowledgements, references, exhibits)
    body = secs['body'].replace('[[COMPANION]]', meta['companion_named'])
    d = base_doc(); write_body(d, body)
    wc_path = os.path.join(SUB, '09_Word_Count.docx'); save_doc(d, wc_path); pdf(wc_path)
    wc = words(re.sub(r'^\$\$.*$', '', body, flags=re.M)); limit = 7000 - 200 * len(exhibits)

    # 06 Cover letter
    d = base_doc()
    for line in ['Nguyen Van Trung (corresponding author)', 'Academy of Policy and Development, Hanoi, Vietnam',
                 'kontrungcany@gmail.com', '', 'The Editors', 'Journal of Finance: Insights and Perspectives', '']:
        q = d.add_paragraph(); add_runs(q, line); set_spacing(q, 1.0, 0)
    for para in blocks(open(os.path.join(ROOT, 'manuscript', 'cover_letter.md'), encoding='utf-8').read()):
        para = para.replace('{{WORDCOUNT}}', f'{wc:,}').replace('{{LIMIT}}', f'{limit:,}') \
            .replace('{{NEX}}', str(len(exhibits))).replace('{{TITLE}}', secs['title'])
        body_par(d, fill(para, nums), indent=False)
    save_doc(d, os.path.join(SUB, '06_Cover_Letter.docx'))

    # 03 Figures
    fd = os.path.join(SUB, '03_Figures'); os.makedirs(fd)
    for f in ('Fig1.eps', 'Fig1.png', 'FigIA1.eps', 'FigIA1.png'):
        shutil.copy(os.path.join(OUTR, 'figures', f), fd)

    # 05 Replication package (code + outputs; licensed raw data excluded)
    rp = os.path.join(SUB, '05_Replication_Package'); os.makedirs(rp)
    for sub in ('R', 'validation'):
        shutil.copytree(os.path.join(PR, sub), os.path.join(rp, sub),
                        ignore=shutil.ignore_patterns('original_ESG2_text.txt', 'new_manuscript_sections.tsv'))
    shutil.copy(os.path.join(PR, 'run_all.R'), rp)
    shutil.copytree(OUTR, os.path.join(rp, 'outputs'), ignore=shutil.ignore_patterns('overlap'))
    shutil.copy(os.path.join(ROOT, 'notes', '02_analysis_plan.md'), os.path.join(rp, 'pre_analysis_plan.md'))
    shutil.copy(os.path.join(ROOT, 'manuscript', 'replication_README.md'), os.path.join(rp, 'README.md'))
    shutil.make_archive(os.path.join(SUB, '05_Replication_Package'), 'zip', rp)

    # 00 Checklist (Vietnamese)
    import checks as ck
    ck.results.clear(); res = ck.main(SUB)
    ck_txt = f"{sum(r[1] == 'PASS' for r in res)}/{len(res)} PASS"
    t = open(os.path.join(ROOT, 'manuscript', 'checklist_template.md'), encoding='utf-8').read()
    for k, v in {'{{TITLE}}': secs['title'], '{{WORDCOUNT}}': f'{wc:,}', '{{LIMIT}}': f'{limit:,}',
                 '{{NEX}}': str(len(exhibits)), '{{CHECKS}}': ck_txt, '{{KEYWORDS}}': secs['keywords']}.items():
        t = t.replace(k, v)
    open(os.path.join(SUB, '00_CHECKLIST_NopBai.md'), 'w', encoding='utf-8').write(t)

    # Anonymization checks on 02
    z = zipfile.ZipFile(os.path.join(SUB, '02_Manuscript_Anonymized.docx'))
    xml = ''.join(z.read(n).decode('utf-8', 'ignore') for n in z.namelist() if n.endswith('.xml'))
    hits = [t for t in AUTHOR_TOKENS if t in xml]
    assert not hits, ('identifying text in blinded manuscript', hits)
    assert 'word/people.xml' not in z.namelist()
    assert 'Author contributions' not in xml
    print(f'built {SUB}; word count {wc} (limit {limit}); anonymized manuscript clean')


if __name__ == '__main__':
    main()
