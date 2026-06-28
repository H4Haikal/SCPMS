package controller.common;

import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
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

@WebServlet(name = "GenerateDocument", urlPatterns = {"/GenerateDocument"})
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
        // Fetch the 3NF EventItem
        EventItem p = dao.getProposalById3NF(proposalId);

        if (p == null) {
            response.getWriter().write("Error: Data not found.");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=WorkingPaper_" + proposalId + ".pdf");

        try (OutputStream out = response.getOutputStream()) {
            Document document = new Document();
            PdfWriter.getInstance(document, out);
            document.open();

            Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
            Font normalFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL);
            Font boldFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

            // ==========================================
            // FRONT COVER
            // ==========================================
            try {
                String logoPath = getServletContext().getRealPath("/images/Logo_Rasmi_UMT.png");
                Image logo = Image.getInstance(logoPath);
                logo.scaleToFit(120f, 120f);
                logo.setAlignment(Element.ALIGN_CENTER);
                document.add(logo);
            } catch (Exception e) {
                System.out.println("Logo error: " + e.getMessage());
            }

            Paragraph coverText = new Paragraph();
            coverText.setAlignment(Element.ALIGN_CENTER);
            coverText.add(new Phrase("\nUNIVERSITI MALAYSIA TERENGGANU\nUMT\n\n", headerFont));

            String clubName = (p.getClubName() != null) ? p.getClubName().toUpperCase() : "";
            coverText.add(new Phrase(clubName + "\n", headerFont));
            coverText.add(new Phrase("2025/2026\n\n\n", headerFont));
            coverText.add(new Phrase("WORKING PAPER\n\n\n", titleFont));

            String title = (p.getTitle() != null) ? p.getTitle().toUpperCase() : "";
            coverText.add(new Phrase(title + "\n\n\n", titleFont));
            document.add(coverText);

            PdfPTable infoTable = new PdfPTable(new float[]{1, 2});
            infoTable.setWidthPercentage(80);
            infoTable.setHorizontalAlignment(Element.ALIGN_CENTER);

            String dateStr = p.getProposedDate() != null ? sdf.format(p.getProposedDate()) : "";
            String venueStr = p.getVenue() != null ? p.getVenue().toUpperCase() : "";

            addCoverRow(infoTable, "DATE:", dateStr, boldFont);
            addCoverRow(infoTable, "VENUE:", venueStr, boldFont);
            addCoverRow(infoTable, "IN COLLABORATION WITH:", "FACULTY MANAGEMENT\nSTUDENT REPRESENTATIVE COUNCIL (MPP) UMT", boldFont);
            document.add(infoTable);

            document.newPage();

            // ==========================================
            // CONTENT
            // ==========================================
            int counter = 1;

            addHeading(document, "PURPOSE", headerFont);
            counter = addParagraph(document, "This working paper is prepared to obtain consideration from the Student Affairs and Alumni Committee (HEPA), Universiti Malaysia Terengganu (UMT), to organize the program " + p.getTitle() + ".", normalFont, counter);

            addHeading(document, "BACKGROUND", headerFont);
            counter = addParagraph(document, p.getDescription(), normalFont, counter);

            addHeading(document, "PROGRAM OBJECTIVES", headerFont);
            counter = addParagraph(document, p.getObjective(), normalFont, counter);

            addHeading(document, "IMPACT ON SUSTAINABLE DEVELOPMENT GOALS (SDG)", headerFont);
            counter = addParagraph(document, p.getSdgImpact() + "\n" + p.getSdgReason(), normalFont, counter);

            // Using 3NF Table Builders
            addHeading(document, counter++ + ". PROGRAM IMPLEMENTATION & TENTATIVE", headerFont);
            buildTentativeTable(document, p.getItineraries(), normalFont, boldFont);

            addHeading(document, counter++ + ". ORGANIZING COMMITTEE", headerFont);
            buildCommitteeTable(document, p.getCommittees(), normalFont, boldFont);

            addHeading(document, counter++ + ". FINANCIAL IMPLICATIONS", headerFont);
            buildFinancialTable(document, p.getBudgets(), p.getEstimateBudget(), normalFont, boldFont);

            addHeading(document, counter + ". CONCLUSION & RECOMMENDATION", headerFont);
            addParagraph(document, "It is hoped that this program will be executed as planned to achieve the club's goals and UMT's objectives. The committee is respectfully requested to review and subsequently endorse this working paper.", normalFont, counter);

            // ==========================================
            // SIGNATURE BLOCK
            // ==========================================
            document.newPage();
            String student = (p.getCreatedBy() != null) ? p.getCreatedBy().toUpperCase() : "STUDENT REPRESENTATIVE";

            PdfPTable signTable = new PdfPTable(2);
            signTable.setWidthPercentage(100);
            signTable.setSpacingBefore(30f);
            signTable.addCell(createSignatureCell("Prepared by,", student, "Program Director,\nProgram " + title, normalFont));
            signTable.addCell(createSignatureCell("Reviewed by,", "CLUB PRESIDENT", "President,\n" + clubName + ",\nUniversiti Malaysia Terengganu.", normalFont));
            document.add(signTable);

            PdfPTable signTable2 = new PdfPTable(1);
            signTable2.setWidthPercentage(100);
            signTable2.setSpacingBefore(30f);
            signTable2.addCell(createSignatureCell("Verified by,", "CLUB ADVISOR", "Advisor,\n" + clubName + ",\nUniversiti Malaysia Terengganu.", normalFont));
            document.add(signTable2);

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- HELPER FUNCTIONS ---
    private void addCoverRow(PdfPTable table, String label, String value, Font font) {
        PdfPCell c1 = new PdfPCell(new Phrase(label, font));
        c1.setBorder(PdfPCell.NO_BORDER);
        c1.setPaddingBottom(15f);
        PdfPCell c2 = new PdfPCell(new Phrase(value, font));
        c2.setBorder(PdfPCell.NO_BORDER);
        c2.setPaddingBottom(15f);
        table.addCell(c1);
        table.addCell(c2);
    }

    private void addHeading(Document doc, String title, Font font) throws Exception {
        Paragraph heading = new Paragraph("\n" + title, font);
        heading.setSpacingAfter(8f);
        doc.add(heading);
    }

    private int addParagraph(Document doc, String content, Font font, int counter) throws Exception {
        if (content == null || content.trim().isEmpty()) {
            return counter;
        }
        String[] paragraphs = content.split("\n");
        for (String para : paragraphs) {
            if (!para.trim().isEmpty()) {
                Paragraph p = new Paragraph(counter + ". " + para.trim(), font);
                p.setAlignment(Element.ALIGN_JUSTIFIED);
                p.setSpacingAfter(8f);
                doc.add(p);
                counter++;
            }
        }
        return counter;
    }

    private PdfPCell createSignatureCell(String title, String name, String position, Font font) {
        Paragraph p = new Paragraph(title + "\n\n\n\n\n\n(" + name + ")\n" + position, font);
        PdfPCell cell = new PdfPCell(p);
        cell.setBorder(PdfPCell.NO_BORDER);
        return cell;
    }

    // ==========================================
    // 3NF PDF TABLE BUILDERS
    // ==========================================
    private void buildTentativeTable(Document doc, List<ProposalItinerary> itineraries, Font font, Font boldFont) throws Exception {
        if (itineraries == null || itineraries.isEmpty()) {
            doc.add(new Paragraph("No itinerary provided.\n", font));
            return;
        }
        PdfPTable table = new PdfPTable(new float[]{2f, 2f, 6f});
        table.setWidthPercentage(100);
        table.setSpacingBefore(5f);
        table.setSpacingAfter(15f);

        addTableHeader(table, new String[]{"DAY", "TIME", "ACTIVITY"}, boldFont);

        for (ProposalItinerary i : itineraries) {
            table.addCell(new Phrase(i.getDay() != null ? i.getDay() : "", font));
            table.addCell(new Phrase(i.getTime() != null ? i.getTime() : "", font));
            table.addCell(new Phrase(i.getActivity() != null ? i.getActivity() : "", font));
        }
        doc.add(table);
    }

    private void buildCommitteeTable(Document doc, List<ProposalCommittee> committees, Font font, Font boldFont) throws Exception {
        if (committees == null || committees.isEmpty()) {
            doc.add(new Paragraph("No committee provided.\n", font));
            return;
        }
        PdfPTable table = new PdfPTable(new float[]{2.5f, 4.5f, 3f});
        table.setWidthPercentage(100);
        table.setSpacingBefore(5f);
        table.setSpacingAfter(15f);

        addTableHeader(table, new String[]{"MATRIC NO.", "FULL NAME", "ROLE / POSITION"}, boldFont);

        for (ProposalCommittee c : committees) {
            table.addCell(new Phrase(c.getMatricNo() != null ? c.getMatricNo() : "", font));
            table.addCell(new Phrase(c.getName() != null ? c.getName() : "", font));
            table.addCell(new Phrase(c.getRole() != null ? c.getRole() : "", font));
        }
        doc.add(table);
    }

    private void buildFinancialTable(Document doc, List<ProposalBudget> budgets, double grandTotal, Font font, Font boldFont) throws Exception {
        if (budgets == null || budgets.isEmpty()) {
            doc.add(new Paragraph("No financial details provided.\n", font));
            return;
        }
        PdfPTable table = new PdfPTable(new float[]{4.5f, 1.5f, 2f, 2f});
        table.setWidthPercentage(100);
        table.setSpacingBefore(5f);
        table.setSpacingAfter(15f);

        addTableHeader(table, new String[]{"ITEM / DESCRIPTION", "QTY", "UNIT PRICE (RM)", "TOTAL (RM)"}, boldFont);

        for (ProposalBudget b : budgets) {
            table.addCell(new Phrase(b.getItemName() != null ? b.getItemName() : "", font));

            PdfPCell qtyCell = new PdfPCell(new Phrase(String.valueOf(b.getQuantity()), font));
            qtyCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(qtyCell);

            PdfPCell priceCell = new PdfPCell(new Phrase(String.format("%.2f", b.getUnitPrice()), font));
            priceCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(priceCell);

            PdfPCell totalCell = new PdfPCell(new Phrase(String.format("%.2f", b.getTotalPrice()), font));
            totalCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(totalCell);
        }

        // Add Grand Total Row
        PdfPCell cellLabel = new PdfPCell(new Phrase("GRAND TOTAL (RM)", boldFont));
        cellLabel.setColspan(3);
        cellLabel.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cellLabel.setBackgroundColor(new com.itextpdf.text.BaseColor(240, 240, 240));
        table.addCell(cellLabel);

        PdfPCell cellTotal = new PdfPCell(new Phrase(String.format("%.2f", grandTotal), boldFont));
        cellTotal.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cellTotal.setBackgroundColor(new com.itextpdf.text.BaseColor(240, 240, 240));
        table.addCell(cellTotal);

        doc.add(table);
    }

    private void addTableHeader(PdfPTable table, String[] headers, Font font) {
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, font));
            cell.setBackgroundColor(new com.itextpdf.text.BaseColor(230, 230, 230));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPaddingBottom(5f);
            table.addCell(cell);
        }
    }
}
