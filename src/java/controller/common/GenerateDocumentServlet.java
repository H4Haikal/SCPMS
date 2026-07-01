package controller.common;

import dao.ProposalDAO;
import model.EventItem;
import model.ProposalCommittee;
import model.ProposalBudget;
import model.ProposalItinerary;
import util.DocxTemplateEngine;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "GenerateDocumentServlet", urlPatterns = {"/GenerateDocument"})
public class GenerateDocumentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException {

        // Validate incoming Request Parameter ID
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(400, "Missing required 'id' parameter.");
            return;
        }

        int proposalId = Integer.parseInt(idParam);
        ProposalDAO dao = new ProposalDAO();

        // Use your 3NF method to grab the main proposal and relational lists
        EventItem p = dao.getProposalById3NF(proposalId);

        if (p == null) {
            response.sendError(404, "Proposal not found.");
            return;
        }

        // 1. Define Resource & Output Paths
        String templatePath = getServletContext().getRealPath("/WEB-INF/templates/HEPA_Template_Master.docx");
        String outputFileName = "WorkingPaper_" + p.getClubName().replaceAll(" ", "") + ".docx";

        // Dynamic Fallback: Use system temporary path if WebContext getRealPath returns null
        String outputPath;
        if (getServletContext().getRealPath("/temp/") != null) {
            outputPath = getServletContext().getRealPath("/temp/" + outputFileName);
            new File(getServletContext().getRealPath("/temp/")).mkdirs();
        } else {
            outputPath = System.getProperty("java.io.tmpdir") + File.separator + outputFileName;
        }

        // =====================================================================
        // STRUCTURED FINANCING SOURCE FIELDS EXTRACTION PARSER (Step 3 Replacement)
        // =====================================================================
        double budgetUmt = 0.00;
        double budgetYuran = 0.00;
        double budgetPtj = 0.00;
        double budgetLuar = 0.00;

        // A. Assign Club Wallet directly if funded flag evaluates to true
        if (p.isClubFunded()) {
            budgetUmt = p.getEstimateBudget();
        }

        // B. Extract structured columns via token index mapping from compound value
        String rawDetails = p.getBudgetDetails();
        if (rawDetails != null && rawDetails.contains("|||")) {
            String[] parts = rawDetails.split("\\|\\|\\|");
            try {
                if (parts.length > 0) {
                    budgetYuran = Double.parseDouble(parts[0].trim());
                }
                if (parts.length > 1) {
                    budgetPtj = Double.parseDouble(parts[1].trim());
                }
                if (parts.length > 2) {
                    budgetLuar = Double.parseDouble(parts[2].trim());
                }
            } catch (NumberFormatException e) {
                // Fallback catch if token contains unparsable characters
            }
        }
        int totalAttendees = p.getEstimateParticipant();
        double totalYuranCollected = budgetYuran * totalAttendees;

        // C. Final sum total calculations
        double totalSourcesOfRevenue = budgetUmt + totalYuranCollected + budgetPtj + budgetLuar;

        // 2. Map Database values to Microsoft Word Tags
        Map<String, String> data = new HashMap<>();

        // Basic Info Mappings
        data.put("<<CLUB_NAME>>", p.getClubName() != null ? p.getClubName() : "N/A");
        data.put("<<PROPOSAL_TITLE>>", p.getTitle() != null ? p.getTitle().toUpperCase() : "UNTITLED PROPOSAL");
        data.put("<<VENUE>>", p.getVenue() != null ? p.getVenue() : "TBD");
        data.put("<<TARGET_AUDIENCE>>", p.getTargetAudience() != null ? p.getTargetAudience() : "Pelajar UMT");

        // =====================================================================
        // PROBLEM 3: DYNAMIC BULLET POINT CONVERTER
        // =====================================================================
        // =====================================================================
        // FIXED DYNAMIC BULLET POINT CONVERTER (Perfect Alignment Override)
        // =====================================================================
        String rawObjective = p.getObjective();
        StringBuilder objBuilder = new StringBuilder();

        if (rawObjective != null && !rawObjective.trim().isEmpty()) {
            // Split by any newline variations
            String[] lines = rawObjective.split("\\r?\\n");
            for (String line : lines) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                // 1. Force trim the line to clear raw trailing/leading spaces first
                String cleanLine = line.trim();

                // 2. Clear out ALL possible historical bullets (numbers, dots, dashes, brackets, letters like a,b,c)
                // This strips patterns like "a)", "1.", "-", "•" comprehensively
                cleanLine = cleanLine.replaceAll("^(?i)([a-z0-9][\\.\\)\\-]|\\-|\\•|\\*|\\d+)\\s*", "").trim();

                // 3. One more safety pass to clear any residual nested spaces or loose formatting artifacts
                cleanLine = cleanLine.replaceAll("^\\s+", "").trim();

                if (!cleanLine.isEmpty()) {
                    // Append with an identical uniform prefix tab space indentation pattern
                    objBuilder.append("   •  ").append(cleanLine).append("\r\n");
                }
            }
        } else {
            objBuilder.append("Tiada objektif dinyatakan.");
        }
        data.put("<<OBJECTIVE>>", objBuilder.toString().trim());

        data.put("<<DESCRIPTION>>", p.getDescription() != null ? p.getDescription() : "Tiada huraian program dinyatakan.");
        data.put("<<STATUS>>", p.getStatus());

        // Financial Values Mapping (Grid Cells Alignment)
        data.put("<<VAL_VOT>>", String.format("%.2f", budgetUmt));
        data.put("<<VAL_YURAN_RATE>>", String.format("%.2f", budgetYuran));
        data.put("<<ESTIMATE_PARTICIPANT>>", String.valueOf(totalAttendees));
        data.put("<<VAL_TOTAL_YURAN>>", String.format("%.2f", totalYuranCollected)); // <-- Total line mapping
        data.put("<<VAL_PTJ>>", String.format("%.2f", budgetPtj));
        data.put("<<VAL_LUAR>>", String.format("%.2f", budgetLuar));
        data.put("<<VAL_TOTAL_SUMBER>>", String.format("%.2f", totalSourcesOfRevenue));

        data.put("<<ESTIMATE_PARTICIPANT>>", String.valueOf(p.getEstimateParticipant()));

        boolean hasEriskFile = (p.getEriskFile() != null && !p.getEriskFile().trim().isEmpty());

        if (!hasEriskFile) {
            // Case 1: No file attached -> standard text loop replaces the tag text with this label instantly
            data.put("<<ERISK_SNAPSHOT>>", "Tiada Penilaian Risiko Awal (e-Risk) Dikepilkan / Diperlukan bagi fasa semakan draf ini.");
        } else {
            // Case 2: File exists -> text loop wipes the tag characters out so your images can insert cleanly
            data.put("<<ERISK_SNAPSHOT>>", "");
        }

        // Dynamic Date Calculations 
        String dateRange = (p.getProposedDate() != null) ? p.getProposedDate().toString() : "TBD";
        if (p.getEndDate() != null && !p.getProposedDate().equals(p.getEndDate())) {
            dateRange += " hingga " + p.getEndDate().toString();
        }
        data.put("<<DATES>>", dateRange);

        // Demographics Headcount Metrics Summary Calculation
        int totalParticipants = p.getParticipantUmt() + p.getParticipantStaff() + p.getParticipantPublic();
        String participantBreakdown = String.format("Jumlah Keseluruhan: %d orang\n"
                + "- Pelajar UMT: %d orang\n"
                + "- Staf UMT: %d orang\n"
                + "- Orang Awam: %d orang",
                totalParticipants, p.getParticipantUmt(), p.getParticipantStaff(), p.getParticipantPublic());
        data.put("<<PARTICIPANTS_SUMMARY>>", participantBreakdown);

        // Budget Baseline Total Cost Mapping
        data.put("<<BUDGET>>", "RM " + String.format("%.2f", p.getEstimateBudget()));

        // Initialize your UserDAO class alongside your existing ProposalDAO
        dao.UserDAO userDAO = new dao.UserDAO();

        // --- Director & Phone Lookup Block ---
        String directorName = "Tiada Pengarah";
        String directorPhone = "Tiada No. Tel";

        if (p.getCommittees() != null) {
            for (ProposalCommittee c : p.getCommittees()) {
                if ("Director".equalsIgnoreCase(c.getRole()) || "Pengarah".equalsIgnoreCase(c.getRole())) {
                    directorName = c.getName();

                    // Pull the unique student matric number string to search user profile profiles
                    // Change to getMatricNo() if spelled with a 'c' in your model class
                    String lookupMatric = c.getMatricNo();

                    if (lookupMatric != null && !lookupMatric.trim().isEmpty()) {
                        model.User directorUser = userDAO.getUserById(lookupMatric);

                        if (directorUser != null && directorUser.getPhone() != null) {
                            directorPhone = directorUser.getPhone();
                        }
                    }
                    break;
                }
            }
        }

        // Safety Fallback: If no phone was found in the loop, check the proposal creator's profile
        if ("Tiada No. Tel".equals(directorPhone) && p.getCreatedBy() != null) {
            model.User creatorUser = userDAO.getUserById(p.getCreatedBy());
            if (creatorUser != null && creatorUser.getPhone() != null) {
                directorPhone = creatorUser.getPhone();
            }
        }

        // Bind cleanly back out to your Word Document template tags
        data.put("<<DIRECTOR_NAME>>", directorName);
        data.put("<<DIRECTOR_PHONE>>", directorPhone);

        // Dynamic Malay Language Document Timestamp Formatting (E.g., 01 Julai 2026)
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMMM yyyy", new java.util.Locale("ms", "MY"));
        data.put("<<CURRENT_DATE>>", sdf.format(new java.util.Date()));

        // =====================================================================
        // ADVANCED STRATEGIC COMPLIANCE PARSER (Extracts post-caret reason chunks)
        // =====================================================================
        StringBuilder sdgBuilder = new StringBuilder();
        String rawSdgImpact = p.getSdgImpact();
        String rawSdgReason = p.getSdgReason();

        if (rawSdgImpact != null && !rawSdgImpact.trim().isEmpty()) {
            String[] sdgTitles = rawSdgImpact.split("\\|\\|\\|");
            String[] sdgReasons = (rawSdgReason != null) ? rawSdgReason.split("\\|\\|\\|") : new String[0];

            int totalEntries = Math.max(sdgTitles.length, sdgReasons.length);
            int entryNum = 1;

            for (int i = 0; i < totalEntries; i++) {
                String title = (i < sdgTitles.length) ? sdgTitles[i].trim() : "N/A";
                String fullReasonStr = (i < sdgReasons.length) ? sdgReasons[i].trim() : "";
                String actualJustification = "Tiada huraian impak diberikan.";

                // Process and isolate any carets inside the core Strategic Title field
                if (title.contains("^")) {
                    String[] titleParts = title.split("\\^");
                    title = titleParts[0].trim();
                }

                // THE SOLUTION: Split the reason string and grab ONLY the part after the caret
                if (!fullReasonStr.isEmpty()) {
                    if (fullReasonStr.contains("^")) {
                        String[] reasonParts = fullReasonStr.split("\\^");
                        // If there is data after the caret, map it as the true justification narrative
                        if (reasonParts.length > 1) {
                            actualJustification = reasonParts[1].trim();
                        } else {
                            actualJustification = "Tiada huraian impak diberikan.";
                        }
                    } else {
                        // Fallback if the string somehow didn't store a caret character
                        actualJustification = fullReasonStr;
                    }
                }

                if (title.isEmpty() && actualJustification.isEmpty()) {
                    continue;
                }

                // Build layout with explicit carriage return line feeds (\r\n) for clean styling margins
                sdgBuilder.append(entryNum).append(". Teras Strategik: ").append(title).append("\r\n");
                sdgBuilder.append("   Justifikasi Impak: ").append(actualJustification).append("\r\n\r\n");
                entryNum++;
            }
        } else {
            sdgBuilder.append("Tiada Kluster Pembangunan Mampan (SDG) yang didaftarkan.");
        }
        data.put("<<SDG_IMPACT_LIST>>", sdgBuilder.toString().trim());

        // =====================================================================
        // RELATIONAL 3NF COMPOSITE ROW COMPILATION
        // =====================================================================
        // A. Multi-Row Committee Matrix Generation
        StringBuilder committeeBuilder = new StringBuilder();
        if (p.getCommittees() != null && !p.getCommittees().isEmpty()) {
            int idx = 1;
            for (ProposalCommittee c : p.getCommittees()) {
                committeeBuilder.append(String.format("%d. %-20s : %s\n", idx++, c.getRole(), c.getName()));
            }
        } else {
            committeeBuilder.append("Tiada jawatankuasa pelaksana berdaftar.");
        }
        data.put("<<COMMITTEE_TABLE_ROWS>>", committeeBuilder.toString().trim());

        // B. Monospaced Financial Line-Item Table Structure Formulation
        StringBuilder budgetBuilder = new StringBuilder();
        if (p.getBudgets() != null && !p.getBudgets().isEmpty()) {
            int idx = 1;
            budgetBuilder.append(String.format(" %-3s | %-32s | %-6s | %-12s | %-12s\n", "Bil", "Perkara / Deskripsi Perincian", "Kuant.", "Harga Unit", "Jumlah (RM)"));
            budgetBuilder.append(" -----+----------------------------------+--------+--------------+--------------\n");

            for (ProposalBudget b : p.getBudgets()) {
                budgetBuilder.append(String.format(
                        "  %02d | %-32s | %-6d | RM %-9.2f | RM %-9.2f\n",
                        idx++,
                        b.getItemName() != null ? b.getItemName() : "Item Am",
                        b.getQuantity(),
                        b.getUnitPrice(),
                        b.getTotalPrice()
                ));
            }
        } else {
            budgetBuilder.append(" Peruntukan Kontingensi Kelab Am: ").append(String.format("RM %.2f", p.getEstimateBudget()));
        }
        data.put("<<BUDGET_TABLE_ROWS>>", budgetBuilder.toString());

        // C. Multi-Day Event Schedule Roadmap Formatting
        StringBuilder itineraryBuilder = new StringBuilder();
        if (p.getItineraries() != null && !p.getItineraries().isEmpty()) {
            String currentDay = "";
            for (ProposalItinerary i : p.getItineraries()) {
                if (i.getDay() != null && !i.getDay().equalsIgnoreCase(currentDay)) {
                    currentDay = i.getDay();
                    itineraryBuilder.append("\n=== FASA MASA: ").append(currentDay.toUpperCase()).append(" ===\n");
                }
                itineraryBuilder.append(String.format(
                        " Masa [%-8s] : %s\n",
                        i.getTime() != null ? i.getTime() : "TBD",
                        i.getActivity() != null ? i.getActivity() : "Aktiviti Kosong"
                ));
            }
        } else {
            itineraryBuilder.append("Aturcara program terperinci belum dimuat naik.");
        }
        data.put("<<ITINERARY_LIST>>", itineraryBuilder.toString().trim());

        // =====================================================================
        // EXECUTION & DOCK FLUSH STREAMING Lifecycle
        // =====================================================================
        try {
            // 1. Load the template using native Apache POI Document controls
            org.apache.poi.xwpf.usermodel.XWPFDocument document;
            try (FileInputStream fis = new FileInputStream(templatePath)) {
                document = new org.apache.poi.xwpf.usermodel.XWPFDocument(fis);
            }

            // 2. Process Standard Text Replacements across standard paragraphs
            org.apache.poi.xwpf.usermodel.XWPFParagraph objectiveTarget = null;

            for (org.apache.poi.xwpf.usermodel.XWPFParagraph paragraph : document.getParagraphs()) {
                String text = paragraph.getText();
                if (text != null && !text.trim().isEmpty()) {

                    // Check if this paragraph is our objective marker target
                    if (text.contains("<<OBJECTIVE_MARKER>>")) {
                        objectiveTarget = paragraph;
                        continue;
                    }

                    boolean hasPlaceholder = false;
                    for (Map.Entry<String, String> entry : data.entrySet()) {
                        if (text.contains(entry.getKey())) {
                            text = text.replace(entry.getKey(), entry.getValue() != null ? entry.getValue() : "");
                            hasPlaceholder = true;
                        }
                    }
                    if (hasPlaceholder) {
                        int runsSize = paragraph.getRuns().size();
                        for (int i = runsSize - 1; i >= 0; i--) {
                            paragraph.removeRun(i);
                        }
                        org.apache.poi.xwpf.usermodel.XWPFRun run = paragraph.createRun();
                        run.setText(text);
                        run.setFontFamily("Times New Roman");
                        run.setFontSize(12);
                    }
                }
            }

            // =====================================================================
            // NATIVE BULLET POINT INJECTOR (Fixed Parallel Indentation Bounds)
            // =====================================================================
            if (objectiveTarget != null) {
                int pos = document.getParagraphs().indexOf(objectiveTarget);
                rawObjective = p.getObjective();

                if (rawObjective != null && !rawObjective.trim().isEmpty()) {
                    String[] lines = rawObjective.split("\\r?\\n");

                    for (String line : lines) {
                        if (line.trim().isEmpty()) {
                            continue;
                        }

                        String cleanLine = line.trim().replaceAll("^(?i)([a-z0-9][\\.\\)\\-]|\\-|\\•|\\*|\\d+)\\s*", "").trim();
                        if (cleanLine.isEmpty()) {
                            continue;
                        }

                        // 1. Programmatically insert a clean paragraph row context element
                        org.apache.poi.xwpf.usermodel.XWPFParagraph newPara = document.insertNewParagraph(objectiveTarget.getCTP().newCursor());

                        // 2. THE ABSOLUTE CRITICAL COALESCING LINE ALIGNMENT SETTINGS:
                        // Left indentation sets where the body text aligns (e.g., 720 dxa = 0.5 inches)
                        // Hanging indentation pulls the bullet symbol itself backwards to align symmetrically
                        newPara.setIndentationLeft(720);    // Forces text baseline to match
                        newPara.setIndentationHanging(360); // Keeps bullet beautifully aligned at the left margin

                        // Populate bullet text uniformly without adding nested string spaces
                        org.apache.poi.xwpf.usermodel.XWPFRun run = newPara.createRun();
                        run.setText("•  " + cleanLine);
                        run.setFontFamily("Times New Roman");
                        run.setFontSize(12);
                    }
                } else {
                    org.apache.poi.xwpf.usermodel.XWPFParagraph newPara = document.insertNewParagraph(objectiveTarget.getCTP().newCursor());
                    org.apache.poi.xwpf.usermodel.XWPFRun run = newPara.createRun();
                    run.setText("Tiada objektif dinyatakan.");
                    run.setFontFamily("Times New Roman");
                    run.setFontSize(12);
                }

                // Remove the temporary template anchor target token paragraph cleanly
                document.removeBodyElement(document.getPosOfParagraph(objectiveTarget));
            }

            // 3. Process Standard Text Replacements inside Table Grids
            for (org.apache.poi.xwpf.usermodel.XWPFTable tbl : document.getTables()) {
                for (org.apache.poi.xwpf.usermodel.XWPFTableRow row : tbl.getRows()) {
                    for (org.apache.poi.xwpf.usermodel.XWPFTableCell cell : row.getTableCells()) {
                        for (org.apache.poi.xwpf.usermodel.XWPFParagraph paragraph : cell.getParagraphs()) {
                            String text = paragraph.getText();
                            if (text != null && !text.trim().isEmpty()) {
                                boolean hasPlaceholder = false;
                                for (Map.Entry<String, String> entry : data.entrySet()) {
                                    if (text.contains(entry.getKey())) {
                                        text = text.replace(entry.getKey(), entry.getValue() != null ? entry.getValue() : "");
                                        hasPlaceholder = true;
                                    }
                                }
                                if (hasPlaceholder) {
                                    int runsSize = paragraph.getRuns().size();
                                    for (int i = runsSize - 1; i >= 0; i--) {
                                        paragraph.removeRun(i);
                                    }
                                    org.apache.poi.xwpf.usermodel.XWPFRun run = paragraph.createRun();
                                    run.setText(text);
                                    // Use monospaced font if it's the financial row token
                                    if (text.contains("\n") || text.contains("|")) {
                                        run.setFontFamily("Consolas");
                                        run.setFontSize(10);
                                    } else {
                                        run.setFontFamily("Times New Roman");
                                        run.setFontSize(11);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // 4. CONVERT MULTI-PAGE E-RISK PDF TO IMAGE SNAPSHOTS OR INJECT TEXT FALLBACK
            hasEriskFile = (p.getEriskFile() != null && !p.getEriskFile().trim().isEmpty());

            // A. Locate the exact paragraph placeholder in the template document
            org.apache.poi.xwpf.usermodel.XWPFParagraph targetParagraph = null;
            for (org.apache.poi.xwpf.usermodel.XWPFParagraph paragraph : document.getParagraphs()) {
                if (paragraph.getText() != null && paragraph.getText().contains("<<ERISK_SNAPSHOT>>")) {
                    targetParagraph = paragraph;
                    break;
                }
            }

            if (targetParagraph != null) {
                // Clear the raw <<ERISK_SNAPSHOT>> token text first
                int runsSize = targetParagraph.getRuns().size();
                for (int i = runsSize - 1; i >= 0; i--) {
                    targetParagraph.removeRun(i);
                }

                if (hasEriskFile) {
                    // --- PROFILE 1: FILE EXISTS -> CONVERT AND INJECT IMAGES ---
                    String absolutePdfPath = getServletContext().getRealPath("/" + p.getEriskFile());
                    File pdfFile = new File(absolutePdfPath);

                    if (pdfFile.exists()) {
                        try (org.apache.pdfbox.pdmodel.PDDocument pdfDoc = org.apache.pdfbox.Loader.loadPDF(pdfFile)) {
                            org.apache.pdfbox.rendering.PDFRenderer renderer = new org.apache.pdfbox.rendering.PDFRenderer(pdfDoc);
                            int pageCount = pdfDoc.getNumberOfPages();

                            for (int pageIdx = 0; pageIdx < pageCount; pageIdx++) {
                                java.awt.image.BufferedImage bim = renderer.renderImageWithDPI(pageIdx, 150);
                                java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
                                javax.imageio.ImageIO.write(bim, "png", baos);
                                byte[] pngBytes = baos.toByteArray();

                                org.apache.poi.xwpf.usermodel.XWPFRun run = targetParagraph.createRun();
                                try (java.io.ByteArrayInputStream bais = new java.io.ByteArrayInputStream(pngBytes)) {
                                    int widthEMU = org.apache.poi.util.Units.toEMU(380);
                                    int heightEMU = org.apache.poi.util.Units.toEMU(500);
                                    run.addPicture(bais, org.apache.poi.xwpf.usermodel.XWPFDocument.PICTURE_TYPE_PNG,
                                            "erisk_page_" + pageIdx + ".png", widthEMU, heightEMU);
                                }

                                if (pageIdx < pageCount - 1) {
                                    org.apache.poi.xwpf.usermodel.XWPFRun breakRun = targetParagraph.createRun();
                                    breakRun.addBreak(org.apache.poi.xwpf.usermodel.BreakType.PAGE);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            // Fallback to text inside the target run if rendering fails unexpectedly
                            org.apache.poi.xwpf.usermodel.XWPFRun errorRun = targetParagraph.createRun();
                            errorRun.setText("Ralat teknikal semasa memuatkan dokumen e-Risk.");
                            errorRun.setFontFamily("Times New Roman");
                            errorRun.setFontSize(11);
                        }
                    } else {
                        // Fallback text if the file is registered in the database but missing on the server disk
                        org.apache.poi.xwpf.usermodel.XWPFRun missingRun = targetParagraph.createRun();
                        missingRun.setText("Fail lampiran tiada di dalam storan pelayan.");
                        missingRun.setFontFamily("Times New Roman");
                        missingRun.setFontSize(11);
                    }
                } else {
                    // --- PROFILE 2: NO FILE ATTACHED YET -> RENDER CLEAN FALLBACK TEXT ---
                    org.apache.poi.xwpf.usermodel.XWPFRun noEriskRun = targetParagraph.createRun();
                    noEriskRun.setText("Tiada Penilaian Risiko Awal (e-Risk) Dikepilkan / Diperlukan bagi fasa semakan draf ini.");
                    noEriskRun.setFontFamily("Times New Roman");
                    noEriskRun.setFontSize(11);
                    noEriskRun.setItalic(true); // Optional formatting styling to make it look distinct

                    
                }
            }

            // =====================================================================
            // REAL WORD TABLE GRID PROGRAMMATIC INJECTION LAYER (3NF)
            // =====================================================================
            for (org.apache.poi.xwpf.usermodel.XWPFTable table : document.getTables()) {

                // -----------------------------------------------------------------
                // PROBLEM 5: ANGGARAN PERBELANJAAN (5-COLUMN PROGRAMMATIC GRID)
                // -----------------------------------------------------------------
                org.apache.poi.xwpf.usermodel.XWPFTableRow budgetMarkerRow = null;
                for (org.apache.poi.xwpf.usermodel.XWPFTableRow row : table.getRows()) {
                    if (row.getCell(0) != null && row.getCell(0).getText().contains("<<B_ROW>>")) {
                        budgetMarkerRow = row;
                        break;
                    }
                }

                if (budgetMarkerRow != null) {
                    int targetPos = table.getRows().indexOf(budgetMarkerRow);
                    int bilIndex = 1;

                    if (p.getBudgets() != null && !p.getBudgets().isEmpty()) {
                        for (model.ProposalBudget b : p.getBudgets()) {
                            // Insert an active row into the live table structure matrix
                            org.apache.poi.xwpf.usermodel.XWPFTableRow newRow = table.insertNewTableRow(targetPos + bilIndex);

                            // Populate your 5 distinct target grid columns natively
                            newRow.createCell().setText(String.format("%02d", bilIndex));
                            newRow.createCell().setText(b.getItemName() != null ? b.getItemName() : "Item Am");
                            newRow.createCell().setText(String.valueOf(b.getQuantity()));
                            newRow.createCell().setText(String.format("RM %.2f", b.getUnitPrice()));
                            newRow.createCell().setText(String.format("RM %.2f", b.getTotalPrice()));

                            // Standardize typography styling rules for high-authority presentation
                            for (org.apache.poi.xwpf.usermodel.XWPFTableCell cell : newRow.getTableCells()) {
                                if (!cell.getParagraphs().isEmpty()) {
                                    org.apache.poi.xwpf.usermodel.XWPFParagraph cp = cell.getParagraphs().get(0);
                                    if (cp.getRuns().isEmpty()) {
                                        cp.createRun();
                                    }
                                    cp.getRuns().get(0).setFontFamily("Times New Roman");
                                    cp.getRuns().get(0).setFontSize(11);
                                }
                            }
                            bilIndex++;
                        }
                    } else {
                        // Fallback line if sub-tables return completely blank
                        org.apache.poi.xwpf.usermodel.XWPFTableRow newRow = table.insertNewTableRow(targetPos + 1);
                        newRow.createCell().setText("01");
                        newRow.createCell().setText("Anggaran Kasar Pukal Program Kelab");
                        newRow.createCell().setText("1");
                        newRow.createCell().setText(String.format("RM %.2f", p.getEstimateBudget()));
                        newRow.createCell().setText(String.format("RM %.2f", p.getEstimateBudget()));
                    }
                    table.removeRow(targetPos); // Safely drop your temporary placeholder row marker
                }

                // -----------------------------------------------------------------
                // PROBLEM 6 & 7: ATURCARA PROGRAM (3-COLUMN STRUCTURED GRID)
                // -----------------------------------------------------------------
                org.apache.poi.xwpf.usermodel.XWPFTableRow itineraryMarkerRow = null;
                for (org.apache.poi.xwpf.usermodel.XWPFTableRow row : table.getRows()) {
                    if (row.getCell(0) != null && row.getCell(0).getText().contains("<<I_ROW>>")) {
                        itineraryMarkerRow = row;
                        break;
                    }
                }

                if (itineraryMarkerRow != null) {
                    int targetPos = table.getRows().indexOf(itineraryMarkerRow);
                    int itinIndex = 1;

                    if (p.getItineraries() != null && !p.getItineraries().isEmpty()) {
                        for (model.ProposalItinerary i : p.getItineraries()) {
                            org.apache.poi.xwpf.usermodel.XWPFTableRow newRow = table.insertNewTableRow(targetPos + itinIndex);

                            // Seed data directly into separate cell columns natively (3 Columns layout)
                            newRow.createCell().setText(i.getDay() != null ? i.getDay().toUpperCase() : "HARI 1");
                            newRow.createCell().setText(i.getTime() != null ? i.getTime() : "TBD");
                            newRow.createCell().setText(i.getActivity() != null ? i.getActivity() : "Aktiviti Program");

                            // Apply Times New Roman fonts across row collections
                            for (org.apache.poi.xwpf.usermodel.XWPFTableCell cell : newRow.getTableCells()) {
                                if (!cell.getParagraphs().isEmpty()) {
                                    org.apache.poi.xwpf.usermodel.XWPFParagraph cp = cell.getParagraphs().get(0);
                                    if (cp.getRuns().isEmpty()) {
                                        cp.createRun();
                                    }
                                    cp.getRuns().get(0).setFontFamily("Times New Roman");
                                    cp.getRuns().get(0).setFontSize(11);
                                }
                            }
                            itinIndex++;
                        }
                    } else {
                        org.apache.poi.xwpf.usermodel.XWPFTableRow newRow = table.insertNewTableRow(targetPos + 1);
                        newRow.createCell().setText("AM");
                        newRow.createCell().setText("TBD");
                        newRow.createCell().setText("Aturcara tertakluk kepada pelunasan penceramah / pihak penganjur.");
                    }
                    table.removeRow(targetPos); // Safely drop your temporary placeholder row marker
                }
            }

            // 5. Write the compiled document out to the server temporary file
            try (java.io.FileOutputStream fos = new java.io.FileOutputStream(outputPath)) {
                document.write(fos);
            }
            document.close();

            // 6. Bind response content headers and push download stream to client browser
            File downloadFile = new File(outputPath);
            response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
            response.setContentLength((int) downloadFile.length());
            response.setHeader("Content-Disposition", "attachment; filename=\"" + outputFileName + "\"");

            try (FileInputStream inStream = new FileInputStream(downloadFile); OutputStream outStream = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inStream.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }
                outStream.flush();
            }

            // 7. Housekeeping: Delete the temporary file from server host disk
            downloadFile.delete();

        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(500, "Critical Failure in dynamic template build runtime.");
            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException {
        doGet(request, response);
    }
}
