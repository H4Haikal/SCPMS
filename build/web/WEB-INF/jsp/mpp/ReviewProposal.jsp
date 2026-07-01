<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Review Proposals - UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .table-row {
                transition: all 0.3s ease;
            }
            .hidden-row {
                display: none !important;
            }
            .clickable-title {
                cursor: pointer;
                text-decoration: underline;
                text-decoration-color: transparent;
                transition: 0.3s;
            }
            .clickable-title:hover {
                text-decoration-color: #0d6efd;
                color: #0a58ca !important;
            }
            .clickable-badge {
                cursor: pointer;
                transition: transform 0.2s;
            }
            .clickable-badge:hover {
                transform: scale(1.1);
            }
            .ai-glow {
                animation: pulse-glow 2s infinite;
            }
            @keyframes pulse-glow {
                0% {
                    box-shadow: 0 0 0 0 rgba(13, 110, 253, 0.4);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(13, 110, 253, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(13, 110, 253, 0);
                }
            }
            .cursor-pointer {
                cursor: pointer;
                user-select: none;
            }
            .cursor-pointer:hover {
                background-color: rgba(255,255,255,0.1) !important;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="top-header mb-4 d-flex align-items-center">
                <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                    <i class="fas fa-bars fa-lg"></i>
                </button>
                <div>
                    <h3 class="fw-bold mb-0"><i class="fas fa-file-signature text-primary me-2"></i>Proposal Approvals</h3>
                    <p class="text-muted mt-1">Review, analyze, and schedule pitching for program applications.</p>
                </div>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible shadow-sm" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible shadow-sm" role="alert">
                    <i class="fas fa-info-circle me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <ul class="nav nav-pills" id="filterTabs">
                    <li class="nav-item"><button class="nav-link active px-4 fw-bold" onclick="filterTable('all', this)">All Proposals</button></li>
                    <li class="nav-item"><button class="nav-link px-4 fw-bold text-warning" onclick="filterTable('pending', this)">Pending / Scheduled</button></li>
                    <li class="nav-item"><button class="nav-link px-4 fw-bold text-success" onclick="filterTable('processed', this)">Processed</button></li>
                </ul>

                <div>
                    <button class="btn btn-outline-success shadow-sm fw-bold me-2" onclick="exportTableToCSV('Proposals_Report.csv')">
                        <i class="fas fa-file-csv me-1"></i> Export Data
                    </button>
<!--                    <button class="btn btn-primary shadow-sm fw-bold" id="bulkApproveBtn" disabled data-bs-toggle="modal" data-bs-target="#bulkApproveModal">
                        <i class="fas fa-check-double me-1"></i> Bulk Approve (<span id="bulkCountDisplay">0</span>)
                    </button>-->
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="proposalsTable">
                            <thead class="table-dark">
                                <tr>
<!--                                    <th class="ps-4 py-3" style="width: 50px;">
                                        <input class="form-check-input shadow-sm cursor-pointer" type="checkbox" id="selectAll" onclick="toggleAllCheckboxes(this)">
                                    </th>-->
                                    <th class="cursor-pointer" onclick="sortTable(1, 'string')">Club Name <i class="fas fa-sort text-muted ms-1"></i></th>
                                    <th class="cursor-pointer" onclick="sortTable(2, 'string')">Program Title <i class="fas fa-sort text-muted ms-1"></i></th>
                                    <th class="cursor-pointer" onclick="sortTable(3, 'number')">Budget (RM) <i class="fas fa-sort text-muted ms-1"></i></th>
                                    <th class="text-center cursor-pointer" onclick="sortTable(4, 'number')">AI Risk Score <i class="fas fa-sort text-muted ms-1"></i></th>
                                    <th class="cursor-pointer" onclick="sortTable(5, 'string')">Status <i class="fas fa-sort text-muted ms-1"></i></th>
                                    <th class="text-end pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${proposals}">
                                    <c:set var="filterGroup" value="processed" />
                                    <c:if test="${p.status == 'Pending_MPP' || p.status == 'Meeting_Scheduled'}">
                                        <c:set var="filterGroup" value="pending" />
                                    </c:if>

                                    <tr class="table-row" data-status="${filterGroup}">
<!--                                        <td class="ps-4">
                                            <input class="form-check-input row-checkbox shadow-sm cursor-pointer" type="checkbox" value="${p.proposalId}" onchange="updateBulkButton()">
                                        </td>-->
                                        <td class="fw-bold text-secondary">${p.clubName}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/mpp/review?id=${p.proposalId}" class="text-primary fw-bold text-decoration-none" style="transition: 0.2s;" onmouseover="this.style.textDecoration = 'underline'" onmouseout="this.style.textDecoration = 'none'" title="Click to open full review page">
                                                ${p.title}
                                            </a><br>  
                                            <small class="text-muted"><i class="fas fa-calendar-day"></i> <fmt:formatDate value="${p.proposedDate}" pattern="dd MMM yyyy" /></small>
                                        </td>
                                        <td><fmt:formatNumber value="${p.budget}" type="currency" currencySymbol="" /></td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${p.conflictScore >= 50}">
                                                    <span class="badge bg-danger rounded-pill px-3 py-2 shadow-sm clickable-badge ai-glow" data-bs-toggle="modal" data-bs-target="#aiModal${p.proposalId}"><i class="fas fa-brain me-1"></i> ${p.conflictScore} (Critical)</span>
                                                </c:when>
                                                <c:when test="${p.conflictScore >= 20}">
                                                    <span class="badge bg-warning text-dark rounded-pill px-3 py-2 shadow-sm clickable-badge" data-bs-toggle="modal" data-bs-target="#aiModal${p.proposalId}"><i class="fas fa-brain me-1"></i> ${p.conflictScore} (Moderate)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success rounded-pill px-3 py-2 shadow-sm clickable-badge" data-bs-toggle="modal" data-bs-target="#aiModal${p.proposalId}"><i class="fas fa-check-circle me-1"></i> ${p.conflictScore} (Safe)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status == 'Approved'}"><span class="badge bg-success shadow-sm"><i class="fas fa-check"></i> Approved</span></c:when>
                                                <c:when test="${p.status == 'Rejected'}"><span class="badge bg-danger shadow-sm"><i class="fas fa-times"></i> Rejected</span></c:when>
                                                <c:when test="${p.status == 'Pending_MPP'}"><span class="badge bg-warning text-dark shadow-sm"><i class="fas fa-hourglass-half"></i> Pending Review</span></c:when>
                                                <c:when test="${p.status == 'Meeting_Scheduled'}"><span class="badge bg-info text-white shadow-sm"><i class="fas fa-video"></i> Pitching Set</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">${p.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-4">
                                            <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-sm btn-outline-primary" title="Read Proposal PDF" target="_blank"><i class="fas fa-file-pdf"></i></a>

                                            <c:choose>
                                                <c:when test="${p.status == 'Pending_MPP'}">
                                                    <button type="button" class="btn btn-sm btn-info text-white ms-1" data-bs-toggle="modal" data-bs-target="#scheduleModal${p.proposalId}" title="Schedule Pitching"><i class="fas fa-calendar-plus"></i> Set Pitching</button>
                                                    <button type="button" class="btn btn-sm btn-primary ms-1" data-bs-toggle="modal" data-bs-target="#alterModal${p.proposalId}" title="Alter Proposal Data"><i class="fas fa-edit"></i> Alter</button>
                                                    <button type="button" class="btn btn-sm btn-danger ms-1" data-bs-toggle="modal" data-bs-target="#rejectModal${p.proposalId}" title="Reject Outright"><i class="fas fa-times"></i></button>
                                                    </c:when>
                                                    <c:when test="${p.status == 'Meeting_Scheduled'}">
                                                    <button type="button" class="btn btn-sm btn-warning text-dark ms-1" data-bs-toggle="modal" data-bs-target="#editScheduleModal${p.proposalId}" title="View / Edit Schedule"><i class="fas fa-calendar-alt"></i></button>
                                                    <button type="button" class="btn btn-sm btn-primary ms-1" data-bs-toggle="modal" data-bs-target="#alterModal${p.proposalId}" title="Alter Proposal Data"><i class="fas fa-edit"></i> Alter</button>
                                                    <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST" class="d-inline" onsubmit="return confirm('APPROVE this proposal after pitching?');">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                        <button type="submit" class="btn btn-sm btn-success ms-1" title="Approve Post-Pitching"><i class="fas fa-check-double"></i></button>
                                                    </form>
                                                    <button type="button" class="btn btn-sm btn-danger ms-1" data-bs-toggle="modal" data-bs-target="#rejectModal${p.proposalId}" title="Reject Post-Pitching"><i class="fas fa-times"></i></button>
                                                    </c:when>
                                                </c:choose>

                                            <div class="modal fade text-start" id="scheduleModal${p.proposalId}" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content border-0 shadow">
                                                        <div class="modal-header bg-info text-white border-0">
                                                            <h5 class="modal-title"><i class="fas fa-video me-2"></i>Schedule Pitching Session</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST">
                                                            <div class="modal-body bg-light">
                                                                <input type="hidden" name="action" value="schedule">
                                                                <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                                <div class="alert alert-primary border-0 small"><i class="fas fa-info-circle me-1"></i> Scheduling interview for <strong>${p.title}</strong></div>
                                                                <div class="row g-3">
                                                                    <div class="col-6">
                                                                        <label class="form-label fw-bold small text-muted">Start Time</label>
                                                                        <input type="datetime-local" name="startTime" class="form-control" required>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <label class="form-label fw-bold small text-muted">End Time</label>
                                                                        <input type="datetime-local" name="endTime" class="form-control" required>
                                                                    </div>
                                                                    <div class="col-12 mt-2">
                                                                        <label class="form-label fw-bold small text-muted">Google Meet Link (Optional)</label>
                                                                        <input type="url" name="meetingLink" class="form-control" placeholder="Leave blank to auto-generate">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer border-0 bg-light">
                                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-info text-white">Send Invite &rarr;</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="modal fade text-start" id="editScheduleModal${p.proposalId}" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content border-0 shadow">
                                                        <div class="modal-header bg-warning text-dark border-0">
                                                            <h5 class="modal-title fw-bold"><i class="fas fa-edit me-2"></i>Review & Edit Pitching</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST">
                                                            <div class="modal-body bg-light">
                                                                <input type="hidden" name="action" value="reschedule">
                                                                <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                                <div class="card border-0 mb-3 bg-white shadow-sm">
                                                                    <div class="card-body">
                                                                        <h6 class="fw-bold text-muted mb-3 border-bottom pb-2">Current Schedule</h6>
                                                                        <p class="mb-2"><i class="fas fa-clock text-info me-2"></i><strong>Start Time:</strong> <br>
                                                                            <span class="ms-4 text-dark">
                                                                                <c:choose>
                                                                                    <c:when test="${not empty p.pitchingDate}"><fmt:formatDate value="${p.pitchingDate}" pattern="dd MMM yyyy, hh:mm a" /></c:when>
                                                                                    <c:otherwise>Not decided yet</c:otherwise>
                                                                                </c:choose>
                                                                            </span>
                                                                        </p>
                                                                        <p class="mb-0"><i class="fas fa-video text-primary me-2"></i><strong>Google Meet Link:</strong> <br>
                                                                            <span class="ms-4">
                                                                                <c:choose>
                                                                                    <c:when test="${not empty p.pitchingLocation}"><a href="${p.pitchingLocation}" target="_blank" class="text-decoration-none fw-bold">${p.pitchingLocation}</a></c:when>
                                                                                    <c:otherwise><span class="text-muted small">Not Decided Yet</span></c:otherwise>
                                                                                </c:choose>
                                                                            </span>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <div class="alert alert-danger border-0 small">
                                                                    <i class="fas fa-exclamation-triangle me-1"></i> Rescheduling will generate a <strong>new Google Meet link</strong> and notify the club.
                                                                </div>
                                                                <div class="row g-3">
                                                                    <div class="col-6">
                                                                        <label class="form-label fw-bold small text-muted">New Start Time</label>
                                                                        <input type="datetime-local" name="startTime" class="form-control" required>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <label class="form-label fw-bold small text-muted">New End Time</label>
                                                                        <input type="datetime-local" name="endTime" class="form-control" required>
                                                                    </div>
                                                                    <div class="col-12 mt-2">
                                                                        <label class="form-label fw-bold small text-muted">New Google Meet Link (Optional)</label>
                                                                        <input type="url" name="meetingLink" class="form-control" placeholder="Leave blank to auto-generate">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer border-0 bg-light">
                                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-warning text-dark fw-bold">Update & Notify Club</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="modal fade text-start" id="rejectModal${p.proposalId}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content border-0 shadow">
                                                        <div class="modal-header bg-danger text-white border-0">
                                                            <h5 class="modal-title"><i class="fas fa-comment-dots me-2"></i>Provide Feedback & Reject</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST">
                                                            <div class="modal-body bg-light">
                                                                <div class="alert alert-warning border-0">
                                                                    <i class="fas fa-info-circle me-2"></i> Returning <strong>${p.title}</strong> to the club.
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-secondary">Reason / Required amendments:</label>
                                                                    <textarea name="rejectFeedback" class="form-control" rows="4" required></textarea>
                                                                </div>
                                                                <input type="hidden" name="action" value="reject">
                                                                <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                            </div>
                                                            <div class="modal-footer border-0 bg-light">
                                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-danger">Confirm Rejection</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="modal fade text-start" id="alterModal${p.proposalId}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content border-0 shadow">
                                                        <div class="modal-header bg-primary text-white border-0">
                                                            <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Alter Proposal Data</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST">
                                                            <div class="modal-body bg-light">
                                                                <div class="alert alert-primary border-0 small">
                                                                    <i class="fas fa-info-circle me-2"></i> You are altering <strong>${p.title}</strong> directly. This bypasses the student amendment loop.
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-secondary small">Approved Budget (RM)</label>
                                                                    <input type="number" step="0.01" name="alteredBudget" class="form-control fw-bold text-primary" value="${p.budget}" required>
                                                                    <small class="text-muted">Modify the budget if MPP decides to slash a different amount during pitching.</small>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-secondary small">Alteration Remarks / Notes</label>
                                                                    <textarea name="alterFeedback" class="form-control" rows="3" placeholder="E.g., Budget slashed by RM200 due to overspending on food..." required></textarea>
                                                                    <small class="text-muted">This remark will be recorded in the audit trail.</small>
                                                                </div>
                                                                <input type="hidden" name="action" value="alter">
                                                                <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                            </div>
                                                            <div class="modal-footer border-0 bg-light">
                                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary fw-bold">Save Alterations</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="modal fade text-start" id="aiModal${p.proposalId}" tabindex="-1">
                                                <div class="modal-dialog modal-lg modal-dialog-centered">
                                                    <div class="modal-content border-0 shadow">
                                                        <div class="modal-header bg-dark text-white border-0">
                                                            <h5 class="modal-title fw-bold"><i class="fas fa-robot me-2 text-warning"></i>AI Risk Analysis</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body p-4 bg-light">
                                                            <div class="text-center mb-4 border-bottom pb-4">
                                                                <h6 class="text-muted text-uppercase fw-bold letter-spacing-1">Overall Conflict Score</h6>
                                                                <h1 class="display-1 fw-bold mb-0 <c:choose><c:when test='${p.conflictScore >= 50}'>text-danger</c:when><c:when test='${p.conflictScore >= 20}'>text-warning</c:when><c:otherwise>text-success</c:otherwise></c:choose>">
                                                                    ${p.conflictScore}
                                                                </h1>
                                                                <p class="text-muted mt-2">Points (Lower is better)</p>
                                                            </div>
                                                            <div class="card border-0 shadow-sm rounded-4">
                                                                <div class="card-body p-4">
                                                                    <h6 class="fw-bold text-primary mb-3"><i class="fas fa-chart-line me-2"></i>Detailed System Breakdown</h6>
                                                                    <c:choose>
                                                                        <c:when test="${not empty p.aiSuggestion}">${p.aiSuggestion}</c:when>
                                                                        <c:otherwise>
                                                                            <div class="alert alert-secondary border-0 text-center mb-0">
                                                                                <i class="fas fa-exclamation-circle mb-2 fa-2x text-muted d-block"></i>
                                                                                Maklumat heuristik terperinci tidak dapat ditarik untuk senarai ringkas ini.<br>Sila buka dokumen penuh untuk membaca cadangan AI.
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
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty proposals}">
                                    <tr><td colspan="7" class="text-center py-5 text-muted"><i class="fas fa-folder-open fs-1 mb-3 d-block"></i> No proposals found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="bulkApproveModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-primary text-white border-0">
                        <h5 class="modal-title"><i class="fas fa-check-double me-2"></i>Confirm Bulk Approval</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="bulkApproveForm" action="${pageContext.request.contextPath}/mpp/proposals" method="POST">
                        <div class="modal-body bg-light">
                            <div class="alert alert-primary border-0">
                                <i class="fas fa-info-circle me-2"></i> You are about to endorse <strong><span id="modalBulkCount"></span></strong> selected proposal(s).
                            </div>
                            <p class="text-muted small mb-0">Note: Only proposals in 'Pitching Set' status will be processed. They will be forwarded to HEPA.</p>
                            <input type="hidden" name="action" value="bulkApprove">
                            <div id="hiddenCheckboxContainer"></div>
                        </div>
                        <div class="modal-footer border-0 bg-light">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary fw-bold" onclick="prepareBulkSubmit()">Confirm & Endorse</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                // --- Tab Filtering ---
                                function filterTable(status, clickedBtn) {
                                    const buttons = document.querySelectorAll('#filterTabs .nav-link');
                                    buttons.forEach(btn => {
                                        btn.classList.remove('active', 'bg-primary', 'text-white', 'text-warning', 'text-success');
                                        if (btn.innerHTML.includes('Pending'))
                                            btn.classList.add('text-warning');
                                        if (btn.innerHTML.includes('Processed'))
                                            btn.classList.add('text-success');
                                    });
                                    clickedBtn.classList.add('active', 'bg-primary', 'text-white');
                                    clickedBtn.classList.remove('text-warning', 'text-success');

                                    const rows = document.querySelectorAll('.table-row');
                                    rows.forEach(row => {
                                        if (status === 'all' || row.getAttribute('data-status') === status) {
                                            row.classList.remove('hidden-row');
                                        } else {
                                            row.classList.add('hidden-row');
                                            // Uncheck hidden items to prevent accidental bulk actions
                                            const cb = row.querySelector('.row-checkbox');
                                            if (cb)
                                                cb.checked = false;
                                        }
                                    });
                                    updateBulkButton();
                                }

                                // --- Dynamic Table Sorting ---
                                let sortDirection = false;
                                function sortTable(columnIndex, type) {
                                    const table = document.querySelector("#proposalsTable tbody");
                                    const rows = Array.from(table.querySelectorAll("tr.table-row"));

                                    sortDirection = !sortDirection; // Toggle asc/desc

                                    rows.sort((a, b) => {
                                        let valA = a.querySelectorAll("td")[columnIndex].innerText.trim();
                                        let valB = b.querySelectorAll("td")[columnIndex].innerText.trim();

                                        if (type === 'number') {
                                            // Strip currency, commas, and AI labels
                                            valA = parseFloat(valA.replace(/[^0-9.-]+/g, ""));
                                            valB = parseFloat(valB.replace(/[^0-9.-]+/g, ""));
                                            return sortDirection ? valA - valB : valB - valA;
                                        } else {
                                            return sortDirection ? valA.localeCompare(valB) : valB.localeCompare(valA);
                                        }
                                    });

                                    rows.forEach(row => table.appendChild(row)); // Re-append

                                    // Update icons
                                    const headers = document.querySelectorAll("thead th i.fa-sort, thead th i.fa-sort-up, thead th i.fa-sort-down");
                                    headers.forEach((icon, index) => {
                                        icon.className = 'fas fa-sort text-muted ms-1';
                                        // We subtract 1 because the checkbox column doesn't have a sort icon
                                        if (index === columnIndex - 1) {
                                            icon.className = sortDirection ? 'fas fa-sort-up text-primary ms-1' : 'fas fa-sort-down text-primary ms-1';
                                        }
                                    });
                                }

                                // --- Bulk Selection & Form Prep ---
                                function toggleAllCheckboxes(masterCheckbox) {
                                    // Only select visible rows
                                    const checkboxes = document.querySelectorAll('.table-row:not(.hidden-row) .row-checkbox');
                                    checkboxes.forEach(cb => cb.checked = masterCheckbox.checked);
                                    updateBulkButton();
                                }

                                function updateBulkButton() {
                                    const checkedCount = document.querySelectorAll('.row-checkbox:checked').length;
                                    document.getElementById('bulkApproveBtn').disabled = checkedCount === 0;
                                    document.getElementById('bulkCountDisplay').innerText = checkedCount;
                                    document.getElementById('modalBulkCount').innerText = checkedCount;
                                }

                                function prepareBulkSubmit() {
                                    const container = document.getElementById('hiddenCheckboxContainer');
                                    container.innerHTML = ''; // Clear old data
                                    const checkboxes = document.querySelectorAll('.row-checkbox:checked');
                                    checkboxes.forEach(cb => {
                                        const input = document.createElement('input');
                                        input.type = 'hidden';
                                        input.name = 'selectedProposals';
                                        input.value = cb.value;
                                        container.appendChild(input);
                                    });
                                }

                                // --- Export to CSV ---
                                function exportTableToCSV(filename) {
                                    const rows = document.querySelectorAll("#proposalsTable tr:not(.hidden-row)");
                                    let csv = [];

                                    for (let i = 0; i < rows.length; i++) {
                                        let row = [], cols = rows[i].querySelectorAll("td, th");
                                        // Skip checkbox column (0) and action column (length-1)
                                        for (let j = 1; j < cols.length - 1; j++) {
                                            // Clean text: remove newlines and escape double quotes
                                            let data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, " ").replace(/"/g, '""');
                                            row.push('"' + data + '"');
                                        }
                                        csv.push(row.join(","));
                                    }

                                    const csvFile = new Blob([csv.join("\n")], {type: "text/csv"});
                                    const downloadLink = document.createElement("a");
                                    downloadLink.download = filename;
                                    downloadLink.href = window.URL.createObjectURL(csvFile);
                                    downloadLink.style.display = "none";
                                    document.body.appendChild(downloadLink);
                                    downloadLink.click();
                                    document.body.removeChild(downloadLink);
                                }
        </script>
    </body>
</html>