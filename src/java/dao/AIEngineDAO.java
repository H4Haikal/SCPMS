package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import util.DBConnection;

public class AIEngineDAO {

    // =========================================================================
    // 1. UNIFIED SCORE CALCULATOR (SAVED TO DATABASE)
    // ADDED boolean isClubFunded
    // =========================================================================
    public int calculateConflictScore(int clubId, String proposedDateStr, double budget, String budgetDetails, int pax, int duration, boolean isClubFunded) {
        int viabilityScore = 100;

        try (Connection conn = DBConnection.getConnection()) {
            java.sql.Date proposedDate = java.sql.Date.valueOf(proposedDateStr);

            // A. Timing & Calendar Checks
            String sqlCalendar = "SELECT eventType FROM master_calendar WHERE ? BETWEEN startDate AND endDate";
            try (PreparedStatement psCal = conn.prepareStatement(sqlCalendar)) {
                psCal.setDate(1, proposedDate);
                try (ResultSet rsCal = psCal.executeQuery()) {
                    while (rsCal.next()) {
                        String type = rsCal.getString("eventType");
                        if ("Exam".equals(type) || "UMT Official".equals(type) || "Convo".equals(type)) {
                            viabilityScore -= 40;
                        } else if ("Public Holiday".equals(type)) {
                            viabilityScore -= 15;
                        }
                    }
                }
            }

            LocalDate propDateLocal = proposedDate.toLocalDate();
            LocalDate today = LocalDate.now();
            long daysBetween = ChronoUnit.DAYS.between(today, propDateLocal);

            if (daysBetween < 0) {
                viabilityScore -= 100;
            } else if (daysBetween < 14) {
                viabilityScore -= 30;
            } else if (daysBetween <= 30) {
                viabilityScore -= 10;
            }

            // B. Financial Checks
            double costPerPax = (pax > 0) ? budget / pax : budget;
            if (costPerPax > 80) {
                viabilityScore -= 35;
            } else if (costPerPax > 50) {
                viabilityScore -= 15;
            } else if (costPerPax < 3) {
                viabilityScore -= 10;
            }

            // C. Annual RM1000 Limit Check (SKIPPED IF NOT USING CLUB FUNDS)
            if (isClubFunded) {
                String sqlBudget = "SELECT SUM(estimateBudget) AS usedBudget FROM eventproposal WHERE clubId = ? AND Status IN ('Approved', 'Completed') AND YEAR(proposedDate) = YEAR(?)";
                double usedBudget = 0;
                try (PreparedStatement psBudget = conn.prepareStatement(sqlBudget)) {
                    psBudget.setInt(1, clubId);
                    psBudget.setDate(2, proposedDate);
                    try (ResultSet rsBudget = psBudget.executeQuery()) {
                        if (rsBudget.next()) {
                            usedBudget = rsBudget.getDouble("usedBudget");
                        }
                    }
                }

                double projectedTotal = usedBudget + budget;
                String details = (budgetDetails != null) ? budgetDetails.toLowerCase() : "";
                boolean hasSponsor = details.contains("tajaan") || details.contains("sponsor") || details.contains("sumbangan") || details.contains("yuran");

                if (projectedTotal > 1000) {
                    if (hasSponsor) {
                        viabilityScore -= 15;
                    } else {
                        viabilityScore -= 35;
                    }
                } else if (projectedTotal >= 800) {
                    viabilityScore -= 10;
                }
            }

            // D. Logistics Checks
            double paxPerDay = (duration > 0) ? (double) pax / duration : pax;
            if (paxPerDay > 300) {
                viabilityScore -= 25;
            } else if (paxPerDay > 150) {
                viabilityScore -= 10;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return Math.max(0, viabilityScore);
    }

    private String[] checkCalendarClash(String proposedDate) {
        String[] clashDetails = null;
        String sql = "SELECT eventType FROM master_calendar WHERE ? BETWEEN startDate AND endDate";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(proposedDate));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    clashDetails = new String[2];
                    clashDetails[0] = rs.getString("eventType");
                    clashDetails[1] = rs.getString("eventType");
                }
            }
        } catch (Exception e) {
        }
        return clashDetails;
    }

    // =========================================================================
    // 3. UNIFIED AI HEURISTIC ENGINE (REAL-TIME UI GENERATOR)
    // ADDED boolean isClubFunded
    // =========================================================================
    public String generateAIAssessment(int clubId, String date, int duration, int pax, double budget, String budgetDetails, boolean isClubFunded) {
        StringBuilder analysis = new StringBuilder();
        int viabilityScore = 100;

        analysis.append("<ul class='mb-3 list-unstyled' style='line-height: 1.8;'>");

        try {
            // FINANCIAL: Cost Per Pax
            double costPerPax = (pax > 0) ? budget / pax : budget;
            if (costPerPax > 80) {
                viabilityScore -= 35;
                analysis.append("<li class='mb-2'><i class='fas fa-exclamation-triangle text-danger me-2'></i><span class='text-danger'><b>Financial Risk:</b> Highly expensive (RM").append(String.format("%.2f", costPerPax)).append("/pax). Strong justification needed.</span></li>");
            } else if (costPerPax > 50) {
                viabilityScore -= 15;
                analysis.append("<li class='mb-2'><i class='fas fa-info-circle text-warning me-2'></i><span class='text-warning text-dark'><b>Financial Warning:</b> Above average cost (RM").append(String.format("%.2f", costPerPax)).append("/pax).</span></li>");
            } else if (costPerPax < 3) {
                viabilityScore -= 10;
                analysis.append("<li class='mb-2'><i class='fas fa-info-circle text-warning me-2'></i><span class='text-warning text-dark'><b>Doubtful Financials:</b> Unusually low cost (RM").append(String.format("%.2f", costPerPax)).append("/pax).</span></li>");
            } else {
                analysis.append("<li class='mb-2'><i class='fas fa-check-circle text-success me-2'></i><span class='text-success'><b>Efficient Financials:</b> Optimum spending (RM").append(String.format("%.2f", costPerPax)).append("/pax).</span></li>");
            }

            // FINANCIAL: RM 1000 Annual Limit
            if (isClubFunded) {
                try (Connection conn = DBConnection.getConnection()) {
                    String sqlBudget = "SELECT SUM(estimateBudget) AS usedBudget FROM eventproposal WHERE clubId = ? AND Status IN ('Approved', 'Completed') AND YEAR(proposedDate) = YEAR(?)";
                    double usedBudget = 0;
                    try (PreparedStatement psBudget = conn.prepareStatement(sqlBudget)) {
                        psBudget.setInt(1, clubId);
                        psBudget.setDate(2, java.sql.Date.valueOf(date));
                        try (ResultSet rsBudget = psBudget.executeQuery()) {
                            if (rsBudget.next()) {
                                usedBudget = rsBudget.getDouble("usedBudget");
                            }
                        }
                    }

                    double projectedTotal = usedBudget + budget;
                    String details = (budgetDetails != null) ? budgetDetails.toLowerCase() : "";
                    boolean hasSponsor = details.contains("tajaan") || details.contains("sponsor") || details.contains("sumbangan") || details.contains("yuran");

                    if (projectedTotal > 1000) {
                        if (hasSponsor) {
                            viabilityScore -= 15;
                            analysis.append("<li class='mb-2'><i class='fas fa-info-circle text-warning me-2'></i><span class='text-warning text-dark'><b>Annual Limit:</b> Exceeds RM 1,000 yearly limit, but external funding noted.</span></li>");
                        } else {
                            viabilityScore -= 35;
                            analysis.append("<li class='mb-2'><i class='fas fa-exclamation-triangle text-danger me-2'></i><span class='text-danger'><b>Annual Limit (CRITICAL):</b> Exceeds RM 1,000 yearly club limit with NO sponsorship listed.</span></li>");
                        }
                    } else if (projectedTotal >= 800) {
                        viabilityScore -= 10;
                        analysis.append("<li class='mb-2'><i class='fas fa-info-circle text-warning me-2'></i><span class='text-warning text-dark'><b>Annual Limit:</b> Club is nearing the maximum RM 1,000 yearly budget.</span></li>");
                    }
                } catch (Exception e) {
                }
            } else {
                analysis.append("<li class='mb-2'><i class='fas fa-check-circle text-success me-2'></i><span class='text-success'><b>Independent Funding:</b> Program does not utilize the club's annual RM 1,000 wallet.</span></li>");
            }

            // LOGISTICS
            double paxPerDay = (duration > 0) ? (double) pax / duration : pax;
            if (paxPerDay > 300) {
                viabilityScore -= 25;
                analysis.append("<li class='mb-2'><i class='fas fa-exclamation-triangle text-danger me-2'></i><span class='text-danger'><b>Logistics Risk:</b> High crowd density (").append(String.format("%.0f", paxPerDay)).append(" pax/day). Strict crowd control required.</span></li>");
            } else if (paxPerDay > 150) {
                viabilityScore -= 10;
                analysis.append("<li class='mb-2'><i class='fas fa-info-circle text-warning me-2'></i><span class='text-warning text-dark'><b>Participant Density:</b> Moderate crowd (").append(String.format("%.0f", paxPerDay)).append(" pax/day).</span></li>");
            } else {
                analysis.append("<li class='mb-2'><i class='fas fa-check-circle text-success me-2'></i><span class='text-success'><b>Controlled Logistics:</b> Daily participant capacity is well managed.</span></li>");
            }

            // TIMING
            LocalDate proposed = LocalDate.parse(date);
            LocalDate today = LocalDate.now();
            long daysBetween = ChronoUnit.DAYS.between(today, proposed);

            String[] clash = checkCalendarClash(date);
            boolean isCriticalClash = false;

            if (clash != null) {
                String eventType = clash[0];
                if ("Exam".equalsIgnoreCase(eventType) || "UMT Official".equalsIgnoreCase(eventType) || "Convo".equalsIgnoreCase(eventType)) {
                    viabilityScore -= 40;
                    isCriticalClash = true;
                    analysis.append("<li class='mb-2'><i class='fas fa-calendar-times text-danger me-2'></i><span class='text-danger'><b>Calendar Conflict:</b> Clashes with <b>").append(eventType.toUpperCase()).append("</b> week!</span></li>");
                } else if ("Public Holiday".equalsIgnoreCase(eventType)) {
                    viabilityScore -= 15;
                    analysis.append("<li class='mb-2'><i class='fas fa-calendar-day text-warning me-2'></i><span class='text-warning text-dark'><b>Public Holiday:</b> Clashes with <b>").append(eventType.toUpperCase()).append("</b>.</span></li>");
                }
            }

            if (daysBetween < 14) {
                viabilityScore -= 30;
                analysis.append("<li class='mb-2'><i class='fas fa-clock text-danger me-2'></i><span class='text-danger'><b>Timing Warning:</b> Very short notice (").append(daysBetween).append(" days).</span></li>");
            } else if (daysBetween < 30) {
                viabilityScore -= 10;
                if (!isCriticalClash) {
                    analysis.append("<li class='mb-2'><i class='fas fa-clock text-warning me-2'></i><span class='text-warning text-dark'><b>Timeline:</b> ").append(daysBetween).append(" days notice. Submit immediately.</span></li>");
                }
            } else {
                if (!isCriticalClash) {
                    analysis.append("<li class='mb-2'><i class='fas fa-check-circle text-success me-2'></i><span class='text-success'><b>Ideal Timing:</b> Excellent preparation time.</span></li>");
                }
            }

        } catch (Exception e) {
            return "<div class='alert alert-danger small border-0 shadow-sm'><i class='fas fa-times-circle me-2'></i>Invalid data format.</div>";
        }

        if (viabilityScore < 0) {
            viabilityScore = 0;
        }

        analysis.append("</ul><hr><div class='d-flex align-items-center justify-content-between'><h6 class='fw-bold mb-0'>AI Viability Index:</h6>");

        if (viabilityScore >= 75) {
            analysis.append("<div><span class='badge bg-success fs-6 shadow-sm'><i class='fas fa-check-circle me-1'></i> OPTIMUM (").append(viabilityScore).append("%)</span></div></div>");
            analysis.append("<div class='mt-3 p-3 bg-success bg-opacity-10 rounded border border-success'><small class='text-success fw-bold d-block mb-1'>AI Judgement:</small> <small class='text-dark'>HIGHLY RECOMMENDED. Clear calendar, solid planning, and budget meets specifications.</small></div>");
        } else if (viabilityScore >= 50) {
            analysis.append("<div><span class='badge bg-warning text-dark fs-6 shadow-sm'><i class='fas fa-exclamation-triangle me-1'></i> MODERATE (").append(viabilityScore).append("%)</span></div></div>");
            analysis.append("<div class='mt-3 p-3 bg-warning bg-opacity-10 rounded border border-warning'><small class='text-warning-emphasis fw-bold d-block mb-1'>AI Judgement:</small> <small class='text-dark'>PROCEED WITH CAUTION. The system detects some logistical or financial inefficiencies.</small></div>");
        } else {
            analysis.append("<div><span class='badge bg-danger fs-6 shadow-sm'><i class='fas fa-times-circle me-1'></i> BERISIKO (").append(viabilityScore).append("%)</span></div></div>");
            analysis.append("<div class='mt-3 p-3 bg-danger bg-opacity-10 rounded border border-danger'><small class='text-danger fw-bold d-block mb-1'>AI Judgement:</small> <small class='text-dark'>NOT RECOMMENDED. This proposal has critical flaws. High probability of rejection.</small></div>");
        }

        return analysis.toString();
    }

    // =========================================================================
    // 4. DYNAMIC MULTI-LLM ROUTING (GEMINI -> OPENAI -> FALLBACK)
    // =========================================================================
    public String[] getDynamicAIFeedback(String title, String date, int duration, int pax, double budget, String budgetDetails, int heuristicScore) {

        // SAFELY CALLING FROM CONFIG.JAVA
        String geminiKey = util.Config.GEMINI_API_KEY;
        String openAIKey = util.Config.OPENAI_API_KEY;

        String prompt = "You are an official AI Advisor for university student clubs. "
                + "Review this event proposal and provide a 3-sentence feedback summary. "
                + "Be honest, realistic, encouraging but professional. "
                + "Event Title: " + title + ". "
                + "Date: " + date + " (" + duration + " days). "
                + "Participants: " + pax + ". "
                + "Budget: RM " + budget + ". "
                + "Sponsorship: " + (budgetDetails.isEmpty() ? "None" : budgetDetails) + ". "
                + "System Score: " + heuristicScore + "/100. "
                + "If the score is below 50, briefly mention the financial or logistical risks."
                + "Give some suggestion on how this proposal can be better.";

        prompt = prompt.replace("\"", "'").replace("\n", " ");

// ---------------------------------------------------------
// ATTEMPT 1: GOOGLE GEMINI (Primary - Free Tier)
// ---------------------------------------------------------
        try {
            String geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=" + geminiKey;

            // =========================================================================
// REPLACE ONLY THE OLD geminiPayload ASSIGNMENT LINES WITH THIS STRUCTURE:
// =========================================================================
            String safePrompt = prompt.replace("\\", "\\\\").replace("\"", "\\\"");

            String geminiPayload = "{"
                    + "\"contents\": [{\"parts\": [{\"text\": \"" + safePrompt + "\"}]}], "
                    + "\"generationConfig\": {"
                    + "    \"thinkingConfig\": {\"thinkingBudget\": 0},"
                    + "    \"maxOutputTokens\": 150," // <-- FORCES GEMINI TO RESPOND CONCISELY (~100 WORDS MAX)
                    + "    \"temperature\": 0.3" // <-- LOWER TEMPERATURE SPEEDS UP PROCESSING FOR THE EXHIBITION
                    + "  }"
                    + "}";

            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) new java.net.URL(geminiUrl).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            try (java.io.OutputStream os = conn.getOutputStream()) {
                os.write(geminiPayload.getBytes("utf-8"));
            }

            if (conn.getResponseCode() == 200) {
                // Print how many requests you have left for the current minute
                String requestsRemaining = conn.getHeaderField("x-ratelimit-remaining-requests-per-minute");
                System.out.println("Requests remaining this minute: " + requestsRemaining);

// Print how many tokens you have left for the current minute
                String tokensRemaining = conn.getHeaderField("x-ratelimit-remaining-tokens-per-minute");
                System.out.println("Tokens remaining this minute: " + tokensRemaining);

                java.util.Scanner scanner = new java.util.Scanner(conn.getInputStream(), "UTF-8");
                String responseBody = scanner.useDelimiter("\\A").next();
                scanner.close();

                String targetKey = "\"text\": \"";
                int startIndex = responseBody.indexOf(targetKey);
                if (startIndex != -1) {
                    startIndex += targetKey.length();

                    // Fix: Find the literal end of the text string value by looking for the unescaped closing quote
                    int endIndex = -1;
                    for (int i = startIndex; i < responseBody.length(); i++) {
                        if (responseBody.charAt(i) == '"' && responseBody.charAt(i - 1) != '\\') {
                            endIndex = i;
                            break;
                        }
                    }

                    if (endIndex != -1) {
                        String cleanText = responseBody.substring(startIndex, endIndex)
                                .replace("\\n", " ")
                                .replace("\\\"", "\"");

                        // RETURN SUCCESS [Model Name, Text]
                        return new String[]{"Google Gemini", cleanText};
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Gemini attempt failed, falling back to OpenAI...");
            System.err.println("DEBUG ERROR: " + e.getMessage());
            e.printStackTrace();
        }

        // ---------------------------------------------------------
        // ATTEMPT 2: OPENAI GPT (Secondary Fallback)
        // ---------------------------------------------------------
        try {
            String openAiUrl = "https://api.openai.com/v1/chat/completions";
            String openAiPayload = "{\"model\": \"gpt-3.5-turbo\", \"messages\": [{\"role\": \"user\", \"content\": \"" + prompt + "\"}], \"temperature\": 0.7}";

            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) new java.net.URL(openAiUrl).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + openAIKey);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            try (java.io.OutputStream os = conn.getOutputStream()) {
                os.write(openAiPayload.getBytes("utf-8"));
            }

            if (conn.getResponseCode() == 200) {
                java.util.Scanner scanner = new java.util.Scanner(conn.getInputStream(), "UTF-8");
                String responseBody = scanner.useDelimiter("\\A").next();
                scanner.close();

                String targetKey = "\"content\": \"";
                int startIndex = responseBody.indexOf(targetKey) + targetKey.length();
                int endIndex = responseBody.indexOf("\"", startIndex);

                if (startIndex > targetKey.length() - 1 && endIndex > startIndex) {
                    String cleanText = responseBody.substring(startIndex, endIndex).replace("\\n", "<br>");
                    // RETURN SUCCESS [Model Name, Text]
                    return new String[]{"OpenAI GPT-3.5", cleanText};
                }
            }
        } catch (Exception e) {
            System.out.println("OpenAI attempt failed, utilizing Heuristic Fallback...");
            System.err.println("DEBUG ERROR: " + e.getMessage());
            e.printStackTrace();
        }

        // ---------------------------------------------------------
        // ATTEMPT 3: HEURISTIC SYSTEM (Final Safety Net)
        // ---------------------------------------------------------
        String fallbackText = "The system has analyzed '" + title + "'. Based on the heuristic matrix, please ensure all logistical and financial preparations adhere to university guidelines ahead of the " + duration + "-day schedule.";
        return new String[]{"System Auto-Generated", fallbackText};
    }

}
