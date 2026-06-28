<%-- 
    Document   : ClubMembers
    Created on : 30 Apr 2026, 9:36:15 am
    Author     : User
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${club.clubName} - Members | HEPA</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <!-- Add DataTables CSS for instant searching/sorting -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <%-- Header & Back Button --%>
                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <div>
                        <a href="${pageContext.request.contextPath}/hepa/club" class="btn btn-sm btn-outline-secondary mb-2 rounded-pill shadow-sm">
                            <i class="fas fa-arrow-left me-1"></i> Back to Club Directory
                        </a>
                        <h3 class="fw-bold mb-0 text-dark"><i class="fas fa-users text-primary me-2"></i>Official Member List</h3>
                    </div>
                </div>

                <%-- Club Info Card --%>
                <div class="card border-0 shadow-sm rounded-4 mb-4 bg-primary text-white" style="background: linear-gradient(135deg, #0d47a1 0%, #1976d2 100%);">
                    <div class="card-body p-4 d-flex align-items-center">
                        <div class="bg-white rounded-circle d-flex align-items-center justify-content-center shadow-sm me-4" style="width: 80px; height: 80px;">
                            <img src="${pageContext.request.contextPath}/images/${empty club.logoPath ? 'default_logo.png' : club.logoPath}" alt="Logo" style="max-height: 50px; max-width: 50px; border-radius: 50%;">
                        </div>
                        <div>
                            <h3 class="fw-bold mb-1">${club.clubName}</h3>
                            <p class="mb-0 opacity-75">
                                <i class="fas fa-layer-group me-1"></i> ${club.cluster} &nbsp;|&nbsp; 
                                <i class="fas fa-calendar-alt me-1"></i> Est. ${club.establishedYear}
                            </p>
                        </div>
                    </div>
                </div>

                <%-- Members Table --%>
                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-header bg-white py-3 border-0 border-bottom d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0 text-dark">Club Directory</h5>

                        <!-- ADDED: The Alumni Filter Toggle -->
                        <div class="form-check form-switch mb-0">
                            <input class="form-check-input shadow-sm" type="checkbox" role="switch" id="showAlumniToggle" style="cursor: pointer;">
                            <label class="form-check-label fw-bold text-muted small text-uppercase" for="showAlumniToggle" style="cursor: pointer; padding-top: 2px;">
                                Show Alumni
                            </label>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle w-100" id="membersTable">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Student ID</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Full Name</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Position</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Term Year</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="m" items="${members}">
                                        <tr>
                                            <td>
                                                <span class="badge bg-light text-dark border px-2 py-1"><i class="fas fa-id-card text-muted me-1"></i> ${m.userId}</span>
                                            </td>
                                            <td>
                                                <div class="fw-bold text-dark">${m.fullName}</div>
                                                <small class="text-muted"><i class="fas fa-envelope me-1"></i>${m.email}</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.position == 'Pres'}">
                                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill"><i class="fas fa-crown me-1"></i> President</span>
                                                    </c:when>
                                                    <c:when test="${m.position == 'Secr'}">
                                                        <span class="badge bg-info text-dark px-3 py-2 rounded-pill"><i class="fas fa-pen-fancy me-1"></i> Secretary</span>
                                                    </c:when>
                                                    <c:when test="${m.position == 'Treas'}">
                                                        <span class="badge bg-success px-3 py-2 rounded-pill"><i class="fas fa-wallet me-1"></i> Treasurer</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark border px-3 py-2 rounded-pill"><i class="fas fa-user me-1"></i> Member</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="fw-bold text-secondary">${m.joinYear}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${m.isActive == 1}">
                                                        <span class="text-success fw-bold"><i class="fas fa-check-circle me-1"></i> Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fw-bold"><i class="fas fa-history me-1"></i> Alumni / Past</span>
                                                    </c:otherwise>
                                                </c:choose>
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
                var table = $('#membersTable').DataTable({
                    "pageLength": 15,
                    "order": [[4, "desc"], [2, "desc"]], // Sort Status, then Position
                    "language": {
                        "search": "Search Member:",
                        "zeroRecords": "No members found matching your search or filter.",
                        "emptyTable": "This club currently has no registered members."
                    }
                });

                // Default behavior: Hide Alumni on load (Filter column 4 to only show "Active")
                table.column(4).search('Active').draw();

                // Toggle logic
                $('#showAlumniToggle').on('change', function () {
                    if ($(this).is(':checked')) {
                        // Clear the filter to show everyone
                        table.column(4).search('').draw();
                    } else {
                        // Re-apply the filter to only show "Active"
                        table.column(4).search('Active').draw();
                    }
                });
            });
        </script>
    </body>
</html>