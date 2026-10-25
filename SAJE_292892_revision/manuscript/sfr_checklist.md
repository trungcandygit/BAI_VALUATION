# CHECKLIST NỘP BÀI — bộ hồ sơ theo khuôn Emerald (ScholarOne)

> Sustainable Finance Review đã từ chối bản trước (SFR-09-2026-0113, 11/10/2026, lý do phạm vi; ledger D-37). Bản này
> (v4) đã đặt lại khung theo tài chính bền vững; tạp chí tiếp theo CHƯA chọn. Bộ hồ sơ giữ định dạng Emerald; đổi tạp
> chí thì phải chỉnh lại theo Author Guidelines của tạp chí mới (độ dài abstract, kiểu trích dẫn, số exhibit).

Bài: "Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets"
Phản biện: double-anonymous. Phí: Emerald không thu phí nộp bài; APC chỉ khi chọn gold open access sau khi bài được nhận.
Dựng bằng `project_R/docx_build/build_sfr.py` (chạy lại sẽ ghi đè thư mục này).

## 1. File và cách upload trên ScholarOne

| File | Loại file khi upload | Ghi chú |
|---|---|---|
| 01_Title_Page.docx | Title Page (hoặc "Supplementary file NOT for review") | Tác giả, đơn vị, email, ORCID, Acknowledgements, funding, data availability, COI, author contributions, khai báo AI |
| 02_Manuscript_Anonymized.docx | Main Document | Ẩn danh; có [Insert Table n here] / [Insert Figure n here] |
| 03_Tables.docx | Table | Table 1–3, mỗi bảng một trang, Note(s) + Source(s) |
| 04_Figures/Figure_1.eps, Figure_2.eps | Figure | EPS là định dạng Emerald chấp nhận |
| 04_Figures/Figures_with_captions.docx | Figure (bản Word có chú thích) | Guideline: dán hình vào file Word |
| 05_Supplementary_material_appendix_1.docx | Supplementary Material (for review) | Table S1–S8, Figure S1–S2 |
| 06_Cover_Letter.docx | Cover Letter (dán vào ô cover letter) | |
| 07_Manuscript_with_Author_Details.docx | KHÔNG upload | Để dùng khi bài được nhận |
| 08_Replication_Package.zip | KHÔNG upload | Emerald không lưu file .zip; nộp kho công khai khi bài được nhận |

## 2. Đã kiểm tra bằng script
- [x] Structured abstract (Purpose; Design/methodology/approach; Findings; Research limitations/implications; Practical implications; Originality/value) ≤ 250 từ kể cả keywords và paper type; mỗi mục ≤ 100 từ.
- [x] 6 keywords; Paper type: Research paper; JEL classification.
- [x] Tài liệu tham khảo theo Emerald Harvard; trích dẫn "and", *et al.* in nghiêng; mọi tài liệu được trích dẫn.
- [x] Heading cấp 1 đậm, cấp 2 nghiêng; bảng và hình tách file, có vị trí trong bài; Note(s) và Source(s) dưới mỗi bảng, hình.
- [x] Bản ẩn danh không có tên, email, ORCID, đơn vị, Acknowledgements.
- [ ] Giới hạn số từ: phụ thuộc tạp chí mới (chưa chọn). Số từ hiện tại: xem dòng "body … words" khi chạy build_sfr.py và ledger Iter 13.

## 3. Điền trên ScholarOne
- Tác giả: họ ở Family (Nguyen), tên ở Given (Trung), đệm ở Middle (Van). Mỗi đồng tác giả cần tài khoản ScholarOne riêng; thứ tự: Nguyen Thanh Binh, Nguyen Van Trung (liên hệ), Ha Hong Hanh, Nguyen Bach Diep. Không đổi được danh sách tác giả sau khi nộp.
- Keywords: Emerging markets; ESG investing; ESG ratings; Firm valuation; Rating coverage; Sustainable finance.
- ORCID của từng tác giả.
