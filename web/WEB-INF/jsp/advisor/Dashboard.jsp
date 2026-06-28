<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <title>Advisor Dashboard | UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .top-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding: 1rem 0;
            }
            .welcome-card {
                background: linear-gradient(135deg, #0d6efd 0%, #0043a8 100%);
                color: white;
                border-radius: 20px;
                padding: 2.5rem;
                margin-bottom: 2rem;
                box-shadow: 0 10px 20px rgba(13, 110, 253, 0.15);
                position: relative;
                overflow: hidden;
            }
            .welcome-card::after {
                content: '\f508';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                position: absolute;
                top: -20px;
                right: 20px;
                font-size: 10rem;
                opacity: 0.1;
                transform: rotate(-15deg);
            }
            .stat-card {
                background: white;
                border-radius: 15px;
                padding: 1.5rem;
                border: none;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
                height: 100%;
                display: flex;
                align-items: center;
            }
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }
            .icon-box {
                width: 60px;
                height: 60px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }
            .custom-table-card {
                border-radius: 20px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
                border: 1px solid rgba(0,0,0,0.05);
            }
            .table > :not(caption) > * > * {
                padding: 1rem 1rem;
            }
            .action-panel {
                background: #f8f9fa;
                border-radius: 20px;
                padding: 1.5rem;
                border: 1px solid #e9ecef;
            }
            /* Deep Dive Clickable Title */
            .clickable-title {
                cursor: pointer;
                text-decoration: none;
                transition: color 0.2s ease-in-out;
            }
            .clickable-title:hover {
                text-decoration: underline;
                color: #0043a8 !important;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="top-header">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <h3 class="fw-bold mb-0 text-primary">
                        <i class="fas fa-user-shield me-2 d-none d-lg-inline"></i>Advisor Command Center
                    </h3>
                </div>
                <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-4" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-4" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="welcome-card">
                <div class="row align-items-center position-relative" style="z-index: 1;">
                    <div class="col-md-8">
                        <span class="badge bg-white text-primary mb-2 px-3 py-2 rounded-pill fw-bold">Academic Session 2025/2026</span>
                        <h2 class="fw-bold text-white mb-2">Welcome back, Dr. ${sessionScope.user.fullName}!</h2>
                        <p class="lead mb-0 text-white-50">You have <strong class="text-white">${not empty pendingProposals ? fn:length(pendingProposals) : 0}</strong> proposals awaiting your endorsement today.</p>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card">
                        <div class="icon-box bg-warning bg-opacity-10 text-warning me-3">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">Awaiting Review</p>
                            <h3 class="fw-bold mb-0 text-dark">${not empty pendingProposals ? fn:length(pendingProposals) : 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card">
                        <div class="icon-box bg-success bg-opacity-10 text-success me-3">
                            <i class="fas fa-check-double"></i>
                        </div>
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">Supported (MTD)</p>
                            <h3 class="fw-bold mb-0 text-dark">${not empty approvedCount ? approvedCount : 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card">
                        <div class="icon-box bg-danger bg-opacity-10 text-danger me-3">
                            <i class="fas fa-undo"></i>
                        </div>
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">Returned to Club</p>
                            <h3 class="fw-bold mb-0 text-dark">${not empty rejectedCount ? rejectedCount : 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card">
                        <div class="icon-box bg-info bg-opacity-10 text-info me-3">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div>
                            <p class="text-muted small fw-bold text-uppercase mb-1">Club Activity Health</p>
                            <h3 class="fw-bold mb-0 text-dark">Good</h3>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-xl-8 col-lg-7">
                    <div class="card custom-table-card bg-white p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold text-dark mb-0"><i class="fas fa-list-ul text-primary me-2"></i>Pending Endorsements</h5>
                        </div>

                        <div class="table-responsive">
                            <table id="advisorTable" class="table table-hover align-middle w-100">
                                <thead class="table-light text-muted small text-uppercase">
                                    <tr>
                                        <th>Proposal Title</th>
                                        <th>Submitted Date</th>
                                        <th>Event Date</th>
                                        <th>AI Risk</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty pendingProposals}">
                                            <c:forEach var="p" items="${pendingProposals}">
                                                <tr>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/advisor/review?id=${p.proposalId}" class="text-primary fw-bold clickable-title" title="Click to view full details">
                                                            ${p.title}
                                                        </a>
                                                    </td>

                                                    <%-- NEW: Submitted Date Column --%>
                                                    <td data-order="${p.createdAt}">
                                                        <c:choose>
                                                            <c:when test="${not empty p.createdAt}">
                                                                <div class="d-flex flex-column">
                                                                    <span class="fw-bold text-dark"><fmt:formatDate value="${p.createdAt}" pattern="dd MMM yyyy" /></span>
                                                                    <span class="text-muted small"><fmt:formatDate value="${p.createdAt}" pattern="hh:mm a" /></span>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted fst-italic">N/A</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                    <c:choose>
                                                        <c:when test="${not empty p.proposedDate}">
                                                            <td data-order="${p.proposedDate}">
                                                                <span class="text-dark"><fmt:formatDate value="${p.proposedDate}" pattern="dd MMM yyyy" /></span>
                                                            </td>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <td data-order="0"><span class="text-muted fst-italic">Not Set</span></td>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${p.conflictScore < 50}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger shadow-sm">High Risk</span></c:when>
                                                            <c:when test="${p.conflictScore < 75}"><span class="badge bg-warning bg-opacity-10 text-warning border border-warning shadow-sm">Moderate</span></c:when>
                                                            <c:otherwise><span class="badge bg-success bg-opacity-10 text-success border border-success shadow-sm">Optimum</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end">
                                                        <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3 shadow-sm fw-bold" data-bs-toggle="modal" data-bs-target="#modal${p.proposalId}">
                                                            Fast Track
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4 col-lg-5">
                    <div class="action-panel h-100">
                        <h6 class="fw-bold text-dark mb-4"><i class="fas fa-bell text-warning me-2"></i>Recent Alerts</h6>
                        <div class="d-flex align-items-start mb-3 bg-white p-3 rounded-3 shadow-sm border-start border-4 border-warning">
                            <i class="fas fa-exclamation-circle text-warning mt-1 me-3"></i>
                            <div>
                                <h6 class="fw-bold mb-1 text-dark text-sm">AGM Deadline Approaching</h6>
                                <p class="text-muted small mb-0">Remind your clubs to submit their Annual General Meeting reports by the end of the month.</p>
                            </div>
                        </div>
                        <div class="d-flex align-items-start mb-4 bg-white p-3 rounded-3 shadow-sm border-start border-4 border-primary">
                            <i class="fas fa-info-circle text-primary mt-1 me-3"></i>
                            <div>
                                <h6 class="fw-bold mb-1 text-dark text-sm">New HEPA Guidelines</h6>
                                <p class="text-muted small mb-0">Event budgets exceeding RM 500 now require external sponsorship declarations.</p>
                            </div>
                        </div>
                        <hr class="text-muted opacity-25 mb-4">
                        <h6 class="fw-bold text-dark mb-3"><i class="fas fa-bolt text-success me-2"></i>Quick Actions</h6>
                        <a href="${pageContext.request.contextPath}/advisor/approvals" class="btn btn-white border shadow-sm w-100 text-start mb-2 rounded-3 py-2 fw-bold text-dark">
                            <i class="fas fa-file-archive text-primary me-2"></i> View Past Records
                        </a>
                        <a href="#" class="btn btn-white border shadow-sm w-100 text-start rounded-3 py-2 fw-bold text-dark">
                            <i class="fas fa-envelope text-primary me-2"></i> Message Club President
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <%-- FAST TRACK MODALS --%>
        <c:if test="${not empty pendingProposals}">
            <c:forEach var="p" items="${pendingProposals}">
                <div class="modal fade" id="modal${p.proposalId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                        <div class="modal-content border-0 shadow-lg rounded-4">

                            <div class="modal-header bg-primary text-white border-0 py-3">
                                <h5 class="modal-title fw-bold"><i class="fas fa-bolt me-2 text-warning"></i>Fast-Track Review</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                            <div class="modal-body p-4 bg-light">
                                <div class="d-flex justify-content-between align-items-start mb-4 border-bottom pb-3">
                                    <div>
                                        <h4 class="fw-bold text-dark mb-2">${p.title}</h4>
                                        <span class="badge bg-white text-primary border px-3 py-2 rounded-pill shadow-sm">
                                            <i class="fas fa-hashtag me-1"></i> ID: ${p.proposalId}
                                        </span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" target="_blank" class="btn btn-outline-primary rounded-pill px-4 shadow-sm fw-bold">
                                        <i class="fas fa-file-pdf me-2"></i> Read PDF
                                    </a>
                                </div>

                                <div class="row g-4 mb-4">
                                    <div class="col-md-6">
                                        <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100">
                                            <p class="text-muted small fw-bold text-uppercase mb-1"><i class="far fa-calendar-alt me-1"></i> Proposed Schedule</p>
                                            <h6 class="fw-bold text-dark mb-4">
                                                <c:choose>
                                                    <c:when test="${not empty p.proposedDate}">
                                                        <fmt:formatDate value="${p.proposedDate}" pattern="dd MMMM yyyy" /> <span class="badge bg-light text-dark ms-1">${p.duration} Days</span>
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </h6>
                                            <p class="text-muted small fw-bold text-uppercase mb-1"><i class="fas fa-map-marker-alt me-1"></i> Venue</p>
                                            <h6 class="fw-bold text-dark mb-4">${p.venue}</h6>
                                            <p class="text-muted small fw-bold text-uppercase mb-1"><i class="fas fa-users me-1"></i> Target Audience</p>
                                            <h6 class="fw-bold text-dark mb-0">${p.targetAudience} <span class="badge bg-light text-dark ms-1">${p.estimateParticipant} Pax</span></h6>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100">
                                            <p class="text-muted small fw-bold text-uppercase mb-1"><i class="fas fa-wallet me-1"></i> Requested Budget</p>
                                            <h3 class="text-success fw-bold mb-4">RM <fmt:formatNumber value="${p.budget}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h3>
                                            <p class="text-muted small fw-bold text-uppercase mb-1"><i class="fas fa-align-left me-1"></i> Executive Summary</p>
                                            <div class="text-dark small" style="display: -webkit-box; -webkit-line-clamp: 5; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.6;">
                                                ${p.description}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- SEPARATED FORM 1: E-RISK UPLOAD --%>
                                <div class="bg-white p-4 rounded-4 shadow-sm border-start border-4 border-primary mb-4">
                                    <h6 class="fw-bold text-primary mb-2"><i class="fas fa-shield-alt me-2"></i>E-Risk Document Assessment</h6>
                                    <c:choose>
                                        <c:when test="${not empty p.eriskFile}">
                                            <div class="alert alert-success py-2 px-3 d-flex justify-content-between align-items-center mb-0 border-0 rounded-3">
                                                <span class="small fw-bold"><i class="fas fa-check-circle me-1"></i> E-Risk Document Successfully Uploaded</span>
                                                <a href="${pageContext.request.contextPath}/${p.eriskFile}" target="_blank" class="btn btn-sm btn-success rounded-pill px-3 fw-bold">View Document</a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted small mb-2">Upload the signed E-Risk assessment to unlock the support button.</p>
                                            <form action="${pageContext.request.contextPath}/UploadERiskServlet" method="POST" enctype="multipart/form-data">
                                                <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                <div class="input-group input-group-sm">
                                                    <input type="file" name="eriskFile" class="form-control" accept=".pdf,.doc,.docx" required>
                                                    <button type="submit" class="btn btn-primary px-3 fw-bold"><i class="fas fa-upload me-1"></i> Upload</button>
                                                </div>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <%-- SEPARATED FORM 2: FEEDBACK & ACTION --%>
                                <form action="dashboard" method="POST">
                                    <input type="hidden" name="proposalId" value="${p.proposalId}">

                                    <div class="bg-white p-4 rounded-4 shadow-sm border border-light mb-2">
                                        <label class="form-label fw-bold text-dark mb-2">
                                            <i class="fas fa-comment-dots text-primary me-2"></i> Advisor Remarks / Feedback
                                        </label>
                                        <textarea name="feedback" class="form-control bg-light border-0 p-3" rows="3" placeholder="Enter instructions or notes for the MPP reviewer..." required></textarea>
                                    </div>

                                    <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                        <button type="button" class="btn btn-light rounded-pill px-4 fw-bold shadow-sm border" data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" name="action" value="reject" class="btn btn-outline-danger px-4 rounded-pill fw-bold bg-white">
                                            <i class="fas fa-times me-1"></i> Return to Club
                                        </button>

                                        <c:choose>
                                            <c:when test="${empty p.eriskFile}">
                                                <button type="button" class="btn btn-secondary px-4 rounded-pill fw-bold shadow-sm" onclick="alert('Please upload the E-Risk Document first!');">
                                                    <i class="fas fa-lock me-1"></i> Endorse Proposal
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="submit" name="action" value="approve" class="btn btn-success px-5 rounded-pill fw-bold shadow-sm">
                                                    <i class="fas fa-check me-1"></i> Endorse & Forward
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
        <script>
                                                    $(document).ready(function () {
                                                        $('#advisorTable').DataTable({
                                                            "order": [[1, "asc"]], /* Default sort by Submitted Date */
                                                            "language": {
                                                                "search": "",
                                                                "searchPlaceholder": "Search proposals...",
                                                                "lengthMenu": "_MENU_ entries",
                                                                "emptyTable": "You're all caught up! No pending proposals."
                                                            },
                                                            "dom": "<'row mb-3'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6 d-flex justify-content-end'f>>" +
                                                                    "<'row'<'col-sm-12'tr>>" +
                                                                    "<'row mt-3'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>"
                                                        });

                                                        $('.dataTables_filter input').addClass('form-control form-control-sm border-0 bg-light rounded-pill px-3 py-2 w-100').css('outline', 'none');


                                                    });
        </script>
    </body>
</html>