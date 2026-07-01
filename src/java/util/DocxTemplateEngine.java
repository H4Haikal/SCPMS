package util;

import org.apache.poi.xwpf.usermodel.*;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;

public class DocxTemplateEngine {

    // Web-Optimized: Takes streams instead of strict server file paths
    public static void generateDocument(InputStream templateStream, OutputStream outputStream, Map<String, String> data) throws Exception {

        try (XWPFDocument document = new XWPFDocument(templateStream)) {

            // 1. Replace tags in standard paragraphs
            for (XWPFParagraph paragraph : document.getParagraphs()) {
                replaceTextInParagraph(paragraph, data);
            }

            // 2. Replace tags inside tables
            for (XWPFTable tbl : document.getTables()) {
                for (XWPFTableRow row : tbl.getRows()) {
                    for (XWPFTableCell cell : row.getTableCells()) {
                        for (XWPFParagraph paragraph : cell.getParagraphs()) {
                            replaceTextInParagraph(paragraph, data);
                        }
                    }
                }
            }

            // 3. Directly stream the file out to the browser
            document.write(outputStream);
        }
    }

    private static void replaceTextInParagraph(XWPFParagraph p, Map<String, String> data) {
        String text = p.getText();
        if (text == null || text.trim().isEmpty()) {
            return;
        }

        boolean hasPlaceholder = false;

        for (Map.Entry<String, String> entry : data.entrySet()) {
            if (text.contains(entry.getKey())) {
                text = text.replace(entry.getKey(), entry.getValue() != null ? entry.getValue() : "");
                hasPlaceholder = true;
            }
        }

        if (hasPlaceholder) {
            int runsSize = p.getRuns().size();
            for (int i = runsSize - 1; i >= 0; i--) {
                p.removeRun(i);
            }

            XWPFRun run = p.createRun();
            run.setText(text);
            run.setFontFamily("Times New Roman");
            run.setFontSize(12);
        }
    }

    public static void insertSnapshot(XWPFParagraph p, byte[] imageBytes) throws Exception {
        if (imageBytes == null || imageBytes.length == 0) {
            return;
        }

        // 1. Clear out the <<ERISK_SNAPSHOT>> text placeholder safely
        int runsSize = p.getRuns().size();
        for (int i = runsSize - 1; i >= 0; i--) {
            p.removeRun(i);
        }

        // 2. Open a stream and embed the picture metadata directly
        XWPFRun run = p.createRun();
        try (java.io.ByteArrayInputStream bais = new java.io.ByteArrayInputStream(imageBytes)) {
            // Standard A4 Layout Fitting (Width: ~5.0 inches, Height: ~6.5 inches)
            int widthEMU = org.apache.poi.util.Units.toEMU(360);
            int heightEMU = org.apache.poi.util.Units.toEMU(480);

            run.addPicture(bais, org.apache.poi.xwpf.usermodel.XWPFDocument.PICTURE_TYPE_PNG,
                    "erisk_snapshot.png", widthEMU, heightEMU);
        }
    }

}
