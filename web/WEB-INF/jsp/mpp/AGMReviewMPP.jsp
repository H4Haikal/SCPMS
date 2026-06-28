<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>AGM Review | MPP</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="top-header mb-4 d-flex align-items-center">
                <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                    <i class="fas fa-bars fa-lg"></i>
                </button>
                <div>
                    <h3 class="fw-bold mb-0 text-primary"><i class="fas fa-tasks me-2"></i>AGM Report Review (MPP)</h3>
                    <p class="text-muted mt-1 mb-0">Filter, sort, and review club submissions.</p>
                </div>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm"><i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}<button class="btn-close" data-bs-dismiss="alert"></button></div><c:remove var="successMessage" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm"><i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.errorMessage}<button class="btn-close" data-bs-dismiss="alert"></button></div><c:remove var="errorMessage" scope="session"/>
                    </c:if>

            <div class="row mb-3 g-3">
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-muted mb-1">Filter by Cluster</label>
                    <select id="clusterFilter" class="form-select form-select-sm shadow-sm">
                        <option value="">All Clusters</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-muted mb-1">Filter by Year</label>
                    <select id="yearFilter" class="form-select form-select-sm shadow-sm">
                        <option value="">All Years</option>
                    </select>
                </div>
            </div>

            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-body p-4">
                    <div class="table-responsive">
                        <table id="agmTable" class="table table-hover align-middle w-100">
                            <thead class="table-dark">
                                <tr>
                                    <th>Club Name</th>
                                    <th>Cluster</th>
                                    <th>Year</th>
                                    <th>Submitted Date</th>
                                    <th>Status</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${allReports}">
                                    <tr>
                                        <td class="fw-bold">${a.clubName}</td>
                                        <td><span class="badge bg-secondary">${not empty a.cluster ? a.cluster : 'General'}</span></td>
                                        <td>${a.reportYear}</td>
                                        <td data-order="${a.submittedAt.time}"><fmt:formatDate value="${a.submittedAt}" pattern="dd MMM yyyy, HH:mm" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.status == 'Pending_MPP'}"><span class="badge bg-warning text-dark"><i class="fas fa-hourglass-half me-1"></i>Pending Review</span></c:when>
                                                <c:when test="${a.status == 'Pending_HEPA'}"><span class="badge bg-info text-dark"><i class="fas fa-check me-1"></i>Endorsed</span></c:when>
                                                <c:when test="${a.status == 'Accepted'}"><span class="badge bg-success"><i class="fas fa-check-double me-1"></i>Approved</span></c:when>
                                                <c:when test="${a.status == 'Missing'}"><span class="badge bg-danger"><i class="fas fa-times me-1"></i>Rejected</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/viewAGM?file=${a.reportPath}" target="_blank" class="btn btn-sm btn-outline-dark rounded-pill"><i class="fas fa-eye"></i> View</a>
                                            <c:if test="${a.status == 'Pending_MPP'}">
                                                <form action="${pageContext.request.contextPath}/mpp/agm" method="POST" style="display:inline;">
                                                    <input type="hidden" name="action" value="updateStatus"><input type="hidden" name="status" value="accepted"><input type="hidden" name="agmId" value="${a.agmId}"><input type="hidden" name="clubId" value="${a.clubId}"><input type="hidden" name="year" value="${a.reportYear}">
                                                    <button type="submit" class="btn btn-sm btn-success rounded-pill ms-1" onclick="return confirm('Endorse this report to HEPA?')"><i class="fas fa-check"></i> Endorse</button>
                                                </form>
                                                <button type="button" class="btn btn-sm btn-danger rounded-pill ms-1" data-bs-toggle="modal" data-bs-target="#rejectModal${a.agmId}"><i class="fas fa-times"></i> Reject</button>
                                            </c:if>
                                        </td>
                                    </tr>

                                <div class="modal fade" id="rejectModal${a.agmId}" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered"><div class="modal-content">
                                            <form action="${pageContext.request.contextPath}/mpp/agm" method="POST">
                                                <div class="modal-header bg-danger text-white"><h5 class="modal-title">Reject Report: ${a.clubName}</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="updateStatus"><input type="hidden" name="status" value="missing"><input type="hidden" name="agmId" value="${a.agmId}"><input type="hidden" name="clubId" value="${a.clubId}"><input type="hidden" name="year" value="${a.reportYear}">
                                                    <label class="form-label fw-bold">Rejection Remarks</label>
                                                    <textarea name="remarks" class="form-control" rows="3" placeholder="State specific reasons for rejection..." required></textarea>
                                                </div>
                                                <div class="modal-footer"><button type="submit" class="btn btn-danger w-100">Submit Rejection</button></div>
                                            </form>
                                        </div></div>
                                </div>
                            </c:forEach>
                            </tbody>
                        </table>
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
                                                            var table = $('#agmTable').DataTable({
                                                                "order": [[3, "desc"]], // Sort by Submitted Date (Column index 3) Descending by default
                                                                "language": {
                                                                    "search": "Search Clubs:",
                                                                    "lengthMenu": "Show _MENU_ entries"
                                                                },
                                                                initComplete: function () {
                                                                    // Populate Cluster Dropdown (Column index 1)
                                                                    this.api().column(1).every(function () {
                                                                        var column = this;
                                                                        var select = $('#clusterFilter').on('change', function () {
                                                                            var val = $.fn.dataTable.util.escapeRegex($(this).val());
                                                                            column.search(val ? '^' + val + '$' : '', true, false).draw();
                                                                        });
                                                                        column.data().unique().sort().each(function (d, j) {
                                                                            var cleanText = $('<div>').html(d).text(); // Strips HTML tags like badges
                                                                            select.append('<option value="' + cleanText + '">' + cleanText + '</option>');
                                                                        });
                                                                    });

                                                                    // Populate Year Dropdown (Column index 2)
                                                                    this.api().column(2).every(function () {
                                                                        var column = this;
                                                                        var select = $('#yearFilter').on('change', function () {
                                                                            var val = $.fn.dataTable.util.escapeRegex($(this).val());
                                                                            column.search(val ? '^' + val + '$' : '', true, false).draw();
                                                                        });
                                                                        column.data().unique().sort().each(function (d, j) {
                                                                            select.append('<option value="' + d + '">' + d + '</option>');
                                                                        });
                                                                    });
                                                                }
                                                            });
                                                        });
        </script>
    </body>
</html>