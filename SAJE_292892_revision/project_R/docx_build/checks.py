"""Automated manuscript checks (FORCE RULE H). Usage: python3 checks.py [docx_dir]
Checks run on the filled manuscript text (placeholders resolved from numbers.csv) and on the built DOCX files."""
import csv, os, re, sys, zipfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from build_manuscript import load_numbers, parse_sections, blocks, MS, META, OUTR, ROOT

LIMIT_NO_EXHIBITS = 7000
AUTHOR_TOKENS = ['Nguyen', 'Binh', 'Trung', 'Hanh', 'Diep', 'Ha Hong', 'apd.edu', 'neu.edu', '15233582', 'kontrungcany', 'Academy of Policy',
                 'National Economics University', 'School of Accounting and Auditing', '0009-0007-0042-2835',
                 '0009-0008-3307-6569', '0000-0003-3581-6571', '0009-0003-0967-7528']
ABBREV = {'ESG': 'environmental, social, and governance', 'LSEG': 'London Stock Exchange Group',
          'ATT': 'average treatment effects on the treated', 'MTB': 'market-to-book', 'MDE': 'minimum detectable effect'}
results = []


def check(name, ok, detail=''):
    results.append((name, 'PASS' if ok else 'FAIL', detail))


def words(text):
    text = re.sub(r'[*^~]', '', text)
    return len(re.findall(r"[A-Za-z0-9À-ɏ−][A-Za-z0-9À-ɏ'’.,−%()/-]*", text))


def main(docx_dir):
    nums = load_numbers()
    secs = parse_sections(MS, nums)
    meta = parse_sections(META, nums)
    body = secs['body'].replace('[[COMPANION]]', meta['companion_named'])
    exhibits = [b for b in blocks(secs['exhibits'])]
    n_ex = len(exhibits)

    # 1. Word count (JF:IP word-count PDF: main body + footnotes, excluding title, authors, abstract, references, exhibits)
    wc = words(re.sub(r'^\$\$.*$', '', body, flags=re.M)); limit = LIMIT_NO_EXHIBITS - 200 * n_ex
    # User instruction (2026-09-26, ledger D-13): full text of 8,500-10,000 words now; the user will cut to the JF:IP
    # limit later. The JF:IP main-text count is reported for information and flagged as WARN, not FAIL.
    import csv as _csv
    table_words = 0
    for b in exhibits:
        d = dict(l.split(':=', 1) for l in b.splitlines())
        if 'csvfile' in d:
            for row in _csv.reader(open(os.path.join(OUTR, d['csvfile']), encoding='utf-8')):
                table_words += sum(words(c) for c in row)
        table_words += words(d['caption']) + words(d['note']) + words('Source: ' + d['source'])
    full = words(secs['title']) + words(secs['abstract']) + words(secs['keywords']) + wc + \
        sum(words(r) for r in blocks(secs['references'])) + table_words
    # D-24 (2026-09-26): the user asked for a 20-30% cut; the JF:IP main-text limit is now a hard criterion.
    # D-46 (2026-10-12): JF:IP is no longer the target and the next journal is not chosen, so the JF:IP limit is reported
    # as information (WARN) instead of a pass/fail criterion; the venue limit is checked once the journal is chosen.
    print(f'WARN  main-text words (no venue limit set): {wc} words; JF:IP limit would be {limit} with {n_ex} exhibits; full text {full}')
    aw = words(secs['abstract']); check('abstract <= 100 words', aw <= 100, f'{aw} words')
    kw = [k.strip() for k in secs['keywords'].split(';')]
    check('keywords <= 7 and alphabetical', len(kw) <= 7 and kw == sorted(kw, key=str.lower), '; '.join(kw))
    check('running title < 40 characters', len(secs['running_title']) < 40, f"{len(secs['running_title'])} chars")
    check('exhibits <= 5', n_ex <= 5, f'{n_ex} exhibits')

    # 2. Placeholders / leftover drafting markers
    nonmath = re.sub(r'^\$\$latex.*$', '', body, flags=re.M)   # LaTeX braces are not placeholders
    left = re.findall(r'\{\{|\}\}|\[\[|RESULTS_|DISCUSSION_|LIMITATIONS_|CONCLUSION_|TODO|XXX', nonmath + secs['abstract'])
    check('no unresolved placeholders', not left, str(left[:5]))

    # 3. Exhibits cited in text, in order
    cites = [('Table', int(m)) for m in re.findall(r'Table (\d)', body)] + [('Figure', int(m)) for m in re.findall(r'Fig\. (\d)', body)]
    first = {}
    for m in re.finditer(r'(Table|Fig\.) (\d)', body):
        first.setdefault(('Figure' if m.group(1) == 'Fig.' else 'Table', int(m.group(2))), m.start())
    caps = []
    for b in exhibits:
        cap = [l for l in b.splitlines() if l.startswith('caption:=')][0][9:]
        lab = cap.split('|')[0]
        kind, n = ('Figure', int(lab.split()[-1].rstrip('.'))) if lab.startswith('Fig') else ('Table', int(lab.split()[-1]))
        caps.append((kind, n, cap))
    for kind, n, cap in caps:
        check(f'{kind} {n} cited in text', (kind, n) in first)
    order = sorted(first.items(), key=lambda x: x[1])
    tab_order = [k[1] for k, _ in order if k[0] == 'Table']
    check('tables first cited in numeric order', tab_order == sorted(tab_order), str(tab_order))

    check('figure mentions in text match caption label (Fig. n)', not re.search(r'\bFigure \d', body))
    # 4. Notes <= 2 sentences (user instruction 2026-09-26, ledger D-22), every exhibit has a Source line
    for b in exhibits:
        d = dict(l.split(':=', 1) for l in b.splitlines())
        note = re.sub(r'\b(Eqs?|Fig|Norm|diff)\.', r'\1', d['note']); ns = len(re.findall(r'[.!?](\s|$)', note))
        check(f"note <= 2 sentences: {d['caption'].split('|')[0]}", ns <= 2, f'{ns} sentences')
        check(f"source line: {d['caption'].split('|')[0]}", bool(d.get('source')))

    # 5. Caption ↔ content: header row of each table CSV must match the caption's subject
    expect = {1: ['Scored mean', 'Never-scored mean', 'Norm. diff.'], 2: ['ATT', 'Pre-trend p'], 3: ['Specification']}
    # Supplemental Appendix exhibits are cited as 'Table S1' etc. and are not counted toward the exhibit limit.
    for kind, n, cap in caps:
        if kind == 'Table':
            f = [l for l in [b for b in exhibits if f'Table {n}|' in b][0].splitlines() if l.startswith('csvfile:=')][0][9:]
            hdr = next(csv.reader(open(os.path.join(OUTR, f), encoding='utf-8')))
            check(f'Table {n} header matches caption design', all(h in hdr for h in expect[n]), '|'.join(hdr))

    # 6. Cross-references to sections exist
    heads = re.findall(r'^#+ (\d+(?:\.\d+)?)\.? ', body, flags=re.M)
    refs = re.findall(r'Section (\d+(?:\.\d+)?)', body)
    check('section cross-references exist', all(r in heads for r in refs), f'refs {sorted(set(refs))}; heads {heads}')
    eqs = re.findall(r'\| \((\d+)\)', body); eqrefs = re.findall(r'Eq(?:uation)?\.? \((\d+)\)', body)
    check('equation references exist', all(e in eqs for e in eqrefs), f'{eqrefs} vs {eqs}')

    # 7. Citations ↔ references
    refs_list = blocks(secs['references'])
    ref_keys = []
    for r in refs_list:
        auth, year = r.split(', 20')[0] if False else None, None
        m = re.match(r'(.+?)\.? \((\d{4})', r); ref_keys.append((m.group(1), m.group(2)))   # APA 7: Author. (Year).
    surnames = []
    for a, y in ref_keys:
        first_s = a.split(',')[0].split(' & ')[0].strip()
        surnames.append((first_s, y))
    text_all = body + ' ' + secs['abstract']
    for s, y in surnames:
        check(f'reference cited in text: {s} {y}', s in text_all and y in text_all)
    cited = re.findall(r"([A-Z][A-Za-zÀ-ž'\-]+)(?:,? (?:[A-Z][A-Za-zÀ-ž'\-]+,? )*(?:and [A-Z][A-Za-zÀ-ž'\-]+)?)? \((\d{4})\)|\(([A-Z][^()]*?), (\d{4})\)", body)
    in_text = set()
    for m in re.finditer(r"([A-Z][A-Za-zÀ-ž'\-]+)[^()]{0,60}?,? (?:\(|)(\d{4})\)", body):
        in_text.add((m.group(1), m.group(2)))
    ref_first = {s for s, _ in surnames}
    not_authors = {'FTSE', 'LSEG', 'ESG', 'MTB', 'ATT', 'Table', 'Figure', 'Fig', 'Section', 'Eq', 'The', 'In', 'We', 'Inference', 'Following', 'Because', 'This', 'As', 'If', 'A', 'Singapore', 'Heeb', 'Kölbel'}
    orphan = [(a, y) for a, y in in_text if a not in not_authors and y.startswith(('19', '20')) and a not in ref_first and not any(a in r for r in refs_list)]
    check('no in-text citation missing from references', not orphan, str(orphan[:6]))
    # APA 7 in-text form: three or more authors -> "et al."; "&" inside parentheses, "and" in narrative citations
    three = re.findall(r"[A-Z][\w'’-]+, [A-Z][\w'’-]+,? (?:and|&) [A-Z][\w'’-]+,? \(?\d{4}", body)
    check('APA: no three-author lists in citations', not three, str(three[:4]))
    amp = [g for g in re.findall(r'\(([^()]*\d{4}[^()]*)\)', body) if re.search(r"[A-Z][\w'’-]+ and [A-Z][\w'’-]+, \d{4}", g)]
    check('APA: "&" in parenthetical citations', not amp, str(amp[:4]))
    bad_j = [r[:40] for r in blocks(secs['references']) if 'doi.org' in r and not re.search(r'[.?] \*[^*]+\*, \*\d+\*', r)]
    check('APA: journal name and volume italic in every journal reference', not bad_j, str(bad_j[:4]))
    hyp = re.findall(r'^H\d', body, flags=re.M)
    check('hypothesis labels use subscripts (H~1~)', not hyp, str(hyp))
    verified = open(os.path.join(ROOT, 'notes', '05_references_verified.md'), encoding='utf-8').read()
    for r in refs_list:
        doi = re.search(r'doi\.org/(\S+)', r)
        if doi:
            check(f'DOI verified in notes/05: {doi.group(1)}', doi.group(1) in verified)

    # 8. Abbreviations defined at first use in body and in abstract
    for ab, long in ABBREV.items():
        pos_b = re.search(r'\b%s\b' % ab, body)
        if pos_b:
            check(f'abbrev {ab} defined in body before use', f'({ab})' in body[:pos_b.start() + len(ab) + 2] or long.lower() in body[:pos_b.start()].lower())
        pos_a = re.search(r'\b%s\b' % ab, secs['abstract'])
        if pos_a:
            check(f'abbrev {ab} defined in abstract', f'({ab})' in secs['abstract'])

    # 9. Style: no em dash, no banned words, no second person
    full = body + secs['abstract']
    check('no em dash', '—' not in full)
    ex_notes = ' '.join(l for l in (secs['exhibits'] + secs['exhibits_ia']).splitlines() if l.startswith('note:='))
    ital = re.findall(r'(?<![\\*])\*(?!\*)[^*\n]+?\*', re.sub(r'^\$\$.*$', '', body + secs['abstract'] + ex_notes, flags=re.M).replace('\\*', ''))
    check('no italics in abstract, body, and exhibit notes (user instruction D-25)', not ital, str(ital[:6]))
    banned = re.findall(r'\b(genuinely|strictly|markedly|fundamentally|crucial|critical|robustly|delve|guarantee|prove[sd]?|verif(?:y|ies|ied)|ensure[sd]?|Firstly|Secondly|you|your)\b', full, flags=re.I)
    check('no banned words / second person', not banned, str(sorted(set(banned))))

    # 10. Every number in text equals a numbers.csv value or a structural integer
    vals = set(nums.values())
    txt = re.sub(r'^#+ \d+(\.\d+)?\.? ', '', body, flags=re.M)
    txt = re.sub(r'Section \d+(\.\d+)?', '', txt)
    constants = {'2.8', '0.975', '0.80', '0.25', '0.5', '4.86', '−2.37'}   # −2.37: Berg, Heeb, et al. (2022) one-year return after MSCI downgrades   # 4.86: Demiroglu and Ryngaert (2010) announcement return   # MDE multiplier, z quantiles, M-bar values (Eqs. 7, 10)   # 2.8 standard errors = MDE multiplier at 80% power, 5% two-sided (stated in Section 2.3)
    tokens = re.findall(r'(?<![\w.])[−-]?\d[\d,]*\.\d+', txt + secs['abstract'])
    bad = [t for t in tokens if t not in vals and t not in constants]
    check('every decimal number in text comes from numbers.csv', not bad, str(bad[:8]))

    # 11. DOCX files: anonymization and validity
    if docx_dir:
        anon = os.path.join(docx_dir, 'Manuscript_Anonymized.docx')
        if not os.path.exists(anon):
            anon = os.path.join(docx_dir, '02_Manuscript_Anonymized.docx')
        if os.path.exists(anon):
            z = zipfile.ZipFile(anon); names = z.namelist()
            alltxt = ''.join(z.read(n).decode('utf-8', 'ignore') for n in names if n.endswith('.xml'))
            hits = [t for t in AUTHOR_TOKENS if t in alltxt]
            check('anonymized: no author identifiers in any XML part', not hits, str(hits))
            check('anonymized: no word/people.xml', 'word/people.xml' not in names)
            core = z.read('docProps/core.xml').decode()
            check('anonymized: empty creator/lastModifiedBy', not re.search(r'<dc:creator>[^<]+<', core) and not re.search(r'<cp:lastModifiedBy>[^<]+<', core))
            check('anonymized: no author contributions section', 'Author contributions' not in alltxt)
            check('no companion-study passage (user instruction D-27)', 'companion' not in alltxt.lower())
    return results


if __name__ == '__main__':
    res = main(sys.argv[1] if len(sys.argv) > 1 else None)
    width = max(len(r[0]) for r in res)
    for n, s, d in res:
        print(f'{s:4}  {n:{width}}  {d}')
    fails = [r for r in res if r[1] == 'FAIL']
    print(f'\n{len(res) - len(fails)}/{len(res)} PASS')
    sys.exit(1 if fails else 0)
