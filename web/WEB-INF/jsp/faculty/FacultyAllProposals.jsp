<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>All Proposals | Faculty</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            :root {
                --faculty-color: #800000;
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
                transition: all 0.3s;
            }
            .btn-faculty:hover {
                background-color: #600000;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            .table-hover tbody tr:hover {
                background-color: #fcf9f9;
            }
            td {
                vertical-align: middle;
                padding: 1rem 0.5rem !important;
            }
            .filter-panel {
                background-color: #f8f9fc;
                border: 1px solid #e3e6f0;
                border-radius: 12px;
            }
            .clickable-title {
                cursor: pointer;
                text-decoration: underline;
                text-decoration-color: transparent;
                transition: 0.3s;
            }
            .clickable-title:hover {
                text-decoration-color: var(--faculty-color);
                color: var(--faculty-color) !important;
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
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-2">
                    <button class="btn btn-light text-faculty me-3 d-lg-none shadow-sm" id="sidebarToggle"><i class="fas fa-bars fa-lg"></i></button>
                    <div>
                        <h3 class="fw-bold mb-0 text-faculty"><i class="fas fa-folder-open me-2"></i>All Academic Proposals</h3>
                        <p class="text-muted mb-0">Master list of all proposals submitted by academic clubs under your faculty.</p>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible shadow-sm rounded-3">
                        <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible shadow-sm rounded-3">
                        <i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="filter-panel p-4 mb-4 shadow-sm">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label text-muted small fw-bold mb-1"><i class="fas fa-filter me-1"></i> Filter by Status</label>
                            <select id="statusFilter" class="form-select border-0 shadow-sm rounded-pill">
                                <option value="">All Statuses</option>
                                <option value="Pending Review">Pending Review</option>
                                <option value="With HEPA">With HEPA</option>
                                <option value="Endorsed">Endorsed</option>
                                <option value="Rejected">Rejected</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted small fw-bold mb-1"><i class="fas fa-sort-amount-down me-1"></i> Sort by Received Date</label>
                            <select id="dateSort" class="form-select border-0 shadow-sm rounded-pill">
                                <option value="desc">Latest First</option>
                                <option value="asc">Oldest First</option>
                            </select>
                        </div>
                        <div class="col-md-4 text-end">
                            <button id="resetFilters" class="btn btn-light border rounded-pill shadow-sm text-secondary px-4">
                                <i class="fas fa-sync-alt me-1"></i> Reset Filters
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm" style="border-radius: 16px;">
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table id="allProposalsTable" class="table table-hover w-100 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Club</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Title & Budget</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0 text-center">AI Risk</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Created At</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Last Updated</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Status</th>
                                        <th class="text-end text-secondary fw-bold small text-uppercase border-0 pe-3">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${allProposals}">
                                        <tr>
                                            <td><span class="badge bg-light text-dark border px-2 py-1 shadow-sm"><i class="fas fa-users text-secondary me-1"></i> ${p.clubName}</span></td>
                                            <td style="max-width: 250px;">
                                                <a href="${pageContext.request.contextPath}/faculty/review?id=${p.proposalId}" class="text-dark fw-bold clickable-title">${p.title}</a><br>
                                                <small class="text-success fw-bold">RM <fmt:formatNumber value="${p.budget}" pattern="#,##0.00" /></small>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${p.conflictScore >= 50}"><span class="badge bg-danger shadow-sm ai-glow-danger">${p.conflictScore}</span></c:when>
                                                    <c:when test="${p.conflictScore >= 20}"><span class="badge bg-warning text-dark shadow-sm">${p.conflictScore}</span></c:when>
                                                    <c:otherwise><span class="badge bg-success shadow-sm">${p.conflictScore}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td data-order="${not empty p.createdAt ? p.createdAt.time : 0}">
                                                <c:if test="${not empty p.createdAt}">
                                                    <div class="text-dark fw-bold"><fmt:formatDate value="${p.createdAt}" pattern="dd MMM yyyy" /></div>
                                                    <div class="text-muted small"><i class="far fa-clock me-1"></i><fmt:formatDate value="${p.createdAt}" pattern="hh:mm a" /></div>
                                                    </c:if>
                                            </td>
                                            <td data-order="${not empty p.updatedAt ? p.updatedAt.time : 0}">
                                                <c:if test="${not empty p.updatedAt}">
                                                    <div class="text-dark fw-bold"><fmt:formatDate value="${p.updatedAt}" pattern="dd MMM yyyy" /></div>
                                                    <div class="text-muted small"><i class="far fa-clock me-1"></i><fmt:formatDate value="${p.updatedAt}" pattern="hh:mm a" /></div>
                                                    </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.status == 'Pending_Faculty'}"><span class="badge bg-warning text-dark px-3 py-2 rounded-pill"><i class="fas fa-clock me-1"></i> Pending Review</span></c:when>
                                                    <c:when test="${p.status == 'Pending_HEPA'}"><span class="badge bg-info px-3 py-2 rounded-pill"><i class="fas fa-spinner fa-spin me-1"></i> With HEPA</span></c:when>
                                                    <c:when test="${p.status == 'Approved'}"><span class="badge bg-success px-3 py-2 rounded-pill"><i class="fas fa-check me-1"></i> Endorsed</span></c:when>
                                                    <c:otherwise><span class="badge bg-danger px-3 py-2 rounded-pill">${p.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-3">
                                                <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-sm btn-light border rounded-circle shadow-sm mx-1" target="_blank" data-bs-toggle="tooltip" title="View Document"><i class="fas fa-file-pdf text-danger"></i></a>
                                                    <c:if test="${p.status == 'Pending_Faculty'}">
                                                    <form action="${pageContext.request.contextPath}/faculty/review" method="POST" class="d-inline">
                                                        <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                        <button type="submit" name="action" value="approve_hepa" class="btn btn-sm btn-faculty rounded-pill px-3 shadow-sm mx-1" onclick="return confirm('Verify academic content and forward to HEPA?');" data-bs-toggle="tooltip" title="Verify & Forward">
                                                            <i class="fas fa-check-circle"></i> Verify
                                                        </button>
                                                    </form>
                                                    <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#rejectModal${p.proposalId}" title="Return"><i class="fas fa-times-circle"></i> Reject</button>
                                                </c:if>
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

        <c:forEach var="p" items="${allProposals}">
            <c:if test="${p.status == 'Pending_Faculty'}">
                <div class="modal fade text-start" id="rejectModal${p.proposalId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg rounded-4">
                            <div class="modal-header bg-danger text-white border-0 rounded-top-4 py-3">
                                <h5 class="modal-title fw-bold"><i class="fas fa-exclamation-triangle me-2"></i>Reject Proposal</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/faculty/review" method="POST">
                                <div class="modal-body p-4 bg-light">
                                    <div class="alert alert-light border border-danger shadow-sm mb-4">You are about to reject: <strong>${p.title}</strong></div>
                                    <input type="hidden" name="proposalId" value="${p.proposalId}">
                                    <input type="hidden" name="action" value="reject">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold text-muted small">Remarks / Reason for Rejection <span class="text-danger">*</span></label>
                                        <textarea class="form-control" name="rejectFeedback" rows="4" placeholder="Please state why this proposal is being returned..." required></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer bg-white border-0 rounded-bottom-4 py-3">
                                    <button type="button" class="btn btn-light rounded-pill px-4 border" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold shadow-sm">Return Proposal</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:forEach>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>

        <script>
                                                            $(document).ready(function () {
                                                                var table = $('#allProposalsTable').DataTable({
                                                                    "pageLength": 10,
                                                                    "order": [[4, "desc"]],
                                                                    "dom": "<'row mb-3'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6 text-end'B>>" +
                                                                            "<'row'<'col-sm-12'tr>>" +
                                                                            "<'row mt-3'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
                                                                    "buttons": [
                                                                        {extend: 'excelHtml5', className: 'btn btn-sm btn-success shadow-sm', text: '<i class="fas fa-file-excel"></i> Excel'},
                                                                        {extend: 'pdfHtml5', className: 'btn btn-sm btn-danger shadow-sm', text: '<i class="fas fa-file-pdf"></i> PDF'},
                                                                        {extend: 'print', className: 'btn btn-sm btn-secondary shadow-sm', text: '<i class="fas fa-print"></i> Print'}
                                                                    ],
                                                                    "language": {
                                                                        "search": "Search Proposals:",
                                                                        "zeroRecords": "No proposals found matching your search.",
                                                                        "emptyTable": "No academic proposals available."
                                                                    }
                                                                });

                                                                $('#statusFilter').on('change', function () {
                                                                    table.column(5).search($(this).val()).draw();
                                                                });
                                                                $('#dateSort').on('change', function () {
                                                                    table.order([4, $(this).val()]).draw();
                                                                });
                                                                $('#resetFilters').on('click', function () {
                                                                    $('#statusFilter').val('');
                                                                    $('#dateSort').val('desc');
                                                                    table.search('').columns().search('').order([4, 'desc']).draw();
                                                                });

                                                                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                                                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                                    return new bootstrap.Tooltip(tooltipTriggerEl);
                                                                });
                                                            });
        </script>
    </body>
</html>