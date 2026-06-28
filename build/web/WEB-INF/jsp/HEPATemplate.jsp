<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Working Paper: ${p.title}</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            body {
                background-color: #525659;
                margin: 0;
                padding: 40px 0;
                font-family: 'Times New Roman', Times, serif;
                font-size: 12pt;
                line-height: 1.6;
                color: #000;
            }
            .a4-page {
                width: 210mm;
                min-height: 297mm;
                margin: 0 auto;
                padding: 25mm 20mm;
                background: #fff;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
                box-sizing: border-box;
                position: relative;
            }
            .header-section {
                text-align: center;
                margin-bottom: 30px;
                border-bottom: 3px double #000;
                padding-bottom: 20px;
            }
            .logo {
                width: 110px;
                height: auto;
                margin-bottom: 15px;
            }
            .doc-title {
                font-size: 16pt;
                font-weight: bold;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin: 5px 0;
            }
            .doc-subtitle {
                font-size: 12pt;
                font-weight: bold;
                color: #333;
            }
            .doc-ref {
                text-align: right;
                font-size: 10pt;
                font-style: italic;
                margin-bottom: 20px;
            }
            .section-title {
                font-size: 12pt;
                font-weight: bold;
                text-transform: uppercase;
                margin-top: 30px;
                margin-bottom: 15px;
                padding-bottom: 5px;
                border-bottom: 1px solid #ddd;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            th, td {
                border: 1px solid #000;
                padding: 8px 12px;
                vertical-align: top;
            }
            th {
                background-color: #f4f4f4;
                text-align: left;
                font-weight: bold;
            }
            .text-justify {
                text-align: justify;
            }
            .text-center {
                text-align: center;
            }
            .text-right {
                text-align: right;
            }
            .text-uppercase {
                text-transform: uppercase;
            }
            .fw-bold {
                font-weight: bold;
            }
            .signature-box {
                margin-top: 50px;
                width: 100%;
                display: table;
                page-break-inside: avoid;
            }
            .sign-col {
                display: table-cell;
                width: 25%;
                text-align: center;
                vertical-align: bottom;
                padding: 0 10px;
            }
            .sign-line {
                margin-top: 80px;
                border-top: 1px solid #000;
                padding-top: 8px;
                font-size: 10pt;
                line-height: 1.4;
            }
            .watermark-status {
                position: absolute;
                top: 40%;
                left: 50%;
                transform: translate(-50%, -50%) rotate(-45deg);
                font-size: 80pt;
                font-weight: bold;
                color: rgba(0, 150, 0, 0.08);
                z-index: 0;
                white-space: nowrap;
                pointer-events: none;
            }
            .doc-footer {
                margin-top: 50px;
                text-align: center;
                font-size: 9pt;
                color: #555;
                border-top: 1px dashed #aaa;
                padding-top: 15px;
            }
            .floating-action {
                position: fixed;
                bottom: 30px;
                right: 30px;
                background: #fff;
                padding: 10px 15px;
                border-radius: 50px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                display: flex;
                gap: 10px;
                z-index: 1000;
                font-family: Arial, sans-serif;
            }
            .btn-action {
                border: none;
                padding: 10px 20px;
                border-radius: 30px;
                font-weight: bold;
                font-size: 14px;
                cursor: pointer;
                transition: 0.2s;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .btn-print {
                background-color: #212529;
                color: white;
            }
            .btn-print:hover {
                background-color: #424649;
            }
            .btn-download {
                background-color: #dc3545;
                color: white;
            }
            .btn-download:hover {
                background-color: #b02a37;
            }

            @media print {
                .no-print {
                    display: none !important;
                }
                body {
                    background: transparent;
                    padding: 0;
                    margin: 0;
                }
                .a4-page {
                    width: 100%;
                    min-height: auto;
                    margin: 0;
                    padding: 0;
                    box-shadow: none;
                    background: transparent;
                }
                th {
                    background-color: #f4f4f4 !important;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                .watermark-status {
                    color: rgba(0, 150, 0, 0.08) !important;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                @page {
                    size: A4;
                    margin: 20mm;
                }
            }
        </style>
    </head>
    <body>

        <div class="floating-action no-print">
            <button class="btn-action btn-print" onclick="window.print()">
                <i class="fas fa-print"></i> Print
            </button>
            <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" target="_blank" class="btn-action btn-download" style="text-decoration:none;">
                <i class="fas fa-file-pdf"></i> Save as PDF
            </a>
        </div>

        <div class="a4-page">

            <c:if test="${p.status == 'Approved'}">
                <div class="watermark-status">ENDORSED</div>
            </c:if>

            <div class="header-section">
                <img src="${pageContext.request.contextPath}/images/Logo_Rasmi_UMT.png" alt="UMT Logo" class="logo">
                <div class="doc-title">Program Proposal Working Paper</div>
                <div class="doc-subtitle">Student Affairs and Alumni (HEPA)<br>Universiti Malaysia Terengganu</div>
            </div>

            <div class="doc-ref">
                Ref. No: UMT/CS/2026/PRO-${p.proposalId}
            </div>

            <div class="section-title">1.0 Program Details</div>
            <table>
                <tr>
                    <th style="width: 35%;">Club / Association Name</th>
                    <td class="fw-bold">${p.clubName} <span style="font-weight:normal; font-style:italic;">(${clubCategory})</span></td>
                </tr>
                <tr>
                    <th>Program Title</th>
                    <td class="fw-bold text-uppercase">${p.title}</td>
                </tr>
                <tr>
                    <th>Proposed Date</th>
                    <td><fmt:formatDate value="${p.proposedDate}" pattern="dd MMMM yyyy" /></td>
                </tr>
                <tr>
                    <th>Venue / Location</th>
                    <td>${p.venue}</td>
                </tr>
                <tr>
                    <th>Target Audience</th>
                    <td>${p.targetAudience}</td>
                </tr>
                <tr>
                    <th>Estimated Participants</th>
                    <td>${p.estimateParticipant} Pax</td>
                </tr>
            </table>

            <div class="section-title">2.0 Executive Summary</div>
            <p class="text-justify">${p.description}</p>

            <div class="section-title">3.0 Program Objectives & Impacts</div>
            <p class="fw-bold mb-1">Objectives:</p>
            <p class="text-justify" style="white-space: pre-wrap;">${p.objective}</p>
            <p class="fw-bold mb-1 mt-3">Impact on SDG:</p>
            <p class="text-justify">${p.sdgImpact}</p>
            <p class="text-justify">${p.sdgReason}</p>

            <div class="section-title">4.0 Tentative Program</div>
            <table>
                <tr>
                    <th style="width: 20%;">Day</th>
                    <th style="width: 20%;">Time</th>
                    <th>Activity</th>
                </tr>
                <c:forEach var="itin" items="${p.itineraries}">
                    <tr>
                        <td>${itin.day}</td>
                        <td>${itin.time}</td>
                        <td>${itin.activity}</td>
                    </tr>
                </c:forEach>
            </table>

            <div class="section-title">5.0 Committee Members</div>
            <table>
                <tr>
                    <th style="width: 25%;">No. Matrik</th>
                    <th style="width: 40%;">Full Name</th>
                    <th style="width: 35%;">Role</th>
                </tr>
                <c:forEach var="c" items="${p.committees}">
                    <tr>
                        <td>${c.matricNo}</td>
                        <td>${c.name}</td>
                        <td>${c.role}</td>
                    </tr>
                </c:forEach>
            </table>

            <div class="section-title">6.0 Financial Implications</div>
            <table>
                <tr>
                    <th style="width: 45%;">Item / Description</th>
                    <th style="width: 15%; text-align: center;">Qty</th>
                    <th style="width: 20%; text-align: center;">Unit Price (RM)</th>
                    <th style="width: 20%; text-align: right;">Total (RM)</th>
                </tr>
                <c:forEach var="b" items="${p.budgets}">
                    <tr>
                        <td>${b.itemName}</td>
                        <td class="text-center">${b.quantity}</td>
                        <td class="text-center"><fmt:formatNumber value="${b.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                        <td class="text-right"><fmt:formatNumber value="${b.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                    </tr>
                </c:forEach>
                <tr>
                    <td colspan="3" class="fw-bold text-right">GRAND TOTAL</td>
                    <td class="fw-bold text-right" style="color: #006600;">RM <fmt:formatNumber value="${p.estimateBudget}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                </tr>
            </table>

            <div class="section-title">7.0 Official Approval Status</div>
            <table>
                <tr>
                    <th style="width: 35%;">Current System Status</th>
                    <td class="fw-bold text-uppercase">${p.status}</td>
                </tr>
                <tr>
                    <th>Club Advisor Remarks</th>
                    <td>Reviewed and supported.</td>
                </tr>

                <c:choose>
                    <c:when test="${clubCategory == 'Academic'}">
                        <tr>
                            <th>Faculty Remarks</th>
                            <td>Academic content verified and endorsed.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <th>MPP Remarks</th>
                            <td>Proposal reviewed and supported.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>

                <tr>
                    <th>Final HEPA Remarks</th>
                    <td style="font-style: italic;">
                        ${not empty p.feedback ? p.feedback : 'Pending final clearance or approved seamlessly by HEPA management.'}
                    </td>
                </tr>
            </table>

            <%-- 4 COLUMN SIGNATURE BLOCK --%>
            <div class="signature-box">
                <div class="sign-col">
                    <p style="margin-bottom: 50px;">Prepared by:</p>
                    <div class="sign-line">
                        <strong class="text-uppercase" style="font-size: 11pt;">${not empty p.createdBy ? p.createdBy : 'STUDENT REP'}</strong><br>
                        <span style="font-size: 10pt; color: #333;">Program Director</span><br>
                        <span style="font-size: 9pt; color: #666;">${p.clubName}</span>
                    </div>
                </div>

                <div class="sign-col">
                    <p style="margin-bottom: 50px;">Reviewed by:</p>
                    <div class="sign-line">
                        <c:choose>
                            <c:when test="${p.status == 'Pending_Advisor' || p.status == 'Draft'}">
                                <span style="color: #999; font-style: italic;">(Pending Review)</span><br>
                            </c:when>
                            <c:otherwise>
                                <strong class="text-uppercase" style="font-size: 11pt;">CLUB ADVISOR</strong><br>
                                <em style="font-size: 8pt; color: #006600;">(Digitally Reviewed)</em><br>
                            </c:otherwise>
                        </c:choose>
                        <span style="font-size: 10pt; color: #333;">Club Advisor</span><br>
                        <span style="font-size: 9pt; color: #666;">Universiti Malaysia Terengganu</span>
                    </div>
                </div>

                <div class="sign-col">
                    <p style="margin-bottom: 50px;">Verified by:</p>
                    <div class="sign-line">
                        <c:choose>
                            <c:when test="${p.status == 'Pending_Advisor' || p.status == 'Pending_Faculty' || p.status == 'Pending_MPP' || p.status == 'Draft'}">
                                <span style="color: #999; font-style: italic;">(Pending Verification)</span><br>
                                <span style="font-size: 10pt; color: #333;">
                                    <c:if test="${clubCategory == 'Academic'}">Faculty Management</c:if>
                                    <c:if test="${clubCategory != 'Academic'}">MPP Representative</c:if>
                                    </span>
                            </c:when>
                            <c:otherwise>
                                <strong class="text-uppercase" style="font-size: 11pt;">
                                    <c:if test="${clubCategory == 'Academic'}">FACULTY DEAN</c:if>
                                    <c:if test="${clubCategory != 'Academic'}">MPP UMT</c:if>
                                    </strong><br>
                                    <em style="font-size: 8pt; color: #006600;">(Digitally Verified)</em><br>
                                    <span style="font-size: 9pt; color: #666;">Universiti Malaysia Terengganu</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="sign-col">
                    <p style="margin-bottom: 50px;">Endorsed by:</p>
                    <div class="sign-line">
                        <c:choose>
                            <c:when test="${p.status == 'Approved'}">
                                <strong class="text-uppercase" style="font-size: 11pt;">Executive Management</strong><br>
                                <em style="font-size: 8pt; color: #006600;">(Digitally Endorsed)</em><br>
                                <span style="font-size: 10pt; color: #333;">Student Affairs (HEPA)</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #999; font-style: italic;">(Pending Final Endorsement)</span><br>
                                <span style="font-size: 10pt; color: #333;">Student Affairs (HEPA)</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="doc-footer">
                This document is auto-generated by the UMT ClubSphere System on <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date())%>.<br>
                Physical signatures are not required for digitally endorsed working papers.
            </div>

        </div> 

        <script>
            function downloadPDF() {
                alert("Tip: In the Print window that appears, change the 'Destination/Printer' option to 'Save as PDF'.\n\nOr you can use the red 'Save as PDF' button for the official PDF file from the server.");
                window.print();
            }
        </script>
    </body>
</html>