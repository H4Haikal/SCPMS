<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Faculty Dashboard | UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            :root {
                --faculty-color: #800000; /* Maroon Theme for Faculty */
            }
            .text-faculty {
                color: var(--faculty-color) !important;
            }
            .bg-faculty {
                background-color: var(--faculty-color) !important;
                color: white;
            }
            .btn-faculty {
                background-color: var(--faculty-color);
                color: white;
                border-radius: 50px;
                transition: all 0.3s ease;
            }
            .btn-faculty:hover {
                background-color: #600000;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            /* Stat Cards Enhancements */
            .stat-card {
                border-radius: 12px;
                border: none;
                box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
                transition: transform 0.2s ease-in-out;
            }
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15);
            }
            .border-top-blue {
                border-top: 4px solid #0d6efd !important;
            }
            .border-top-green {
                border-top: 4px solid #198754 !important;
            }
            .border-top-yellow {
                border-top: 4px solid #ffc107 !important;
            }
            .border-top-red {
                border-top: 4px solid #dc3545 !important;
            }
            .stat-title {
                font-size: 0.75rem;
                font-weight: bold;
                letter-spacing: 0.5px;
                color: #6c757d;
                text-transform: uppercase;
            }
            .stat-value {
                font-size: 2.5rem;
                font-weight: 800;
                color: #212529;
            }
            .stat-icon {
                opacity: 0.15;
                font-size: 1.5rem;
            }

            /* Table Styling */
            .table-hover tbody tr:hover {
                background-color: #fdfbfb;
            }
            .table th {
                letter-spacing: 0.5px;
            }
            td {
                vertical-align: middle;
                padding: 1rem 0.5rem !important;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <div class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom border-2">
                    <div class="d-flex align-items-center">
                        <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                            <i class="fas fa-bars fa-lg"></i>
                        </button>
                        <h4 class="fw-bold mb-0 text-dark">
                            <i class="fas fa-tachometer-alt text-primary me-2"></i> Dashboard Overview
                        </h4>
                    </div>

                    <%-- Panggil Standard Topbar UI --%>
                    <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
                </div>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible shadow-sm rounded-3">
                        <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <div class="card border-0 shadow-sm mb-4" style="background-color: #0d6efd; border-radius: 16px;">
                    <div class="card-body p-4 p-md-5 d-flex justify-content-between align-items-center">
                        <div class="text-white">
                            <h2 class="fw-bold mb-2">Welcome back, ${user.fullName}!</h2>
                            <p class="mb-2 opacity-75">UMT ClubSphere • Student Club Management System</p>
                            <p class="mb-0 opacity-75 small">
                                <i class="far fa-clock me-1"></i> 
                                <c:set var="today" value="<%= new java.util.Date()%>" />
                                <fmt:formatDate value="${today}" pattern="EEEE, dd MMMM yyyy" />
                            </p>
                        </div>
                        <div class="bg-white rounded-circle d-none d-md-flex align-items-center justify-content-center shadow" style="width: 80px; height: 80px;">
                            <i class="fas fa-university fa-3x text-primary"></i>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-5">
                    <div class="col-6 col-md-3">
                        <div class="card stat-card border-top-blue h-100">
                            <div class="card-body p-3 d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="stat-title mb-1">Pending Review</div>
                                    <div class="stat-value text-primary">${proposalsCount}</div>
                                </div>
                                <i class="fas fa-file-signature stat-icon text-primary"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="card stat-card border-top-green h-100">
                            <div class="card-body p-3 d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="stat-title mb-1">Active Clubs</div>
                                    <div class="stat-value">0</div>
                                </div>
                                <i class="fas fa-users stat-icon text-success"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="card stat-card border-top-yellow h-100">
                            <div class="card-body p-3 d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="stat-title mb-1">Events This Week</div>
                                    <div class="stat-value">0</div>
                                </div>
                                <i class="far fa-calendar-alt stat-icon text-warning"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="card stat-card border-top-red h-100">
                            <div class="card-body p-3 d-flex justify-content-between align-items-start">
                                <div>
                                    <div class="stat-title mb-1">Total Events 2026</div>
                                    <div class="stat-value">0</div>
                                </div>
                                <i class="far fa-calendar-check stat-icon text-danger"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-clipboard-check text-faculty me-2"></i>Academic Proposals Pending Verification</h5>
                </div>

                <div class="card border-0 shadow-sm" style="border-radius: 16px;">
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table id="facultyTable" class="table table-hover align-middle w-100">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Club Name</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Program Details</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Status</th>
                                        <th class="text-end text-secondary fw-bold small text-uppercase border-0">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${facultyProposals}">
                                        <tr>
                                            <td>
                                                <span class="badge bg-light text-dark border px-2 py-1 shadow-sm"><i class="fas fa-graduation-cap text-secondary me-1"></i> ${p.clubName}</span><br>
                                            </td>
                                            <td style="max-width: 300px;">
                                                <span class="fw-bold text-dark fs-6">${p.title}</span><br>
                                                <small class="text-success fw-bold"><i class="fas fa-wallet me-1"></i>RM <fmt:formatNumber value="${p.budget}" pattern="#,##0.00" /></small>
                                            </td>
                                            <td>
                                                <span class="badge bg-warning text-dark rounded-pill px-3 py-2"><i class="fas fa-clock me-1"></i> Action Required</span>
                                            </td>
                                            <td class="text-end">

                                                <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-sm btn-light border rounded-circle shadow-sm me-1" target="_blank" data-bs-toggle="tooltip" title="View Document">
                                                    <i class="fas fa-file-pdf text-danger"></i>
                                                </a>

                                                <form action="${pageContext.request.contextPath}/faculty/review" method="POST" class="d-inline">
                                                    <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                    <button type="submit" name="action" value="approve_hepa" class="btn btn-sm btn-faculty rounded-pill px-3 shadow-sm mx-1" onclick="return confirm('Verify academic content and forward to HEPA?');" data-bs-toggle="tooltip" title="Verify & Forward">
                                                        <i class="fas fa-check-circle"></i> Verify
                                                    </button>
                                                </form>

                                                <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#rejectModal${p.proposalId}" title="Return to Student">
                                                    <i class="fas fa-times-circle"></i> Reject
                                                </button>

                                                <div class="modal fade text-start" id="rejectModal${p.proposalId}" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content border-0 shadow-lg rounded-4">
                                                            <div class="modal-header bg-danger text-white border-0 rounded-top-4">
                                                                <h5 class="modal-title fw-bold" id="rejectModalLabel"><i class="fas fa-exclamation-triangle me-2"></i>Reject Proposal</h5>
                                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <form action="${pageContext.request.contextPath}/faculty/review" method="POST">
                                                                <div class="modal-body p-4">
                                                                    <div class="alert alert-light border border-danger mb-4">
                                                                        You are about to return: <strong>${p.title}</strong>
                                                                    </div>
                                                                    <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                                    <input type="hidden" name="action" value="reject">
                                                                    <input type="hidden" name="source" value="">

                                                                    <div class="mb-3">
                                                                        <label class="form-label fw-bold text-muted small">Remarks / Reason for Rejection <span class="text-danger">*</span></label>
                                                                        <textarea class="form-control bg-light" name="feedback" rows="4" placeholder="Please state why this proposal is being returned (e.g., Insufficient academic value, formatting errors)..." required></textarea>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer bg-light border-0 rounded-bottom-4">
                                                                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                                                    <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold shadow-sm">Return Proposal</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <script>
        $(document).ready(function () {
            // Initialize DataTable with English Text
            $('#facultyTable').DataTable({
                "pageLength": 5,
                "ordering": false,
                "language": {
                    "search": "Search Proposals:",
                    "zeroRecords": "No pending proposals found.",
                    "emptyTable": "You have no academic proposals waiting for verification at this time."
                }
            });

            // Initialize Bootstrap Tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
        </script>
    </body>
</html>