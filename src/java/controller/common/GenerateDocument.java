package controller.common;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import dao.ProposalDAO;
import model.EventItem;
import model.ProposalBudget;
import model.ProposalCommittee;
import model.ProposalItinerary;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "GenerateDocument", urlPatterns = {"/GenerateDocument2"})
public class GenerateDocument extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.getWriter().write("Error: Invalid ID.");
            return;
        }
        int proposalId = Integer.parseInt(idParam);

        ProposalDAO dao = new ProposalDAO();
        EventItem p = dao.getProposalById3NF(proposalId);

        if (p == null) {
            response.getWriter().write("Error: Data not found.");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=WorkingPaper_" + proposalId + ".pdf");

        try (OutputStream out = response.getOutputStream()) {

            // 1. Setup exact margins: Left=2.5cm (70.875pt), Right/Top/Bottom=2cm (56.7pt)
            float leftMargin = 2.5f * 28.35f;
            float rightMargin = 2.0f * 28.35f;
            float topMargin = 2.0f * 28.35f;
            float bottomMargin = 2.0f * 28.35f;

            Document document = new Document(PageSize.A4, leftMargin, rightMargin, topMargin, bottomMargin);
            PdfWriter writer = PdfWriter.getInstance(document, out);

            // 2. Register and configure Tahoma fonts
            FontFactory.registerDirectories();
            Font fontBase = FontFactory.getFont("Tahoma");
            if (fontBase.getBaseFont() == null) {
                // Fallback to Helvetica if server OS doesn't have Tahoma installed
                fontBase = FontFactory.getFont(FontFactory.HELVETICA);
            }

            Font headerFont = new Font(fontBase.getBaseFont(), 12, Font.BOLD);
            Font italicFont = new Font(fontBase.getBaseFont(), 12, Font.ITALIC);
            Font normalFont = new Font(fontBase.getBaseFont(), 12, Font.NORMAL);
            Font boldFont = new Font(fontBase.getBaseFont(), 12, Font.BOLD);

            // 3. Attach the Watermark event layer
            writer.setPageEvent(new WatermarkPageEvent(boldFont));

            document.open();
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");

            // ==========================================
            // COVER PAGE
            // ==========================================
            // Logos header (Top Section)
            PdfPTable logoTable = new PdfPTable(1);
            logoTable.setWidthPercentage(100);
            try {
                String logoPath = getServletContext().getRealPath("/images/Logo_Rasmi_UMT.png");
                Image logo = Image.getInstance(logoPath);
                logo.scaleToFit(140f, 140f);
                PdfPCell logoCell = new PdfPCell(logo);
                logoCell.setBorder(PdfPCell.NO_BORDER);
                logoCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                logoTable.addCell(logoCell);
            } catch (Exception e) {
                System.out.println("Header logo load failure: " + e.getMessage());
            }
            document.add(logoTable);

            // Cover Titles Block
            Paragraph cvText = new Paragraph();
            cvText.setLeading(18f); // 1.5 line spacing for Font 12
            cvText.setAlignment(Element.ALIGN_CENTER);
            cvText.add(new Phrase("\nUNIVERSITI MALAYSIA TERENGGANU\n", headerFont));

            String clubName = (p.getClubName() != null) ? p.getClubName().toUpperCase() : "";
            cvText.add(new Phrase(clubName + "\n\n", headerFont));
            cvText.add(new Phrase("KERTAS KERJA\n", headerFont));

            String title = (p.getTitle() != null) ? p.getTitle().toUpperCase() : "";
            cvText.add(new Phrase("PROGRAM " + title + "\n", headerFont));
            cvText.add(new Phrase("SESI 2025/2026\n\n\n\n", headerFont));
            document.add(cvText);

            // Cover Meta Info Table
            PdfPTable infoTable = new PdfPTable(new float[]{2f, 5f});
            infoTable.setWidthPercentage(100);

            String dateStr = p.getProposedDate() != null ? sdf.format(p.getProposedDate()).toUpperCase() : "";
            String venueStr = p.getVenue() != null ? p.getVenue().toUpperCase() : "";

            addMetaRow(infoTable, "TARIKH:", dateStr, boldFont);
            addMetaRow(infoTable, "TEMPAT:", venueStr, boldFont);
            addMetaRow(infoTable, "DENGAN KERJASAMA:", "HAL EHWAL PELAJAR DAN ALUMNI (HEPA)\nMAJLIS PERWAKILAN PELAJAR (MPP) UMT\nDAN JAWATANKUASA KELULUSAN DAN PEMANTAUAN PROGRAM MAHASISWA (JKPM)", boldFont);
            document.add(infoTable);

            // Move past cover page boundary
            document.newPage();

            // ==========================================
            // DOCUMENT CORE CONTENT
            // ==========================================
            // 1.1 Category Title (Must be uppercase, bold, size 12)
            Paragraph section1 = new Paragraph("KERTAS UNTUK PERTIMBANGAN", headerFont);
            section1.setSpacingAfter(10f);
            document.add(section1);

            // 1.2 Title Subheading (Underlined, Title-case mixed)
            Font underlineBold = new Font(fontBase.getBaseFont(), 12, Font.BOLD | Font.UNDERLINE);
            Paragraph titlePara = new Paragraph("Cadangan Penganjuran " + p.getTitle(), underlineBold);
            titlePara.setSpacingAfter(15f);
            document.add(titlePara);

            int paragraphNum = 1;

            // 1.3 Tujuan
            addHeading(document, "Tujuan", headerFont);
            addParagraph(document, "Kertas kerja ini bertujuan untuk mendapatkan pertimbangan dan kelulusan Mesyuarat Jawatankuasa Kelulusan dan Pemantauan Program Mahasiswa (JKPM) mengenai cadangan penganjuran " + p.getTitle() + ".", normalFont, paragraphNum++);

            // 1.4 Latar Belakang
            addHeading(document, "Latar Belakang", headerFont);
            addParagraph(document, p.getDescription(), normalFont, paragraphNum++);

            // 1.5 Objektif Program
            addHeading(document, "Objektif Program", headerFont);
            addParagraph(document, p.getObjective(), normalFont, paragraphNum++);

            // Add SDG context required implicitly by formatting rules
            addParagraph(document, "Program ini menepati Sustainable Development Goals (SDGs) impak: " + p.getSdgImpact() + " atas faktor " + p.getSdgReason(), italicFont, paragraphNum++);

            // 1.6 Maklumat Program
            addHeading(document, "Maklumat Program", headerFont);
            String infoPayload = "Maklumat perincian pengelolaan program dijadualkan seperti ketentuan di bawah:";
            addParagraph(document, infoPayload, normalFont, paragraphNum++);

            buildTentativeTable(document, p.getItineraries(), normalFont, boldFont);

            // 1.7 Implikasi Kewangan
            addHeading(document, "Implikasi Kewangan", headerFont);
            addParagraph(document, "Pelaksanaan program ini akan memberikan implikasi kewangan keseluruhan yang dianggarkan berjumlah RM " + String.format("%.2f", p.getEstimateBudget()) + ".", normalFont, paragraphNum++);

            buildFinancialTable(document, p.getBudgets(), p.getEstimateBudget(), normalFont, boldFont);

            // 1.8 Syor / Kelulusan
            addHeading(document, "Syor", headerFont);
            String syorText = "Justeru, Mesyuarat Jawatankuasa Kelulusan dan Pemantauan Program Mahasiswa (JKPM) adalah dimohon untuk mempertimbangkan serta meluluskan kertas kerja cadangan penganjuran " + p.getTitle() + " dengan implikasi kewangan yang dinyatakan.";
            addParagraph(document, syorText, normalFont, paragraphNum);

            // ==========================================
            // DOKUMEN CLOSING / SIGN-OFF BLOCK
            // ==========================================
            Paragraph signOff = new Paragraph();
            signOff.setLeading(12f); // Line spacing 1.0 for sign-off block
            signOff.setSpacingBefore(35f);
            signOff.add(new Phrase("Disediakan oleh: -\n\n\n\n", boldFont));

            String directorName = (p.getCreatedBy() != null) ? p.getCreatedBy().toUpperCase() : "PENGARAH PROGRAM";
            signOff.add(new Phrase("(" + directorName + ")\n", boldFont));
            signOff.add(new Phrase("Pengarah Program " + p.getTitle() + ",\n", normalFont));
            signOff.add(new Phrase(clubName + ",\nUniversiti Malaysia Terengganu.\n", normalFont));
            signOff.add(new Phrase("Tarikh: " + sdf.format(new java.util.Date()), normalFont));
            document.add(signOff);

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- STRUCTURAL FORMATTING HELPERS ---
    private void addMetaRow(PdfPTable table, String label, String value, Font font) {
        PdfPCell cellLabel = new PdfPCell(new Phrase(label, font));
        cellLabel.setBorder(PdfPCell.NO_BORDER);
        cellLabel.setPaddingBottom(12f);

        PdfPCell cellValue = new PdfPCell(new Phrase(value, font));
        cellValue.setBorder(PdfPCell.NO_BORDER);
        cellValue.setPaddingBottom(12f);

        table.addCell(cellLabel);
        table.addCell(cellValue);
    }

    private void addHeading(Document doc, String title, Font font) throws Exception {
        Paragraph heading = new Paragraph("\n" + title, font);
        heading.setSpacingBefore(10f);
        heading.setSpacingAfter(6f);
        doc.add(heading);
    }

    private void addParagraph(Document doc, String content, Font font, int currentId) throws Exception {
        if (content == null || content.trim().isEmpty()) {
            return;
        }

        Paragraph p = new Paragraph(currentId + ". " + content.trim(), font);
        p.setLeading(18f); // Strict Line Spacing 1.5 override
        p.setAlignment(Element.ALIGN_JUSTIFIED);
        p.setSpacingAfter(10f);
        doc.add(p);
    }

    private void buildTentativeTable(Document doc, List<ProposalItinerary> itineraries, Font font, Font boldFont) throws Exception {
        if (itineraries == null || itineraries.isEmpty()) {
            return;
        }

        PdfPTable table = new PdfPTable(new float[]{2f, 2f, 6f});
        table.setWidthPercentage(100);
        table.setSpacingBefore(8f);
        table.setSpacingAfter(12f);

        addCellHeader(table, "HARI / TARIKH", boldFont);
        addCellHeader(table, "MASA", boldFont);
        addCellHeader(table, "AKTIVITI / ACARA", boldFont);

        for (ProposalItinerary i : itineraries) {
            table.addCell(new PdfPCell(new Phrase(i.getDay(), font)));
            table.addCell(new PdfPCell(new Phrase(i.getTime(), font)));
            table.addCell(new PdfPCell(new Phrase(i.getActivity(), font)));
        }
        doc.add(table);
    }

    private void buildFinancialTable(Document doc, List<ProposalBudget> budgets, double totalSum, Font font, Font boldFont) throws Exception {
        if (budgets == null || budgets.isEmpty()) {
            return;
        }

        PdfPTable table = new PdfPTable(new float[]{5f, 1.5f, 2f, 2.5f});
        table.setWidthPercentage(100);
        table.setSpacingBefore(8f);
        table.setSpacingAfter(12f);

        addCellHeader(table, "PERKARA / PERINCIAN", boldFont);
        addCellHeader(table, "KUANTITI", boldFont);
        addCellHeader(table, "HARGA SEUNIT (RM)", boldFont);
        addCellHeader(table, "JUMLAH (RM)", boldFont);

        for (ProposalBudget b : budgets) {
            table.addCell(new PdfPCell(new Phrase(b.getItemName(), font)));

            PdfPCell qty = new PdfPCell(new Phrase(String.valueOf(b.getQuantity()), font));
            qty.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(qty);

            PdfPCell price = new PdfPCell(new Phrase(String.format("%.2f", b.getUnitPrice()), font));
            price.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(price);

            PdfPCell subtotal = new PdfPCell(new Phrase(String.format("%.2f", b.getTotalPrice()), font));
            subtotal.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(subtotal);
        }

        PdfPCell totalLabel = new PdfPCell(new Phrase("JUMLAH KESELURUHAN PERBELANJAAN (RM)", boldFont));
        totalLabel.setColspan(3);
        totalLabel.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalLabel.setBackgroundColor(new BaseColor(245, 245, 245));
        table.addCell(totalLabel);

        PdfPCell totalVal = new PdfPCell(new Phrase(String.format("%.2f", totalSum), boldFont));
        totalVal.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalVal.setBackgroundColor(new BaseColor(245, 245, 245));
        table.addCell(totalVal);

        doc.add(table);
    }

    private void addCellHeader(PdfPTable table, String name, Font font) {
        PdfPCell headerCell = new PdfPCell(new Phrase(name, font));
        headerCell.setBackgroundColor(new BaseColor(230, 230, 230));
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        headerCell.setPadding(6f);
        table.addCell(headerCell);
    }
}
