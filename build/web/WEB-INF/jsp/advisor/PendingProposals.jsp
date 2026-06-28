<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Advisor Approvals | UMT ClubSphere</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
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
            /* Clickable Badge & Glowing Animations */
            .clickable-badge {
                cursor: pointer;
                transition: transform 0.2s ease-in-out;
            }
            .clickable-badge:hover {
                transform: scale(1.1);
            }
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
            /* Filter Tabs Styling */
            .nav-pills .nav-link {
                color: #6c757d;
                border-radius: 50rem;
                margin-right: 0.5rem;
                transition: all 0.3s ease;
            }
            .nav-pills .nav-link:hover {
                background-color: #e9ecef;
            }
            .nav-pills .nav-link.active {
                background-color: #0d6efd !important;
                color: white !important;
                box-shadow: 0 4px 6px rgba(13, 110, 253, 0.2);
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
                    <h3 class="fw-bold mb-0"><i class="fas fa-user-shield text-primary me-2"></i>Advisor Approvals</h3>
                    <p class="text-muted mt-1 mb-0">Provide support and guidance for your club proposals.</p>
                </div>
            </div>

            <%-- Success/Error Messages --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible shadow-sm" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible shadow-sm" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="d-flex mb-4">
                <ul class="nav nav-pills" id="filterTabs">
                    <li class="nav-item">
                        <button class="nav-link active px-4 fw-bold filter-btn" data-filter="">All Records</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link px-4 fw-bold text-warning filter-btn" data-filter="pending">Pending My Review</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link px-4 fw-bold text-success filter-btn" data-filter="processed">Processed</button>
                    </li>
                </ul>
            </div>

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4">
                    <div class="table-responsive">
                        <table id="advisorReviewTable" class="table table-hover align-middle w-100">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-4">Club Name</th>
                                    <th>Program Title</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                    <th>Budget (RM)</th>
                                    <th class="text-center">AI Risk Score</th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Action</th>
                                    <th class="d-none">FilterGroup</th> 
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${proposals}">
                                    <%-- Status Filter Logic --%>
                                    <c:set var="filterGroup" value="processed" />
                                    <c:if test="${p.status == 'Pending_Advisor'}">
                                        <c:set var="filterGroup" value="pending" />
                                    </c:if>

                                    <tr>
                                        <td class="ps-4 fw-bold text-secondary">${p.clubName}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/advisor/review?id=${p.proposalId}" class="text-primary fw-bold text-decoration-none clickable-title">
                                                ${p.title}
                                            </a>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.createdAt}">
                                                    <span class="d-none">${p.createdAt}</span> <fmt:formatDate value="${p.createdAt}" pattern="dd MMM yyyy" /><br>
                                                    <small class="text-muted"><i class="fas fa-clock"></i> <fmt:formatDate value="${p.createdAt}" pattern="hh:mm a" /></small>
                                                </c:when>
                                                <c:otherwise><span class="text-muted fst-italic">N/A</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.updatedAt}">
                                                    <span class="d-none">${p.updatedAt}</span> <fmt:formatDate value="${p.updatedAt}" pattern="dd MMM yyyy" /><br>
                                                    <small class="text-muted"><i class="fas fa-clock"></i> <fmt:formatDate value="${p.updatedAt}" pattern="hh:mm a" /></small>
                                                </c:when>
                                                <c:otherwise><span class="text-muted fst-italic">No Updates</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="fw-semibold">RM <fmt:formatNumber value="${p.budget}" pattern="#,##0.00" /></td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${p.conflictScore >= 50}">
                                                    <span class="badge bg-danger rounded-pill px-3 py-2 shadow-sm clickable-badge ai-glow-danger" data-bs-toggle="modal" data-bs-target="#aiModal${p.proposalId}">
                                                        <i class="fas fa-brain me-1"></i> ${p.conflictScore} (Critical)
                                                    </span>
                                                </c:when>
                                                <c:when test="${p.conflictScore >= 20}">
                                                    <span class="badge bg-warning text-dark rounded-pill px-3 py-2 shadow-sm clickable-badge ai-glow-warning" data-bs-toggle="modal" data-bs-target="#aiModal${p.proposalId}">
                                                        <i class="fas fa-brain me-1"></i> ${p.conflictScore} (Moderate)
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success rounded-pill px-3 py-2 shadow-sm clickable-badge" data-bs-toggle="modal" data-bs-target="#aiModal${p.proposalId}">
                                                        <i class="fas fa-check-circle me-1"></i> ${p.conflictScore} (Safe)
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status == 'Pending_Advisor'}"><span class="badge bg-warning text-dark shadow-sm">Pending Advisor</span></c:when>
                                                <c:when test="${p.status == 'Rejected'}"><span class="badge bg-danger shadow-sm">Rejected</span></c:when>
                                                <c:otherwise><span class="badge bg-info text-white shadow-sm">${p.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-end pe-4">
                                            <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-sm btn-outline-primary" title="Download PDF" target="_blank">
                                                <i class="fas fa-file-pdf"></i>
                                            </a>

                                            <c:if test="${p.status == 'Pending_Advisor'}">
                                                <form action="${pageContext.request.contextPath}/advisor/pending" method="POST" class="d-inline" onsubmit="return confirm('Support & Forward this proposal?');">
                                                    <input type="hidden" name="action" value="approve">
                                                    <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                    <button type="submit" class="btn btn-sm btn-success ms-1" title="Support"><i class="fas fa-check"></i></button>
                                                </form>
                                                <button type="button" class="btn btn-sm btn-danger ms-1" data-bs-toggle="modal" data-bs-target="#rejectModal${p.proposalId}" title="Reject">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </c:if>
                                        </td>

                                        <td class="d-none">${filterGroup}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <c:forEach var="p" items="${proposals}">

            <c:if test="${p.status == 'Pending_Advisor'}">
                <div class="modal fade text-start" id="rejectModal${p.proposalId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg rounded-4">
                            <div class="modal-header bg-danger text-white border-0 py-3">
                                <h5 class="modal-title fw-bold"><i class="fas fa-comment-dots me-2"></i>Advisor Feedback</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/advisor/pending" method="POST">
                                <div class="modal-body bg-light p-4">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold text-dark">Reason for rejection:</label>
                                        <textarea name="feedback" class="form-control border-0 shadow-sm rounded-3" rows="4" required placeholder="Provide guidance and corrections to the club..."></textarea>
                                    </div>
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="proposalId" value="${p.proposalId}">
                                </div>
                                <div class="modal-footer border-0 bg-white">
                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold shadow-sm">Confirm Rejection</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="modal fade text-start" id="aiModal${p.proposalId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content border-0 shadow-lg rounded-4">
                        <div class="modal-header bg-dark text-white border-0 py-3">
                            <h5 class="modal-title fw-bold"><i class="fas fa-robot me-2 text-warning"></i>AI Risk Analysis</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body p-4 bg-light">
                            <div class="text-center mb-4 border-bottom pb-4">
                                <h6 class="text-muted text-uppercase fw-bold letter-spacing-1">Overall Conflict Score</h6>
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
                                            <div class="text-dark" style="white-space: pre-wrap;">${p.aiSuggestion}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-secondary border-0 text-center mb-0 rounded-3">
                                                <i class="fas fa-exclamation-circle mb-3 fa-2x text-muted d-block"></i>
                                                Detailed heuristic information cannot be pulled for brief display.<br>Please open the full PDF document to read the AI suggestions.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-0 bg-white">
                            <button type="button" class="btn btn-secondary rounded-pill px-4 fw-bold shadow-sm" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

        </c:forEach>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <script>
                                                    $(document).ready(function () {
                                                        // Initialize DataTables
                                                        var table = $('#advisorReviewTable').DataTable({
                                                            "order": [[2, "desc"]], // Sort by Created At descending by default
                                                            "language": {
                                                                "search": "Search Proposals:",
                                                                "lengthMenu": "Display _MENU_ entries"
                                                            },
                                                            "columnDefs": [
                                                                {"visible": false, "targets": 8} // Hide the 'FilterGroup' column from view
                                                            ]
                                                        });

                                                        // Smart Tabs Integration with DataTables
                                                        $('.filter-btn').on('click', function () {
                                                            // Update tab styling
                                                            $('.filter-btn').removeClass('active text-warning text-success');
                                                            $(this).addClass('active');

                                                            // If they clicked Warning or Success, re-add the color class for visual feedback
                                                            if ($(this).data('filter') === 'pending')
                                                                $(this).addClass('text-warning');
                                                            if ($(this).data('filter') === 'processed')
                                                                $(this).addClass('text-success');

                                                            // Perform DataTables search on the hidden column (Index 8)
                                                            var filterValue = $(this).data('filter');

                                                            // Regex search to match exact word so "processed" doesn't somehow trigger incorrectly
                                                            if (filterValue) {
                                                                table.column(8).search('^' + filterValue + '$', true, false).draw();
                                                            } else {
                                                                table.column(8).search('').draw(); // Clear search for "All Records"
                                                            }
                                                        });
                                                    });
        </script>
    </body>
</html>