<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Review Proposal | Advisor</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            body {
                background-color: #f4f6f9;
                font-family: 'Segoe UI', system-ui, sans-serif;
            }

            /* --- BENTO STYLING --- */
            .bento-card {
                background: white;
                border-radius: 20px;
                border: 1px solid rgba(0,0,0,0.05);
                box-shadow: 0 10px 30px rgba(0,0,0,0.02);
                overflow: hidden;
            }

            .clickable-card {
                cursor: pointer;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            .clickable-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(0,0,0,0.08);
            }

            /* --- AI ANIMATIONS --- */
            .ai-glow-danger {
                animation: pulse-glow-danger 2s infinite;
            }
            @keyframes pulse-glow-danger {
                0% {
                    box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.4);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(220, 53, 69, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(220, 53, 69, 0);
                }
            }

            .ai-glow-warning {
                animation: pulse-glow-warning 2s infinite;
            }
            @keyframes pulse-glow-warning {
                0% {
                    box-shadow: 0 0 0 0 rgba(255, 193, 7, 0.5);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(255, 193, 7, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(255, 193, 7, 0);
                }
            }

            .info-label {
                font-size: 0.75rem;
                text-transform: uppercase;
                font-weight: 700;
                color: #94a3b8;
                letter-spacing: 0.5px;
            }
            .info-value {
                font-size: 1.05rem;
                font-weight: 600;
                color: #1e293b;
            }

            .content-text {
                white-space: pre-wrap;
                color: #334155;
                line-height: 1.7;
                font-size: 0.95rem;
            }

            .section-title {
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: #64748b;
                font-weight: 700;
                margin-top: 2rem;
                margin-bottom: 1rem;
                border-bottom: 2px solid #f1f5f9;
                padding-bottom: 0.5rem;
            }
            .section-title:first-child {
                margin-top: 0;
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-2 px-lg-3">

                <%-- TOP NAVIGATION --%>
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <a href="${pageContext.request.contextPath}/advisor/pending" class="btn btn-sm btn-light text-muted fw-bold rounded-pill mb-2 shadow-sm border">
                            <i class="fas fa-arrow-left me-1"></i> Back to Pending Directory
                        </a>
                        <h3 class="fw-bold mb-0 text-dark"><i class="fas fa-file-signature text-primary me-2"></i>Proposal Endorsement</h3>
                    </div>
                    <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-primary rounded-pill shadow-sm fw-bold px-4" target="_blank">
                        <i class="fas fa-file-pdf me-2"></i> View Official PDF
                    </a>
                </div>

                <%-- ALERTS --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible shadow-sm rounded-4 border-0 mb-4">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible shadow-sm rounded-4 border-0 mb-4">
                        <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="row g-4">
                    <%-- LEFT COLUMN: PROPOSAL DETAILS --%>
                    <div class="col-lg-8">
                        <div class="bento-card mb-4">
                            <div class="card-header bg-white py-4 border-bottom d-flex align-items-center">
                                <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px;">
                                    <i class="fas fa-clipboard-list fa-lg"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1 text-dark">${p.title}</h5>
                                    <span class="badge bg-light text-dark border"><i class="fas fa-hashtag me-1 text-muted"></i>ID: ${p.proposalId}</span>
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle ms-1"><i class="fas fa-users me-1"></i>${p.clubName}</span>
                                </div>
                            </div>

                            <div class="card-body p-4 p-md-5">
                                <div class="row g-4 mb-4 border-bottom pb-4">
                                    <div class="col-md-6">
                                        <div class="info-label mb-1">Target Date</div>
                                        <div class="info-value d-flex align-items-center">
                                            <i class="far fa-calendar-alt text-primary me-2 fs-5"></i> 
                                            <fmt:formatDate value="${p.proposedDate}" pattern="dd MMM yyyy" />
                                            <c:if test="${not empty p.endDate}">
                                                <span class="mx-2 text-muted">-</span> <fmt:formatDate value="${p.endDate}" pattern="dd MMM yyyy" />
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-label mb-1">Event Venue</div>
                                        <div class="info-value d-flex align-items-center">
                                            <i class="fas fa-map-marker-alt text-danger me-2 fs-5"></i> ${p.venue}
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-label mb-1">Target Audience</div>
                                        <div class="info-value d-flex align-items-center">
                                            <i class="fas fa-users text-info me-2 fs-5"></i> ${p.targetAudience} (${p.estimateParticipant} Pax)
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-label mb-1">Requested Budget</div>
                                        <div class="info-value d-flex align-items-center text-success">
                                            <i class="fas fa-wallet me-2 fs-5"></i> RM <fmt:formatNumber value="${p.estimateBudget}" pattern="#,##0.00" />
                                        </div>
                                    </div>
                                </div>

                                <div class="section-title">Executive Summary</div>
                                <div class="p-4 bg-light rounded-4 border-start border-4 border-primary content-text mb-4">${p.description}</div>

                                <div class="section-title">Program Objectives</div>
                                <div class="content-text p-4 bg-light rounded-4 mb-4">${p.objective}</div>

                                <div class="section-title">Sustainable Development Goals (SDGs)</div>
                                <textarea id="rawSdgImpact" class="d-none">${p.sdgImpact}</textarea>
                                <textarea id="rawSdgReason" class="d-none">${p.sdgReason}</textarea>
                                <div id="sdgView" class="mb-2"></div>
                            </div>
                        </div>

                        <%-- CARD 2: 3NF Tables --%>
                        <div class="bento-card mb-4">
                            <div class="card-header bg-white py-4 border-bottom">
                                <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-layer-group text-primary me-2"></i>Detailed Planning</h5>
                            </div>
                            <div class="card-body p-4 p-md-5">

                                <div class="section-title mt-0">Committee Members</div>
                                <div class="table-responsive mb-5 border rounded-4 overflow-hidden">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr><th class="ps-4">Matric No.</th><th>Name</th><th>Role</th></tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${p.committees}">
                                                <tr><td class="ps-4 fw-bold text-secondary">${c.matricNo}</td><td class="fw-bold">${c.name}</td><td><span class="badge bg-secondary bg-opacity-10 text-dark">${c.role}</span></td></tr>
                                                    </c:forEach>
                                                    <c:if test="${empty p.committees}">
                                                <tr><td colspan="3" class="text-center text-muted fst-italic py-4">No committee members listed.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="section-title">Tentative Schedule</div>
                                <div class="table-responsive mb-5 border rounded-4 overflow-hidden">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr><th width="20%" class="ps-4">Day</th><th width="20%">Time</th><th>Activity</th></tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="itin" items="${p.itineraries}">
                                                <tr><td class="ps-4 fw-bold text-primary">${itin.day}</td><td class="fw-bold text-secondary">${itin.time}</td><td>${itin.activity}</td></tr>
                                                    </c:forEach>
                                                    <c:if test="${empty p.itineraries}">
                                                <tr><td colspan="3" class="text-center text-muted fst-italic py-4">No itinerary provided.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="section-title">Financial Implications</div>
                                <div class="table-responsive border rounded-4 overflow-hidden">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr><th class="ps-4">Item / Description</th><th class="text-center">Qty</th><th class="text-end">Unit Price (RM)</th><th class="text-end pe-4">Total (RM)</th></tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="b" items="${p.budgets}">
                                                <tr>
                                                    <td class="ps-4 fw-bold">${b.itemName}</td>
                                                    <td class="text-center">${b.quantity}</td>
                                                    <td class="text-end text-muted"><fmt:formatNumber value="${b.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                                    <td class="text-end pe-4 fw-bold text-success"><fmt:formatNumber value="${b.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty p.budgets}">
                                                <tr><td colspan="4" class="text-center text-muted fst-italic py-4">No budget details provided.</td></tr>
                                            </c:if>
                                        </tbody>
                                        <tfoot class="bg-light border-top border-2">
                                            <tr>
                                                <th colspan="3" class="text-end py-3 text-uppercase text-muted">Grand Total (RM)</th>
                                                <th class="text-end text-success fs-5 py-3 pe-4"><fmt:formatNumber value="${p.estimateBudget}" type="number" minFractionDigits="2" maxFractionDigits="2"/></th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                                <%-- SPONSORSHIP & FUNDING HIGHLIGHT --%>
                                <c:if test="${not empty p.budgetDetails}">
                                    <div class="mt-4 p-4 bg-success bg-opacity-10 border border-success border-opacity-25 rounded-4 fade-in-up">
                                        <h6 class="fw-bold text-success mb-2"><i class="fas fa-hand-holding-usd me-2"></i>Sponsorship & External Funding</h6>
                                        <p class="mb-0 text-dark small content-text">${p.budgetDetails}</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <%-- RIGHT COLUMN: AI & ACTIONS --%>
                    <div class="col-lg-4">
                        <div class="sticky-top" style="top: 20px; z-index: 1;">

                            <%-- THE TARGET DASHBOARD CARD (NATIVE JSP NO JS) --%>
                            <c:choose>
                                <c:when test="${p.conflictScore >= 75}">
                                    <c:set var="aiCard" value="border-success bg-success bg-opacity-10"/>
                                    <c:set var="aiText" value="text-success"/>
                                    <c:set var="aiStatus" value="OPTIMUM"/>
                                    <c:set var="aiIcon" value="fa-check-circle"/>
                                    <c:set var="aiAnim" value=""/>
                                </c:when>
                                <c:when test="${p.conflictScore >= 50}">
                                    <c:set var="aiCard" value="border-warning bg-warning bg-opacity-10"/>
                                    <c:set var="aiText" value="text-warning-emphasis"/>
                                    <c:set var="aiStatus" value="MODERATE RISK"/>
                                    <c:set var="aiIcon" value="fa-exclamation-triangle"/>
                                    <c:set var="aiAnim" value="ai-glow-warning"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="aiCard" value="border-danger bg-danger bg-opacity-10"/>
                                    <c:set var="aiText" value="text-danger"/>
                                    <c:set var="aiStatus" value="HIGH RISK"/>
                                    <c:set var="aiIcon" value="fa-times-circle"/>
                                    <c:set var="aiAnim" value="ai-glow-danger"/>
                                </c:otherwise>
                            </c:choose>

                            <div class="bento-card mb-4 border border-2 ${aiCard} ${aiAnim} clickable-card" data-bs-toggle="modal" data-bs-target="#aiModal" title="Click to view full analysis">
                                <div class="card-body p-4 text-center">
                                    <div class="text-uppercase small fw-bold text-muted mb-2"><i class="fas fa-robot me-1"></i> AI Viability Score</div>
                                    <h1 class="display-3 fw-bold mb-0 ${aiText}">${p.conflictScore}%</h1>
                                    <div class="badge ${aiText.replace('text-', 'bg-')} ${aiText == 'text-warning-emphasis' ? 'text-dark' : ''} rounded-pill px-3 py-2 mt-2 fw-bold">
                                        <i class="fas ${aiIcon} me-1"></i> ${aiStatus}
                                    </div>
                                    <div class="small text-muted mt-3 text-decoration-underline">Click to view detailed insights</div>
                                </div>
                            </div>

                            <c:choose>
                                <%-- IF PROPOSAL IS PENDING ADVISOR, SHOW ACTION FORMS --%>
                                <c:when test="${p.status == 'Pending_Advisor'}">

                                    <%-- 2. E-RISK UPLOAD CARD --%>
                                    <div class="bento-card mb-4">
                                        <div class="card-body p-4">
                                            <h6 class="fw-bold text-primary mb-3"><i class="fas fa-shield-alt me-2"></i>E-Risk Assessment</h6>
                                            <p class="small text-muted mb-3">Please upload the completed E-Risk safety document before endorsing this program.</p>

                                            <c:if test="${not empty p.eriskFile}">
                                                <div class="alert alert-success py-2 px-3 d-flex justify-content-between align-items-center mb-3 border-0">
                                                    <span class="small fw-bold"><i class="fas fa-check-circle me-1"></i> File Uploaded</span>
                                                    <a href="${pageContext.request.contextPath}/${p.eriskFile}" target="_blank" class="btn btn-sm btn-success rounded-pill px-3 fw-bold">View</a>
                                                </div>
                                            </c:if>

                                            <form action="${pageContext.request.contextPath}/UploadERiskServlet" method="POST" enctype="multipart/form-data">
                                                <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                <div class="input-group input-group-sm">
                                                    <input type="file" name="eriskFile" class="form-control border-primary" accept=".pdf,.doc,.docx" required>
                                                    <button type="submit" class="btn btn-primary px-3 fw-bold">Upload</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>

                                    <%-- 3. ADVISOR ACTION CARD --%>
                                    <div class="bento-card">
                                        <div class="card-header bg-white py-3 border-0">
                                            <h6 class="fw-bold mb-0 text-dark"><i class="fas fa-clipboard-check me-2 text-warning"></i>Official Endorsement</h6>
                                        </div>
                                        <div class="card-body px-4 pb-4 pt-0">
                                            <form action="${pageContext.request.contextPath}/advisor/review" method="POST" onsubmit="return confirm('Are you sure you want to proceed with this decision?');">
                                                <input type="hidden" name="proposalId" value="${p.proposalId}">

                                                <div class="mb-4">
                                                    <label class="form-label fw-bold text-muted small text-uppercase">Advisor Remarks</label>
                                                    <textarea name="feedback" class="form-control bg-light rounded-4 border-0 p-3 shadow-none" rows="4" placeholder="Enter instructions or feedback for the students..." required></textarea>
                                                </div>

                                                <div class="d-grid gap-2">
                                                    <%-- LOCK SUPPORT BUTTON IF E-RISK IS MISSING --%>
                                                    <c:choose>
                                                        <c:when test="${empty p.eriskFile}">
                                                            <button type="button" class="btn btn-light text-muted rounded-pill py-2 shadow-sm fw-bold border" onclick="alert('Please upload the E-Risk Document first!');">
                                                                <i class="fas fa-lock me-2"></i> Endorse (Requires E-Risk)
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="submit" name="action" value="approve" class="btn btn-success rounded-pill py-2 shadow-sm fw-bold">
                                                                <i class="fas fa-check-circle me-2"></i> Endorse & Forward
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <button type="submit" name="action" value="reject" class="btn btn-danger text-white rounded-pill py-2 fw-bold mt-2 shadow-sm w-100">
                                                        <i class="fas fa-undo me-2"></i> Return to Student
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:when>

                                <%-- IF PROPOSAL ALREADY REVIEWED, SHOW LOCK --%>
                                <c:otherwise>
                                    <div class="bento-card border-top border-4 border-secondary">
                                        <div class="card-body p-4 text-center">
                                            <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px;">
                                                <i class="fas fa-lock fa-2x text-muted opacity-50"></i>
                                            </div>
                                            <h5 class="fw-bold text-dark">Action Completed</h5>
                                            <p class="text-muted small mb-0">You have already processed this proposal. It is currently locked in status: <strong class="text-primary">${p.status}</strong>.</p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>

                </div>
            </div>
        </div>

        <%-- AI MODAL: FULL HEURISTIC BREAKDOWN --%>
        <div class="modal fade text-start" id="aiModal" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="modal-header bg-dark text-white border-0 p-4">
                        <h5 class="modal-title fw-bold"><i class="fas fa-microchip me-2 text-warning"></i> AI Viability Analysis</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-0 bg-light">
                        <div class="p-4 p-md-5" id="ai-modal-content">
                            <c:choose>
                                <c:when test="${not empty p.aiSuggestion}">
                                    ${p.aiSuggestion}
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-secondary border-0 text-center mb-0 p-5 rounded-4 shadow-sm">
                                        <i class="fas fa-database mb-3 fa-3x text-muted opacity-50 d-block"></i>
                                        <h5 class="fw-bold text-dark">No Data Found</h5>
                                        <p class="text-muted mb-0">The heuristic insights could not be retrieved from the database.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                   
                    
                    <div class="modal-footer border-0 bg-white p-4">
                        <button type="button" class="btn btn-secondary rounded-pill px-5 fw-bold" data-bs-dismiss="modal">Acknowledge</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                // ==========================================
                                                                // Render Dynamic Multiple SDGs
                                                                // ==========================================
                                                                function renderSDGs() {
                                                                    const impactRaw = document.getElementById('rawSdgImpact')?.value || "";
                                                                    const reasonRaw = document.getElementById('rawSdgReason')?.value || "";
                                                                    const container = document.getElementById('sdgView');

                                                                    if (container) {
                                                                        if (!reasonRaw.trim() && !impactRaw.trim()) {
                                                                            container.innerHTML = '<p class="text-muted fst-italic">No SDGs specified.</p>';
                                                                        } else {
                                                                            let html = '<div class="d-flex flex-column gap-3">';

                                                                            if (reasonRaw.includes(' ^ ')) {
                                                                                let reasonsArray = reasonRaw.split(' ||| ');
                                                                                reasonsArray.forEach(reasonCombo => {
                                                                                    let parts = reasonCombo.split(' ^ ');
                                                                                    if (parts.length >= 2) {
                                                                                        let title = parts[0].trim();
                                                                                        let desc = parts.slice(1).join(' ^ ').trim();
                                                                                        html += '<div class="p-3 bg-white border rounded-4 shadow-sm">' +
                                                                                                '<span class="badge bg-primary mb-2 fs-6"><i class="fas fa-bullseye me-1"></i> ' + title + '</span>' +
                                                                                                '<p class="mb-0 text-dark small content-text mt-2">' + desc + '</p></div>';
                                                                                    }
                                                                                });
                                                                            } else {
                                                                                let cleanSdg = impactRaw.replace(/\[|\]|"/g, '').trim();
                                                                                html += '<div class="p-3 bg-white border rounded-4 shadow-sm">' +
                                                                                        '<span class="badge bg-primary mb-2 fs-6"><i class="fas fa-bullseye me-1"></i> ' + (cleanSdg || 'SDG Impact') + '</span>' +
                                                                                        '<p class="mb-0 text-dark small content-text mt-2">' + reasonRaw + '</p></div>';
                                                                            }
                                                                            html += '</div>';
                                                                            container.innerHTML = html;
                                                                        }
                                                                    }
                                                                }

                                                                document.addEventListener('DOMContentLoaded', function () {
                                                                    renderSDGs();
                                                                });
        </script>
    </body>
</html>