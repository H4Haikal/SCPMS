<%-- 
    Document   : ClubDirectory
    Created on : 22 Jun 2026, 12:14:47 pm
    Author     : User
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <title>Club Directory | UMT ClubSphere</title>
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
            /* Bento Card UI */
            .bento-card {
                background: white;
                border-radius: 20px;
                border: 1px solid rgba(0,0,0,0.05);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
                overflow: hidden;
            }
            /* Tab Styling */
            .nav-pills .nav-link {
                color: #6c757d;
                border-radius: 50rem;
                padding: 0.75rem 1.5rem;
                margin-right: 0.5rem;
                font-weight: 600;
                transition: all 0.3s ease;
                border: 1px solid transparent;
            }
            .nav-pills .nav-link:hover {
                background-color: #f8f9fa;
                border-color: #e9ecef;
            }
            .nav-pills .nav-link.active {
                background-color: #0d6efd !important;
                color: white !important;
                box-shadow: 0 4px 10px rgba(13, 110, 253, 0.2);
            }
            /* Avatar Styling */
            .avatar-circle {
                width: 45px;
                height: 45px;
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid #e9ecef;
            }
            .avatar-lg {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                border: 4px solid white;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            /* Modal Timeline */
            .timeline-item {
                border-left: 2px solid #e9ecef;
                padding-left: 20px;
                position: relative;
                margin-bottom: 1.5rem;
            }
            .timeline-item::before {
                content: '';
                position: absolute;
                left: -6px;
                top: 0;
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background: #0d6efd;
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
                    <div>
                        <h3 class="fw-bold mb-0 text-primary">
                            <i class="fas fa-address-book me-2 d-none d-lg-inline"></i>Club Directory
                        </h3>
                        <p class="text-muted small mb-0 mt-1">Manage and view profiles for ${clubName}</p>
                    </div>
                </div>
                <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
            </div>

            <%-- TABS NAVIGATION --%>
            <ul class="nav nav-pills mb-4" id="directoryTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="all-tab" data-bs-toggle="pill" data-bs-target="#all" type="button" role="tab">
                        <i class="fas fa-globe me-2"></i>All Members
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="chc-tab" data-bs-toggle="pill" data-bs-target="#chc" type="button" role="tab">
                        <i class="fas fa-crown me-2 text-warning"></i>High Committee (CHC)
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="members-tab" data-bs-toggle="pill" data-bs-target="#members" type="button" role="tab">
                        <i class="fas fa-users me-2"></i>General Members
                    </button>
                </li>
            </ul>

            <%-- TABS CONTENT --%>
            <div class="tab-content" id="directoryTabsContent">

                <%-- TAB 1: ALL DIRECTORY (UNION) --%>
                <div class="tab-pane fade show active" id="all" role="tabpanel">
                    <div class="bento-card p-4">
                        <div class="table-responsive">
                            <table id="allTable" class="table table-hover align-middle w-100">
                                <thead class="table-light text-muted small text-uppercase">
                                    <tr>
                                        <th>Student</th>
                                        <th>Matric No.</th>
                                        <th>Club Role</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty allList}">
                                            <c:forEach var="member" items="${allList}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://ui-avatars.com/api/?name=${member.fullName}&background=random&color=fff" class="avatar-circle me-3" alt="Avatar">
                                                            <div>
                                                                <h6 class="fw-bold mb-0 text-dark">${member.fullName}</h6>
                                                                <span class="text-muted small">${member.faculty}</span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="fw-semibold text-secondary">${member.matricNo}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${member.role == 'Member'}">
                                                                <span class="badge bg-light text-dark border px-3 py-1 rounded-pill">Member</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-primary bg-opacity-10 text-primary border border-primary px-3 py-1 rounded-pill fw-bold">
                                                                    <i class="fas fa-star me-1"></i> ${member.role}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="3" class="text-center py-5">
                                                    <i class="fas fa-users-slash fa-3x text-muted opacity-25 mb-3"></i>
                                                    <h5 class="fw-bold text-dark">No Members Found</h5>
                                                    <p class="text-muted mb-0">The club directory is currently empty.</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <%-- TAB 2: HIGH COMMITTEE (CHC) --%>
                <div class="tab-pane fade" id="chc" role="tabpanel">
                    <div class="bento-card p-4">
                        <div class="table-responsive">
                            <table id="chcTable" class="table table-hover align-middle w-100">
                                <thead class="table-light text-muted small text-uppercase">
                                    <tr>
                                        <th>Student</th>
                                        <th>Matric No.</th>
                                        <th>Role / Position</th>
                                        <th>Contact Info</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty chcList}">
                                            <c:forEach var="member" items="${chcList}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://ui-avatars.com/api/?name=${member.fullName}&background=random&color=fff" class="avatar-circle me-3" alt="Avatar">
                                                            <div>
                                                                <h6 class="fw-bold mb-0 text-dark">${member.fullName}</h6>
                                                                <span class="text-muted small">Sem ${member.semester} • ${member.faculty}</span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="fw-semibold text-secondary">${member.matricNo}</td>
                                                    <td>
                                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill shadow-sm">
                                                            <i class="fas fa-star me-1"></i> ${member.role}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="small">
                                                            <div><i class="fas fa-envelope text-muted me-2"></i>${member.email}</div>
                                                            <div><i class="fas fa-phone text-muted me-2"></i>${member.phone}</div>
                                                        </div>
                                                    </td>
                                                    <td class="text-end">
                                                        <button class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-bold" data-bs-toggle="modal" data-bs-target="#profileModal${member.matricNo}">
                                                            View Profile
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-5">
                                                    <i class="fas fa-users-slash fa-3x text-muted opacity-25 mb-3"></i>
                                                    <h5 class="fw-bold text-dark">No Committee Data</h5>
                                                    <p class="text-muted mb-0">It looks like the CHC data hasn't been fetched from the database yet.</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <%-- TAB 3: GENERAL MEMBERS --%>
                <div class="tab-pane fade" id="members" role="tabpanel">
                    <div class="bento-card p-4">
                        <div class="table-responsive">
                            <table id="membersTable" class="table table-hover align-middle w-100">
                                <thead class="table-light text-muted small text-uppercase">
                                    <tr>
                                        <th>Student</th>
                                        <th>Matric No.</th>
                                        <th>Status</th>
                                        <th>Join Date</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty memberList}">
                                            <c:forEach var="member" items="${memberList}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <img src="https://ui-avatars.com/api/?name=${member.fullName}&background=random&color=fff" class="avatar-circle me-3" alt="Avatar">
                                                            <div>
                                                                <h6 class="fw-bold mb-0 text-dark">${member.fullName}</h6>
                                                                <span class="text-muted small">${member.faculty}</span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="fw-semibold text-secondary">${member.matricNo}</td>
                                                    <td>
                                                        <span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-1 rounded-pill">
                                                            Active
                                                        </span>
                                                    </td>
                                                    <td class="text-muted small">14 Oct 2024</td>
                                                    <td class="text-end">
                                                        <button class="btn btn-sm btn-light border rounded-pill px-3 fw-bold text-primary" data-bs-toggle="modal" data-bs-target="#memberModal${member.matricNo}">
                                                            Details
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-5">
                                                    <i class="fas fa-users fa-3x text-muted opacity-25 mb-3"></i>
                                                    <h5 class="fw-bold text-dark">No Members Data</h5>
                                                    <p class="text-muted mb-0">General member list empty or not yet loaded.</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%-- CHC PROFILE MODALS (Safely outside the table) --%>
        <c:if test="${not empty chcList}">
            <c:forEach var="member" items="${chcList}">
                <div class="modal fade" id="profileModal${member.matricNo}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                            <div class="bg-primary p-4 d-flex align-items-center position-relative">
                                <div class="position-absolute top-0 end-0 p-3">
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <img src="https://ui-avatars.com/api/?name=${member.fullName}&background=ffffff&color=0d6efd" class="avatar-lg me-4" alt="Avatar">
                                <div class="text-white">
                                    <h3 class="fw-bold mb-1">${member.fullName}</h3>
                                    <p class="mb-0 opacity-75">${member.matricNo} • ${member.faculty}</p>
                                    <span class="badge bg-warning text-dark mt-2 px-3 py-1 rounded-pill"><i class="fas fa-star me-1"></i> ${member.role}</span>
                                </div>
                            </div>
                            <div class="modal-body p-4 bg-light">
                                <div class="row g-4">
                                    <div class="col-md-5">
                                        <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Contact Details</h6>
                                            <p class="mb-2 small"><i class="fas fa-envelope text-primary me-2"></i> ${member.email}</p>
                                            <p class="mb-2 small"><i class="fas fa-phone text-success me-2"></i> ${member.phone}</p>
                                            <p class="mb-0 small"><i class="fas fa-calendar-alt text-warning me-2"></i> Joined: Jan 2024</p>

                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3 mt-4">Quick Actions</h6>
                                            <a href="mailto:${member.email}" class="btn btn-outline-primary btn-sm w-100 rounded-pill mb-2"><i class="fas fa-paper-plane me-1"></i> Send Email</a>
                                        </div>
                                    </div>
                                    <div class="col-md-7">
                                        <div class="bg-white p-4 rounded-4 shadow-sm border border-light h-100">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3">Recent Involvement</h6>
                                            <div class="timeline-item">
                                                <div class="fw-bold text-dark small">Current Role</div>
                                                <div class="text-primary small fw-bold">${member.role}</div>
                                                <div class="text-muted small" style="font-size: 0.75rem;">Active Member</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <%-- GENERAL MEMBER PROFILE MODALS --%>
        <c:if test="${not empty memberList}">
            <c:forEach var="member" items="${memberList}">
                <div class="modal fade" id="memberModal${member.matricNo}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-sm">
                        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                            <div class="bg-success p-4 text-center position-relative">
                                <div class="position-absolute top-0 end-0 p-3">
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <img src="https://ui-avatars.com/api/?name=${member.fullName}&background=ffffff&color=198754" class="avatar-lg mx-auto mb-3" alt="Avatar">
                                <div class="text-white">
                                    <h5 class="fw-bold mb-1">${member.fullName}</h5>
                                    <p class="mb-0 opacity-75 small">${member.matricNo} • ${member.faculty}</p>
                                </div>
                            </div>
                            <div class="modal-body p-4 bg-light text-center">
                                <span class="badge bg-success bg-opacity-10 text-success border border-success px-4 py-2 rounded-pill mb-3">
                                    <i class="fas fa-check-circle me-1"></i> Active Member
                                </span>
                                <div class="mt-2">
                                    <a href="mailto:${member.email}" class="btn btn-outline-success btn-sm w-100 rounded-pill">
                                        <i class="fas fa-envelope me-1"></i> Contact Student
                                    </a>
                                </div>
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
                // Initialize all three tables
                var allTable = $('#allTable').DataTable({
                    "language": {
                        "search": "",
                        "searchPlaceholder": "Search entire club...",
                        "lengthMenu": "_MENU_ per page"
                    }
                });

                var chcTable = $('#chcTable').DataTable({
                    "language": {
                        "search": "",
                        "searchPlaceholder": "Search committee...",
                        "lengthMenu": "_MENU_ per page"
                    }
                });

                var membersTable = $('#membersTable').DataTable({
                    "language": {
                        "search": "",
                        "searchPlaceholder": "Search members...",
                        "lengthMenu": "_MENU_ per page"
                    }
                });

                // Style Search Boxes
                $('.dataTables_filter input').addClass('form-control form-control-sm border-0 bg-light rounded-pill px-3 py-2 w-100').css('outline', 'none');

                // Fix DataTables rendering issue when tabs switch
                $('button[data-bs-toggle="pill"]').on('shown.bs.tab', function (e) {
                    $.fn.dataTable.tables({visible: true, api: true}).columns.adjust();
                });


            });
        </script>
    </body>
</html>