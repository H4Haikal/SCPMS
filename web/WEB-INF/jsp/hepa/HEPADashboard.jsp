<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HEPA Command Center | UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            :root {
                --hepa-color: #1e3a8a; /* Corporate Navy Blue for HEPA */
                --hepa-light: #eff6ff;
            }
            .text-hepa {
                color: var(--hepa-color) !important;
            }
            .bg-hepa {
                background-color: var(--hepa-color) !important;
                color: white;
            }
            .btn-hepa {
                background-color: var(--hepa-color);
                color: white;
                border-radius: 50px;
                transition: 0.3s;
            }
            .btn-hepa:hover {
                background-color: #172554;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(30, 58, 138, 0.2);
            }

            /* Executive Stat Cards */
            .stat-card {
                border-radius: 16px;
                border: none;
                transition: transform 0.2s;
                position: relative;
                overflow: hidden;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .stat-card::after {
                content: '';
                position: absolute;
                right: -20px;
                bottom: -20px;
                width: 100px;
                height: 100px;
                background: rgba(255,255,255,0.1);
                border-radius: 50%;
            }
            .stat-title {
                font-size: 0.8rem;
                font-weight: 700;
                letter-spacing: 1px;
                text-transform: uppercase;
                opacity: 0.8;
            }
            .stat-value {
                font-size: 2.2rem;
                font-weight: 800;
                margin-top: 5px;
            }

            /* Table Styling */
            .table-hover tbody tr:hover {
                background-color: var(--hepa-light);
            }
            td {
                vertical-align: middle;
                padding: 1rem !important;
            }
            .dt-buttons .btn {
                border-radius: 8px;
                font-weight: bold;
                font-size: 0.85rem;
                margin-right: 5px;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <%-- Top Header --%>
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-2">
                    <div class="d-flex align-items-center">
                        <button class="btn btn-light text-hepa me-3 d-lg-none shadow-sm" id="sidebarToggle"><i class="fas fa-bars fa-lg"></i></button>
                        <div>
                            <h3 class="fw-bold mb-0 text-hepa"><i class="fas fa-building me-2"></i>HEPA Command Center</h3>
                            <p class="text-muted mb-0">University Executive Overview & Proposal Approvals.</p>
                        </div>
                    </div>
                    <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
                </div>

                <%-- Alerts --%>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible shadow-sm rounded-3">
                        <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <%-- Executive Metrics Row --%>
                <div class="row g-4 mb-5">
                    <div class="col-6 col-lg-3">
                        <div class="card stat-card bg-danger text-white shadow-sm h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="stat-title">Action Required</div>
                                        <div class="stat-value">${pendingHepaCount}</div>
                                    </div>
                                    <i class="fas fa-exclamation-circle fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="card stat-card bg-success text-white shadow-sm h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="stat-title">Approved (2026)</div>
                                        <div class="stat-value">${approvedCount}</div>
                                    </div>
                                    <i class="fas fa-check-double fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="card stat-card bg-primary text-white shadow-sm h-100">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="stat-title">Registered Clubs</div>
                                        <div class="stat-value">${activeClubsCount}</div>
                                    </div>
                                    <i class="fas fa-users fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="card stat-card text-white shadow-sm h-100" style="background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);">
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="stat-title">Budget Allocated</div>
                                        <div class="stat-value fs-3 mt-2">RM <fmt:formatNumber value="${totalApprovedBudget}" pattern="#,##0" /></div>
                                    </div>
                                    <i class="fas fa-wallet fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ACTION REQUIRED TABLE (Main Focus) --%>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-inbox text-danger me-2"></i>Pending HEPA Endorsement</h5>
                </div>

                <div class="card border-0 shadow-sm" style="border-radius: 16px;">
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table id="hepaPendingTable" class="table table-hover align-middle w-100">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">No.</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Club Info</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Proposal Details</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Financial Request</th>
                                        <th class="text-end text-secondary fw-bold small text-uppercase border-0 pe-3">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${pendingProposals}" varStatus="loop">
                                        <tr>
                                            <td class="fw-bold text-muted">${loop.index + 1}</td>
                                            <td>
                                                <span class="badge bg-light text-dark border px-2 py-1 shadow-sm mb-1"><i class="fas fa-users text-secondary me-1"></i> ${p.clubName}</span><br>
                                                <small class="text-muted"><i class="fas fa-tags me-1"></i> ${p.category != null ? p.category : p.clubCategory}</small>
                                            </td>
                                            <td style="max-width: 300px;">
                                                <span class="fw-bold text-dark fs-6 d-block text-truncate" title="${p.title}">${p.title}</span>
                                                <small class="text-muted"><i class="far fa-calendar-alt me-1"></i> <fmt:formatDate value="${p.proposedDate}" pattern="dd MMM yyyy" /></small>
                                            </td>
                                            <td>
                                                <div class="text-success fw-bold fs-6">RM <fmt:formatNumber value="${p.budget}" pattern="#,##0.00" /></div>
                                                <c:if test="${p.isBudgetAltered}">
                                                    <span class="badge bg-warning text-dark border" style="font-size:0.65rem;"><i class="fas fa-edit me-1"></i> Modified before HEPA</span>
                                                </c:if>
                                            </td>
                                            <td class="text-end pe-3">
                                                <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-sm btn-light border rounded-circle shadow-sm mx-1" target="_blank" data-bs-toggle="tooltip" title="Quick PDF View">
                                                    <i class="fas fa-file-pdf text-danger"></i>
                                                </a>
                                                <%-- Pautan ke Halaman Semakan HEPA (Akan dibina di Fasa 2) --%>
                                                <a href="${pageContext.request.contextPath}/hepa/review?id=${p.proposalId}" class="btn btn-sm btn-hepa px-3 shadow-sm" data-bs-toggle="tooltip" title="Review & Approve">
                                                    <i class="fas fa-search me-1"></i> Review
                                                </a>
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

        <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>

        <script>
            $(document).ready(function () {
                // Initialise DataTable with Easy Export Buttons for HEPA
                $('#hepaPendingTable').DataTable({
                    "pageLength": 10,
                    "ordering": true,
                    "order": [[0, "asc"]], // Sort by No.
                    "dom": "<'row mb-3'<'col-sm-12 col-md-4'l><'col-sm-12 col-md-4 text-center'f><'col-sm-12 col-md-4 text-end'B>>" +
                            "<'row'<'col-sm-12'tr>>" +
                            "<'row mt-3'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
                    "buttons": [
                        {extend: 'excelHtml5', className: 'btn btn-success shadow-sm', text: '<i class="fas fa-file-excel"></i> Export Excel'},
                        {extend: 'print', className: 'btn btn-secondary shadow-sm', text: '<i class="fas fa-print"></i> Print List'}
                    ],
                    "language": {
                        "search": "",
                        "searchPlaceholder": "Search proposals, clubs...",
                        "zeroRecords": "All clear! No proposals are currently waiting for HEPA approval.",
                        "emptyTable": "All clear! No proposals are currently waiting for HEPA approval."
                    }
                });

                // Tooltips
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            });
        </script>
    </body>
</html>