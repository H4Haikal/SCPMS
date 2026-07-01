package controller.common;

import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.ColumnText;
import com.itextpdf.text.pdf.PdfGState;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfWriter;

public class WatermarkPageEvent extends PdfPageEventHelper {

    private final Font watermarkFont;

    public WatermarkPageEvent(Font font) {
        // Use a light gray color for the watermark text
        this.watermarkFont = new Font(font.getBaseFont(), 50, Font.BOLD, new com.itextpdf.text.BaseColor(200, 200, 200, 40));
    }

    @Override
    public void onEndPage(PdfWriter writer, Document document) {
        PdfContentByte canvas = writer.getDirectContentUnder();
        PdfGState gstate = new PdfGState();
        gstate.setFillOpacity(0.12f); // High transparency fade
        canvas.setGState(gstate);

        // Draw a repeating or centered diagonal watermark
        ColumnText.showTextAligned(canvas, Element.ALIGN_CENTER,
                new Phrase("MPP UMT MAJLIS PERWAKILAN PELAJAR", watermarkFont),
                297.5f, 421f, 45); // Center of A4 page rotated at 45 degrees
    }
}
