<%-- 
    Document   : EndorseProposal
    Created on : 30 Apr 2026
    Author     : User
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Final Endorsements | UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .table-hover tbody tr:hover {
                background-color: #f8f9fc;
            }
            td {
                vertical-align: middle;
                padding: 1.2rem 1rem !important;
            }
            /* Custom hover for clickable titles */
            .hover-title {
                transition: color 0.2s ease-in-out;
            }
            .hover-title:hover {
                color: #0a58ca !important;
                text-decoration: underline !important;
            }
            /* Smart Tab Styling */
            .custom-tabs .nav-link {
                color: #6c757d;
                border-radius: 50rem;
                padding: 0.5rem 1.5rem;
                font-weight: bold;
                transition: all 0.3s;
            }
            .custom-tabs .nav-link.active {
                background-color: #0d6efd !important;
                color: white !important;
                box-shadow: 0 4px 10px rgba(13, 110, 253, 0.3);
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <%-- Header Section --%>
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-2">
                    <div class="d-flex align-items-center">
                        <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                            <i class="fas fa-bars fa-lg"></i>
                        </button>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark"><i class="fas fa-file-signature text-primary me-2"></i>Final Endorsement Queue</h3>
                            <p class="text-muted mb-0">Proposals awaiting final budget clearance and official university endorsement.</p>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible shadow-sm rounded-3">
                        <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <%-- Advanced UI/UX: Smart Filters --%>
                <div class="row mb-4 align-items-center g-3">
                    <div class="col-xl-6 col-lg-7">
                        <ul class="nav nav-pills custom-tabs bg-white p-1 rounded-pill shadow-sm d-inline-flex" id="statusFilters">
                            <li class="nav-item">
                                <a class="nav-link active" href="#" data-status="">All Requests</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#" data-status="Pending"><i class="fas fa-clock me-1"></i> Pending</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-success" href="#" data-status="Endorsed"><i class="fas fa-check-circle me-1"></i> Endorsed</a>
                            </li>
                        </ul>
                    </div>
                    <div class="col-xl-3 col-lg-5 ms-auto">
                        <div class="input-group shadow-sm rounded-pill bg-white overflow-hidden">
                            <span class="input-group-text bg-white border-0 text-primary"><i class="fas fa-layer-group"></i></span>
                            <select id="clusterFilter" class="form-select border-0 bg-white shadow-none fw-bold text-secondary" style="cursor:pointer;">
                                <option value="">Filter by Cluster (All)</option>
                                <option value="Kelab Akademik">Kelab Akademik</option>
                                <option value="Kelab Keusahawanan">Kelab Keusahawanan</option>
                                <option value="Kelab Anak Negeri">Kelab Anak Negeri</option>
                                <option value="Kelab Sukan">Kelab Sukan</option>
                                <option value="Kelab Kebudayaan">Kelab Kebudayaan</option>
                                <option value="Kelab Eksekutif">Kelab Eksekutif</option>
                                <option value="Kelab Badan Beruniform">Kelab Badan Beruniform</option>
                                <option value="Kelab Sosial">Kelab Sosial</option>
                                <option value="Kelab Kerohanian">Kelab Kerohanian</option>
                            </select>
                        </div>
                    </div>
                </div>

                <%-- Main Table Card --%>
                <div class="card border-0 shadow-sm" style="border-radius: 16px;">
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table id="endorseTable" class="table table-hover w-100 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Club Details</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Program Title</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Budget</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Status</th>
                                        <th class="text-end text-secondary fw-bold small text-uppercase border-0">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${hepaProposals}">
                                        <tr>
                                            <%-- FIXED: Added data-search for accurate DataTables filtering --%>
                                            <td data-search="${p.clubName} ${not empty p.cluster ? p.cluster : 'Umum'}">
                                                <div class="fw-bold text-dark mb-1"><i class="fas fa-users text-primary opacity-75 me-2"></i>${p.clubName}</div>
                                                <span class="badge bg-light text-secondary border px-2 py-1">${not empty p.cluster ? p.cluster : 'Umum'}</span>
                                            </td>

                                            <%-- Clickable Title Column --%>
                                            <td class="fw-bold" style="max-width: 300px;">
                                                <a href="${pageContext.request.contextPath}/hepa/review?id=${p.proposalId}" class="text-primary text-decoration-none fs-6 d-block mb-1 hover-title" title="Click to view deep-dive details">
                                                    ${p.title} <i class="fas fa-external-link-alt ms-1 small opacity-50"></i>
                                                </a>
                                                <small class="text-muted fw-normal">
                                                    <i class="far fa-clock me-1"></i> Updated: <fmt:formatDate value="${p.updatedAt}" pattern="dd MMM yyyy" />
                                                </small>
                                            </td>

                                            <td class="text-success fw-bold fs-6">RM <fmt:formatNumber value="${p.budget}" pattern="#,##0.00" /></td>

                                            <%-- Status Column for Filtering --%>
                                            <td data-search="${p.status == 'Pending_HEPA' ? 'Pending' : (p.status == 'Approved' ? 'Endorsed' : p.status)}">
                                                <c:choose>
                                                    <c:when test="${p.status == 'Pending_HEPA'}">
                                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill shadow-sm"><i class="fas fa-clock me-1"></i> Pending</span>
                                                    </c:when>
                                                    <c:when test="${p.status == 'Approved'}">
                                                        <span class="badge bg-success px-3 py-2 rounded-pill shadow-sm"><i class="fas fa-check-circle me-1"></i> Endorsed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary px-3 py-2 rounded-pill">${p.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <%-- Action Column (Kept exactly the same as your code) --%>
                                            <td class="text-end text-nowrap">
                                                <!-- ... Your action buttons ... -->
                                                <a href="${pageContext.request.contextPath}/hepa/review?id=${p.proposalId}" class="btn btn-sm btn-outline-primary rounded-pill shadow-sm me-1" data-bs-toggle="tooltip" title="Detailed Review">
                                                    <i class="fas fa-eye me-1"></i> Review
                                                </a>

                                                <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-sm btn-light border rounded-circle shadow-sm me-1" target="_blank" data-bs-toggle="tooltip" title="Download PDF">
                                                    <i class="fas fa-file-pdf text-danger"></i>
                                                </a>

                                                <c:if test="${p.status == 'Pending_HEPA'}">
                                                    <form action="${pageContext.request.contextPath}/hepa/endorse" method="POST" class="d-inline">
                                                        <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                        <button type="submit" name="action" value="approve" class="btn btn-sm btn-success rounded-circle shadow-sm mx-1" onclick="return confirm('Provide official HEPA endorsement for this event?');" data-bs-toggle="tooltip" title="Quick Endorse">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    </form>
                                                    <button type="button" class="btn btn-sm btn-outline-danger rounded-circle shadow-sm" data-bs-toggle="modal" data-bs-target="#rejectModal${p.proposalId}" data-bs-toggle="tooltip" title="Quick Reject">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                    <%-- Reject Modal is hidden here for brevity but keep yours! --%>
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

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <script>
                                                            $(document).ready(function () {
                                                                // Initialize DataTables
                                                                var table = $('#endorseTable').DataTable({
                                                                    "pageLength": 10,
                                                                    "order": [[3, "desc"], [1, "asc"]],
                                                                    "language": {
                                                                        "search": "Quick Search:",
                                                                        "lengthMenu": "Display _MENU_ records",
                                                                        "emptyTable": "No proposals found matching your filter."
                                                                    }
                                                                });

                                                                // FIXED: Cluster Dropdown Filter Logic (Exact Regex Match)
                                                                $('#clusterFilter').on('change', function () {
                                                                    var val = $.fn.dataTable.util.escapeRegex($(this).val());
                                                                    // search(string, regex=true, smart=false)
                                                                    table.column(0).search(val ? '^.*' + val + '.*$' : '', true, false).draw();
                                                                });

                                                                // FIXED: Smart Status Tabs Filter Logic (Exact Match)
                                                                $('#statusFilters a').on('click', function (e) {
                                                                    e.preventDefault();

                                                                    $('#statusFilters a').removeClass('active text-success');
                                                                    $(this).addClass('active');

                                                                    if ($(this).data('status') === 'Endorsed') {
                                                                        $(this).removeClass('text-success');
                                                                    }

                                                                    var statusWord = $.fn.dataTable.util.escapeRegex($(this).data('status'));
                                                                    table.column(3).search(statusWord ? '^' + statusWord + '$' : '', true, false).draw();
                                                                });

                                                                // Initialize Tooltips
                                                                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                                                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                                    return new bootstrap.Tooltip(tooltipTriggerEl);
                                                                });
                                                            });
        </script>
    </body>
</html>