<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Review Proposal | Advisor</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .clickable-badge {
                cursor: pointer;
                transition: transform 0.2s ease-in-out;
            }
            .clickable-badge:hover {
                transform: scale(1.05);
            }
            /* Animasi Risiko Kritikal */
            .ai-glow-danger {
                animation: pulse-glow-danger 2s infinite;
            }
            @keyframes pulse-glow-danger {
                0% {
                    box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.6);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(220, 53, 69, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(220, 53, 69, 0);
                }
            }
            /* Animasi Risiko Sederhana */
            .ai-glow-warning {
                animation: pulse-glow-warning 2s infinite;
            }
            @keyframes pulse-glow-warning {
                0% {
                    box-shadow: 0 0 0 0 rgba(255, 193, 7, 0.8);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(255, 193, 7, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(255, 193, 7, 0);
                }
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <a href="${pageContext.request.contextPath}/advisor/pending" class="btn btn-sm btn-outline-secondary mb-2 rounded-pill">
                            <i class="fas fa-arrow-left me-1"></i> Back to Pending Proposals
                        </a>
                        <h3 class="fw-bold mb-0 text-dark">Proposal Review</h3>
                    </div>
                    <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-primary rounded-pill shadow-sm" target="_blank">
                        <i class="fas fa-file-pdf me-2"></i> View Full Document
                    </a>
                </div>

                <%-- ALERT MESSAGES --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 mb-4">
                            <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                                <h5 class="fw-bold mb-0 text-primary">Program Information</h5>
                            </div>
                            <div class="card-body p-4">
                                <table class="table table-borderless mb-0">
                                    <tbody>
                                        <tr>
                                            <th class="text-muted w-25">Title</th>
                                            <td class="fw-bold fs-5">${p.title}</td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Club</th>
                                            <td><span class="badge bg-secondary">${p.clubName}</span></td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Description</th>
                                            <td>${p.description}</td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Target Date</th>
                                            <td>
                                                <i class="far fa-calendar-alt text-primary me-2"></i> 
                                                <fmt:formatDate value="${p.proposedDate}" pattern="dd MMM yyyy" />
                                                <c:if test="${not empty p.endDate}">
                                                    - <fmt:formatDate value="${p.endDate}" pattern="dd MMM yyyy" />
                                                </c:if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Participants</th>
                                            <td><i class="fas fa-users text-info me-2"></i> ${p.estimateParticipant} Pax</td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Venue</th>
                                            <td><i class="fas fa-map-marker-alt text-danger me-2"></i> ${p.venue}</td>
                                        </tr>
                                        <tr>
                                            <th class="text-muted">Budget</th>
                                            <td class="fw-bold text-success">RM <fmt:formatNumber value="${p.budget}" pattern="#,##0.00" /></td>
                                        </tr>
                                        <tr class="border-top">
                                            <th class="text-muted pt-3 align-middle"><i class="fas fa-robot text-primary me-2"></i> AI Status</th>
                                            <td class="pt-3">
                                                <c:choose>
                                                    <c:when test="${p.conflictScore >= 50}">
                                                        <span class="badge bg-danger rounded-pill px-3 py-2 shadow-sm clickable-badge ai-glow-danger" data-bs-toggle="modal" data-bs-target="#aiModal">
                                                            <i class="fas fa-brain me-1"></i> ${p.conflictScore} (Critical) - Click to View
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${p.conflictScore >= 20}">
                                                        <span class="badge bg-warning text-dark rounded-pill px-3 py-2 shadow-sm clickable-badge ai-glow-warning" data-bs-toggle="modal" data-bs-target="#aiModal">
                                                            <i class="fas fa-brain me-1"></i> ${p.conflictScore} (Moderate) - Click to View
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success rounded-pill px-3 py-2 shadow-sm clickable-badge" data-bs-toggle="modal" data-bs-target="#aiModal">
                                                            <i class="fas fa-check-circle me-1"></i> ${p.conflictScore} (Safe) - Click to View
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <%-- RIGHT SIDEBAR: Actions & Upload --%>
                    <div class="col-lg-4">
                        <div class="sticky-top" style="top: 20px; z-index: 1;">

                            <c:choose>
                                <%-- JIKA PROPOSAL MASIH PENDING_ADVISOR, TUNJUKKAN BORANG --%>
                                <c:when test="${p.status == 'Pending_Advisor'}">

                                    <%-- 1. E-RISK UPLOAD CARD --%>
                                    <div class="card border-0 shadow-sm rounded-4 border-top border-4 border-primary mb-4">
                                        <div class="card-body p-4">
                                            <h5 class="fw-bold text-primary mb-3"><i class="fas fa-shield-alt me-2"></i>Risk Assessment</h5>
                                            <p class="small text-muted mb-3">Please complete the E-Risk assessment and upload the signed document here before endorsing.</p>

                                            <c:if test="${not empty p.eriskFile}">
                                                <div class="alert alert-success py-2 d-flex align-items-center">
                                                    <i class="fas fa-check-circle me-2"></i> 
                                                    <span class="small">File: <a href="${pageContext.request.contextPath}/${p.eriskFile}" target="_blank" class="fw-bold text-success text-decoration-none">View Document</a></span>
                                                </div>
                                            </c:if>

                                            <form action="${pageContext.request.contextPath}/UploadERiskServlet" method="POST" enctype="multipart/form-data">
                                                <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                <div class="input-group input-group-sm">
                                                    <input type="file" name="eriskFile" class="form-control" accept=".pdf,.doc,.docx" required>
                                                    <button type="submit" class="btn btn-primary"><i class="fas fa-upload"></i></button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>

                                    <%-- 2. ADVISOR ACTION CARD --%>
                                    <div class="card border-0 shadow-sm rounded-4 border-top border-4 border-warning">
                                        <div class="card-header bg-white py-3 border-0">
                                            <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-clipboard-check me-2 text-warning"></i>Advisor Action</h5>
                                        </div>
                                        <div class="card-body p-4">
                                            <form action="${pageContext.request.contextPath}/advisor/review" method="POST" onsubmit="return confirm('Are you sure with your decision?');">
                                                <input type="hidden" name="proposalId" value="${p.proposalId}">

                                                <div class="mb-4">
                                                    <label class="form-label fw-bold text-muted small text-uppercase">Advisor Remarks / Feedback</label>
                                                    <textarea name="feedback" class="form-control bg-light rounded-3 border-1" rows="5" placeholder="Enter your comments or reasons here..." required></textarea>
                                                    <small class="text-muted mt-2 d-block"><i class="fas fa-info-circle me-1"></i>These comments will be read by the students and subsequent reviewers.</small>
                                                </div>

                                                <div class="d-grid gap-2 mt-4">
                                                    <%-- KUNCI BUTANG SUPPORT JIKA E-RISK BELUM DIUPLOAD --%>
                                                    <c:choose>
                                                        <c:when test="${empty p.eriskFile}">
                                                            <button type="button" class="btn btn-secondary rounded-pill py-3 shadow-sm fw-bold" onclick="alert('Please upload the E-Risk Document first!');">
                                                                <i class="fas fa-lock me-2"></i> Support Proposal (Locked)
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="submit" name="action" value="approve" class="btn btn-success rounded-pill py-3 shadow-sm fw-bold">
                                                                <i class="fas fa-check-circle me-2"></i> Support Proposal
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <button type="submit" name="action" value="reject" class="btn btn-outline-danger rounded-pill py-2 fw-bold mt-2">
                                                        <i class="fas fa-times-circle me-2"></i> Return / Reject
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:when>

                                <%-- JIKA PROPOSAL SUDAH DIPROSES, TUNJUK READ-ONLY --%>
                                <c:otherwise>
                                    <div class="card border-0 shadow-sm rounded-4 border-top border-4 border-secondary">
                                        <div class="card-body p-4 text-center">
                                            <i class="fas fa-lock fa-3x text-muted mb-3 opacity-50"></i>
                                            <h5 class="fw-bold text-dark">Action Completed</h5>
                                            <p class="text-muted small">You have already reviewed this proposal. Current status is <strong>${p.status}</strong>.</p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%-- AI MODAL --%>
        <div class="modal fade text-start" id="aiModal" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-dark text-white border-0">
                        <h5 class="modal-title fw-bold"><i class="fas fa-robot me-2 text-warning"></i>AI Risk Analysis</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4 bg-light">
                        <div class="text-center mb-4 border-bottom pb-4">
                            <h6 class="text-muted text-uppercase fw-bold" style="letter-spacing: 1px;">Overall Conflict Score</h6>
                            <h1 class="display-1 fw-bold mb-0 
                                <c:choose>
                                    <c:when test='${p.conflictScore >= 50}'>text-danger</c:when>
                                    <c:when test='${p.conflictScore >= 20}'>text-warning</c:when>
                                    <c:otherwise>text-success</c:otherwise>
                                </c:choose>
                                ">${p.conflictScore}</h1>
                            <p class="text-muted mt-2">Points (Lower is better)</p>
                        </div>

                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body p-4">
                                <h6 class="fw-bold text-primary mb-3"><i class="fas fa-chart-line me-2"></i>Detailed System Breakdown</h6>

                                <c:choose>
                                    <c:when test="${not empty p.aiSuggestion}">
                                        ${p.aiSuggestion}
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-secondary border-0 text-center mb-0">
                                            <i class="fas fa-exclamation-circle mb-2 fa-2x text-muted d-block"></i>
                                            Maklumat heuristik terperinci tidak dapat ditarik.<br>Sila pastikan Enjin AI berjalan dengan betul.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 bg-light">
                        <button type="button" class="btn btn-secondary rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>