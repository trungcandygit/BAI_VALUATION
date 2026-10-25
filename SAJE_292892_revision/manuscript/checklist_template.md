# CHECKLIST NỘP BÀI — Journal of Finance: Insights and Perspectives (JF:IP)

Bài: "{{TITLE}}"
Hệ thống nộp: Wiley Research Exchange (JF:IP). Tác giả liên hệ: Nguyen Van Trung.

## 1. File trong thư mục này và cách upload

| File | Upload với loại file | Ghi chú |
|---|---|---|
| 01_Title_Page.docx | Title Page | Tên, đơn vị, email, ORCID, các mục khai báo, Author contributions (chỉ ở đây) |
| 02_Manuscript_Anonymized.docx | Main Document | Bản ẩn danh gửi phản biện. Mở bằng Word để kiểm tra công thức |
| 03_Figures/Fig1.eps | Figure | PNG 600 dpi chỉ để dự phòng. FigIA1 = Fig. S1 thuộc Supplemental Appendix |
| 04_Declaration_of_Competing_Interest.docx | Conflict of Interest / Supplementary | Mỗi tác giả một câu khai báo |
| 05_Replication_Package.zip | Supplementary Material | Code R, output, pre-analysis plan, README đối chiếu bảng với file output. Không chứa dữ liệu có bản quyền |
| 06_Cover_Letter.docx | Cover Letter | Dán số từ **{{WORDCOUNT}}** vào ô Cover letter trên hệ thống |
| 07_Manuscript_with_Author_Details.docx | KHÔNG upload lúc nộp | Dùng khi bài được chấp nhận |
| 08_Supplemental_Appendix.docx | Supplementary Material | Table S1–S6, Fig. S1 |
| 09_Word_Count.pdf (+ .docx) | Supplementary Material ("word count PDF") | Chỉ thân bài; tải PDF lên https://www.aeaweb.org/journals/word-count/ để lấy số chính thức |

Highlights: JF:IP không yêu cầu, nên không làm.

## 2. Thông số đã kiểm tra bằng script (checks.py: {{CHECKS}})

- [x] Thân bài {{WORDCOUNT}} từ ≤ giới hạn {{LIMIT}} (7.000 − 200 × {{NEX}} exhibit); abstract ≤ 100 từ; keywords ≤ 7, xếp chữ cái; có JEL.
- [x] Bảng, hình được nhắc trước khi xuất hiện; note ≤ 2 câu + dòng Source; mọi số khớp numbers.csv của R.
- [x] Tài liệu tham khảo APA 7: tên tạp chí và số tập in nghiêng; "&" trong ngoặc; ≥ 3 tác giả dùng "et al."; mọi tài liệu được trích dẫn và ngược lại.
- [x] Nhãn giả thuyết viết chỉ số dưới (H₁, H₂, H₃).
- [x] Bản ẩn danh sạch: không tên, email, ORCID, đơn vị; docProps trống; không có word/people.xml; không có Author contributions.
- [ ] Khai báo dùng AI: tác giả đã bỏ mục 4.6 (2026-09-26). Author Guidelines của JF:IP yêu cầu khai báo AI trong Methods; cover letter vẫn nhắc "Section 4.6".

## 3. Việc bạn tự làm trên hệ thống

- [ ] Vào trang nộp bài của AFA (https://afajof.org/jfip-submissions/), trả phí nộp bài (submission fee, theo trang AFA: Việt Nam thuộc nhóm middle-income, 75 USD nếu là hội viên AFA, 125 USD nếu không), rồi theo link sang Wiley Research Exchange để nộp. Nút Submit trên Wiley Online Library có thể chuyển sai sang Journal Finder.
- [ ] Lưu biên lai (receipt) phí nộp bài và upload làm Supplementary file: Author Guidelines ghi "Submission Fee: Supplementary file" và phí phải trả trước khi bài được xử lý.
- [ ] Nhập tác giả: họ ở ô Family, tên ở Given, đệm ở Middle (ví dụ Given "Trung", Middle "Van", Family "Nguyen").
- [ ] Keywords nhập cách nhau bằng dấu chấm phẩy: {{KEYWORDS}}.
- [ ] Mở 02 bằng Word kiểm tra công thức (LibreOffice không hiển thị công thức OMML).
- [ ] Build PDF → View → kiểm tra ẩn danh, hình, công thức → Approve. "Incomplete" nghĩa là thiếu mục hoặc có file lỗi.
- [ ] Tuỳ chọn: Plain Language Summary, Suggested X post, ORCID.
