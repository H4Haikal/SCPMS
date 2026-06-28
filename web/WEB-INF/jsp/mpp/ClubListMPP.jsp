<%-- 
    Document   : ClubListMPP.jsp
    Created on : 27 Dec 2025
    Author     : Haikal Danial
    Purpose    : MPP Club Management (View, Assign President, AGM Reminder ONLY)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Clubs - UMT ClubSphere</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            th.sortable {
                cursor: pointer;
                position: relative;
            }
            th.sortable:hover {
                background-color: #343a40;
            }
            th.sortable::after {
                content: '\f0dc';
                font-family: "Font Awesome 6 Free";
                font-weight: 900;
                position: absolute;
                right: 10px;
                opacity: 0.3;
            }
            .class-hover:hover {
                opacity: 0.8;
                cursor: pointer;
                transform: scale(1.05);
                transition: all 0.2s;
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="top-header">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <i class="fas fa-users-cog fa-2x text-primary me-4 d-none d-lg-block"></i>
                    <h3 class="fw-bold mb-0">Club Directory</h3>
                </div>
            </div>

            <div class="welcome-card mb-4">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h2>Club Monitoring (MPP View)</h2>
                        <p class="lead mb-0 opacity-90">
                            Monitor club activities, assign club presidents, and track AGM report submissions.<br>
                            <small class="text-warning"><i class="fas fa-info-circle me-1"></i> Registration and deletion of clubs are managed by HEPA.</small>
                        </p>
                    </div>
                    <div class="col-md-4 text-md-end">
                        <div class="bg-white text-primary rounded-circle d-inline-flex align-items-center justify-content-center"
                             style="width: 100px; height: 100px; font-size: 3.5rem;">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show mb-4 shadow-sm" role="alert">
                    <i class="fas fa-check-circle me-2"></i> <strong>${message}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4 shadow-sm" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> <strong>${errorMessage}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                <div class="card-header bg-white py-3">
                    <div class="row g-3 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" id="searchInput" class="form-control border-start-0 bg-light" placeholder="Search clubs by name...">
                            </div>
                        </div>

                        <div class="col-md-4">
                            <select id="clusterFilter" class="form-select bg-light">
                                <option value="all">All Clusters</option>
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

                        <div class="col-md-3">
                            <select id="statusFilter" class="form-select bg-light">
                                <option value="all">All Status</option>
                                <option value="active">Active</option>
                                <option value="suspended">Suspended</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="clubTable">
                        <thead class="table-dark">
                            <tr>
                                <th style="width: 50px;" class="ps-3">No</th> 
                                <th style="width: 80px;">ID</th>
                                <th class="sortable" onclick="sortTable(2)">Name</th>
                                <th class="sortable" onclick="sortTable(3)">Cluster</th>
                                <th class="sortable" onclick="sortTable(4)">Est. Year</th>
                                <th style="min-width: 180px;">President</th> 
                                <th>Last AGM</th>
                                <th class="pe-3">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="club" items="${clubs}" varStatus="loop">
                                <tr class="club-row" data-cluster="${club.cluster}" data-status="${club.status}">

                                    <td class="text-secondary fw-bold ps-3">${loop.count}</td>
                                    <td><small class="text-muted">#${club.clubId}</small></td>
                                    <td class="fw-bold text-primary">
                                        <a href="#" class="text-decoration-none text-primary" 
                                           data-bs-toggle="modal" data-bs-target="#viewModal${club.clubId}" title="View Club Profile">
                                            ${club.clubName}
                                        </a>
                                    </td>
                                    <td><span class="badge bg-light text-dark border">${club.cluster}</span></td>
                                    <td>${club.establishedYear}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${club.presidentName == 'Vacant' || club.presidentName == null}">
                                                <button class="btn btn-sm btn-outline-secondary rounded-pill px-3" 
                                                        data-bs-toggle="modal" data-bs-target="#assignPresModal${club.clubId}">
                                                    <i class="fas fa-plus-circle me-1"></i> Assign
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" 
                                                         style="width: 32px; height: 32px; font-size: 0.8rem;">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <a href="#" class="text-dark text-decoration-none fw-bold" 
                                                       data-bs-toggle="modal" data-bs-target="#managePresModal${club.clubId}" title="Click to Manage Leadership">
                                                        ${club.presidentName}
                                                    </a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${club.lastAGMStatus eq 'missing' || club.lastAGMStatus eq 'Missing'}">
                                                <a href="#" class="text-decoration-none" data-bs-toggle="modal" data-bs-target="#missingAGMModal${club.clubId}">
                                                    <span class="badge rounded-pill bg-danger class-hover"><i class="fas fa-times me-1"></i> Missing</span>
                                                </a>
                                            </c:when>
                                            <c:when test="${club.lastAGMStatus eq 'Submitted'}">
                                                <a href="#" class="text-decoration-none" data-bs-toggle="modal" data-bs-target="#reviewAGMModal${club.clubId}">
                                                    <span class="badge rounded-pill bg-warning text-dark class-hover"><i class="fas fa-clock me-1"></i> Pending Review</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="#" class="text-decoration-none" data-bs-toggle="modal" data-bs-target="#acceptedAGMModal${club.clubId}">
                                                    <span class="badge rounded-pill bg-success class-hover"><i class="fas fa-check-circle me-1"></i> Accepted</span>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>

                                        <%-- MODALS UNTUK AGM --%>
                                        <c:if test="${club.lastAGMStatus eq 'Submitted'}">
                                            <div class="modal fade text-start" id="reviewAGMModal${club.clubId}" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header bg-warning">
                                                            <h5 class="modal-title text-dark"><i class="fas fa-file-contract me-2"></i>Review AGM Report</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p><strong>Club:</strong> ${club.clubName}</p>
                                                            <p><strong>Submitted Date:</strong> ${club.agmSubmissionDate}</p>
                                                            <div class="card bg-light border-0 p-3 mb-3 text-center">
                                                                <i class="fas fa-file-pdf fa-3x text-danger mb-2"></i><br>
                                                                <a href="${pageContext.request.contextPath}/viewAGM?file=${club.agmReportPath}" class="btn btn-sm btn-outline-dark" download>
                                                                    <i class="fas fa-download me-1"></i> Download Submitted Report
                                                                </a>
                                                            </div>
                                                            <p class="small text-muted">Review the document. If it meets requirements, accept it.</p>
                                                        </div>
                                                        <div class="modal-footer justify-content-between">
                                                            <form action="${pageContext.request.contextPath}/mpp/club" method="post">
                                                                <input type="hidden" name="action" value="reviewAGM">
                                                                <input type="hidden" name="clubId" value="${club.clubId}">
                                                                <input type="hidden" name="decision" value="missing">
                                                                <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Reject this report?');"><i class="fas fa-times me-1"></i> Reject</button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/mpp/club" method="post">
                                                                <input type="hidden" name="action" value="reviewAGM">
                                                                <input type="hidden" name="clubId" value="${club.clubId}">
                                                                <input type="hidden" name="decision" value="accepted">
                                                                <button type="submit" class="btn btn-success"><i class="fas fa-check me-1"></i> Accept Report</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>

                                        <c:if test="${club.lastAGMStatus eq 'missing' || club.lastAGMStatus eq 'Missing'}">
                                            <div class="modal fade text-start" id="missingAGMModal${club.clubId}" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header bg-danger text-white">
                                                            <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i>Missing AGM Report</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body text-center">
                                                            <div class="mb-3"><i class="fas fa-file-excel fa-4x ${club.agmReminderCount > 2 ? 'text-dark' : 'text-danger'} opacity-50"></i></div>
                                                            <h5 class="fw-bold text-danger">Non-Compliance Alert</h5>
                                                            <p class="mb-2"><strong>${club.clubName}</strong> has not submitted their AGM report.</p>
                                                            <div class="mb-3"><span class="badge rounded-pill ${club.agmReminderCount > 2 ? 'bg-danger' : 'bg-warning text-dark'} px-3 py-2"><i class="fas fa-bullhorn me-2"></i> Official Reminders Sent: <strong>${club.agmReminderCount}</strong></span></div>
                                                            <div class="alert alert-light text-start border small shadow-sm">
                                                                <strong><i class="fas fa-info-circle text-primary"></i> Action Required:</strong><br>
                                                                <ul class="mb-0 ps-3 mt-1"><li>Clubs must submit reports within 30 days of AGM.</li><li><strong>Recommendation:</strong> If reminders > 3, consider Suspension.</li></ul>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer justify-content-center bg-light">
                                                            <form action="${pageContext.request.contextPath}/mpp/club" method="post" class="w-100">
                                                                <input type="hidden" name="action" value="remindAGM">
                                                                <input type="hidden" name="clubId" value="${club.clubId}">
                                                                <button type="submit" class="btn btn-warning w-100 fw-bold shadow-sm"><i class="fas fa-bell me-2"></i> Send Reminder</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>

                                        <c:if test="${club.lastAGMStatus eq 'Accepted' || club.lastAGMStatus eq 'accepted'}">
                                            <div class="modal fade text-start" id="acceptedAGMModal${club.clubId}" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header bg-success text-white">
                                                            <h5 class="modal-title"><i class="fas fa-check-circle me-2"></i>AGM Report Verified</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body text-center">
                                                            <div class="mb-3"><i class="fas fa-clipboard-check fa-4x text-success opacity-50"></i></div>
                                                            <h5 class="fw-bold text-success">Fully Compliant</h5>
                                                            <p>The AGM report for <strong>${club.clubName}</strong> has been reviewed and accepted.</p>
                                                            <div class="card bg-light border-0 p-3 mb-0 text-center">
                                                                <p class="mb-2 small text-muted">Need to reference the file?</p>
                                                                <a href="${pageContext.request.contextPath}${club.agmReportPath}" class="btn btn-sm btn-outline-success" download><i class="fas fa-download me-1"></i> Download Accepted Report</a>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer bg-light">
                                                            <form action="${pageContext.request.contextPath}/mpp/club" method="post" class="me-auto">
                                                                <input type="hidden" name="action" value="reviewAGM">
                                                                <input type="hidden" name="clubId" value="${club.clubId}">
                                                                <input type="hidden" name="decision" value="Submitted">
                                                                <button type="submit" class="btn btn-sm btn-link text-muted text-decoration-none" onclick="return confirm('Undo acceptance?');"><i class="fas fa-undo me-1"></i> Revert to Pending</button>
                                                            </form>
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </td>

                                    <td class="pe-3">
                                        <span class="badge rounded-pill bg-${club.status == 'active' ? 'success' : club.status == 'suspended' ? 'warning text-dark' : 'secondary'}">
                                            ${club.status}
                                        </span>
                                    </td>

                                    <%-- Manage President Modal --%>
                            <div class="modal fade text-start" id="managePresModal${club.clubId}" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content">
                                        <div class="modal-header bg-dark text-white">
                                            <h5 class="modal-title"><i class="fas fa-user-cog me-2"></i>Manage Leadership</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body text-center pt-4">
                                            <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center border mb-3" style="width: 80px; height: 80px;">
                                                <i class="fas fa-user fa-3x text-secondary"></i>
                                            </div>
                                            <h4 class="fw-bold">${club.presidentName}</h4>
                                            <p class="text-muted mb-4">Current President of ${club.clubName}</p>

                                            <div class="row g-2">
                                                <div class="col-6">
                                                    <button class="btn btn-outline-warning w-100 py-3" 
                                                            data-bs-toggle="modal" data-bs-target="#assignPresModal${club.clubId}">
                                                        <i class="fas fa-exchange-alt fa-2x mb-2"></i><br>
                                                        <strong>Replace</strong>
                                                        <div class="small text-muted mt-1" style="font-size: 0.75rem;">Appoint a new student</div>
                                                    </button>
                                                </div>
                                                <div class="col-6">
                                                    <form action="${pageContext.request.contextPath}/mpp/club" method="post" 
                                                          onsubmit="return confirm('Confirm Removal?\n\nThis will leave the President position VACANT.');">
                                                        <input type="hidden" name="action" value="removePresident">
                                                        <input type="hidden" name="clubId" value="${club.clubId}">
                                                        <button type="submit" class="btn btn-outline-danger w-100 py-3">
                                                            <i class="fas fa-user-slash fa-2x mb-2"></i><br>
                                                            <strong>Remove</strong>
                                                            <div class="small text-muted mt-1" style="font-size: 0.75rem;">Set position to Vacant</div>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%-- Assign President Modal --%>
                            <div class="modal fade text-start" id="assignPresModal${club.clubId}" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/mpp/club" method="post">
                                            <div class="modal-header bg-success text-white">
                                                <h5 class="modal-title"><i class="fas fa-user-tie me-2"></i>Assign President</h5>
                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="action" value="assignPresident">
                                                <input type="hidden" name="clubId" value="${club.clubId}">
                                                <c:if test="${club.presidentName != 'Vacant'}">
                                                    <div class="alert alert-warning border small">
                                                        <i class="fas fa-exclamation-circle me-1"></i>
                                                        <strong>Warning:</strong> This club currently has a president (<strong>${club.presidentName}</strong>). 
                                                        Proceeding will replace them automatically.
                                                    </div>
                                                </c:if>
                                                <div class="alert alert-info border small">
                                                    <i class="fas fa-envelope text-primary me-1"></i> 
                                                    <strong>System Action:</strong><br>
                                                    A user account (Role: CHC) will be created.<br>
                                                    A <strong>Temporary Password</strong> will be emailed to the student immediately.
                                                </div>

                                                <div class="mb-3"><label class="form-label">Student ID (Matric No)</label><input type="text" name="userId" class="form-control" placeholder="e.g. S12345" required></div>
                                                <div class="mb-3"><label class="form-label">Full Name</label><input type="text" name="fullName" class="form-control" placeholder="e.g. Ali Bin Abu" required></div>
                                                <div class="mb-3"><label class="form-label">Student Email</label><input type="email" name="email" class="form-control" placeholder="e.g. ali@student.umt.edu.my" required></div>
                                            </div>
                                            <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-success">Assign President</button></div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <%-- View Profile Modal --%>
                            <div class="modal fade text-start" id="viewModal${club.clubId}" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content border-0 shadow">
                                        <div class="modal-header bg-primary text-white">
                                            <h5 class="modal-title fw-bold"><i class="fas fa-info-circle me-2"></i>Club Profile</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="text-center mb-4">
                                                <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center border mb-3" style="width: 100px; height: 100px;">
                                                    <img src="${pageContext.request.contextPath}/images/${empty club.logoPath ? 'default_logo.png' : club.logoPath}" 
                                                         alt="Club Logo" class="img-fluid rounded-circle" style="max-height: 80px;">
                                                </div>
                                                <h4 class="fw-bold mb-0">${club.clubName}</h4>
                                                <span class="badge bg-secondary mt-1">${club.cluster}</span>
                                            </div>
                                            <hr>
                                            <div class="row g-3">
                                                <div class="col-6"><small class="text-muted text-uppercase fw-bold">Established</small><p class="mb-0 fw-bold">${club.establishedYear}</p></div>
                                                <div class="col-6"><small class="text-muted text-uppercase fw-bold">Status</small><p class="mb-0"><span class="badge bg-${club.status == 'active' ? 'success' : club.status == 'suspended' ? 'warning' : 'secondary'}">${club.status}</span></p></div>
                                            </div>
                                            <h6 class="text-primary fw-bold mt-4 mb-3 border-bottom pb-2">High Committee</h6>
                                            <div class="d-flex align-items-center mb-3"><div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;"><i class="fas fa-user-tie"></i></div><div><small class="text-muted d-block">President</small><span class="fw-bold text-dark">${club.presidentName}</span></div></div>
                                            <div class="d-flex align-items-center mb-3"><div class="bg-info text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;"><i class="fas fa-pen-fancy"></i></div><div><small class="text-muted d-block">Secretary</small><span class="fw-bold text-dark">${club.secretaryName}</span></div></div>
                                            <div class="d-flex align-items-center"><div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;"><i class="fas fa-wallet"></i></div><div><small class="text-muted d-block">Treasurer</small><span class="fw-bold text-dark">${club.treasurerName}</span></div></div>
                                        </div>
                                        <div class="modal-footer bg-light"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button></div>
                                    </div>
                                </div>
                            </div>

                            </tr>
                        </c:forEach>

                        <tr id="noResultsRow" style="display: none;">
                            <td colspan="8" class="text-center py-5 text-muted">
                                <i class="fas fa-search fa-3x mb-3 opacity-25"></i><br>
                                No clubs found matching your search.
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                              // 1. FILTERING LOGIC (SMARTER MATCHING)
                                                              const searchInput = document.getElementById('searchInput');
                                                              const clusterFilter = document.getElementById('clusterFilter');
                                                              const statusFilter = document.getElementById('statusFilter');
                                                              const tableRows = document.querySelectorAll('.club-row');
                                                              const noResultsRow = document.getElementById('noResultsRow');

                                                              function filterTable() {
                                                                  const searchText = searchInput.value.toLowerCase().trim();
                                                                  const selectedCluster = clusterFilter.value.toLowerCase().trim();
                                                                  const selectedStatus = statusFilter.value.toLowerCase().trim();
                                                                  let visibleCount = 0;

                                                                  tableRows.forEach(row => {
                                                                      const clubName = row.children[2].textContent.toLowerCase();

                                                                      // Ambil data dari attribute dan formatkan jadi huruf kecil & buang space tepi
                                                                      const clubCluster = (row.getAttribute('data-cluster') || '').toLowerCase().trim();
                                                                      const clubStatus = (row.getAttribute('data-status') || '').toLowerCase().trim();

                                                                      // Semak Search
                                                                      const matchesSearch = clubName.includes(searchText);

                                                                      // Semak Status
                                                                      const matchesStatus = (selectedStatus === 'all') || (clubStatus === selectedStatus);

                                                                      // Semak Kluster (SMART MATCH: Sama ada DB="Sukan" & Dropdown="Kelab Sukan", ia tetap jumpa)
                                                                      let matchesCluster = false;
                                                                      if (selectedCluster === 'all') {
                                                                          matchesCluster = true;
                                                                      } else if (clubCluster !== '') {
                                                                          // Jika dropdown sebut "kelab sukan" dan DB sebut "sukan", atau sebaliknya
                                                                          if (clubCluster === selectedCluster ||
                                                                                  selectedCluster.includes(clubCluster) ||
                                                                                  clubCluster.includes(selectedCluster)) {
                                                                              matchesCluster = true;
                                                                          }
                                                                      }

                                                                      // Jika lepas ketiga-tiga tapisan, tunjukkan baris
                                                                      if (matchesSearch && matchesCluster && matchesStatus) {
                                                                          row.style.display = '';
                                                                          visibleCount++;
                                                                      } else {
                                                                          row.style.display = 'none';
                                                                      }
                                                                  });

                                                                  noResultsRow.style.display = visibleCount === 0 ? '' : 'none';
                                                              }

                                                              searchInput.addEventListener('keyup', filterTable);
                                                              clusterFilter.addEventListener('change', filterTable);
                                                              statusFilter.addEventListener('change', filterTable);

                                                              // 2. SORTING LOGIC
                                                              function sortTable(n) {
                                                                  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                                                                  table = document.getElementById("clubTable");
                                                                  switching = true;
                                                                  dir = "asc";
                                                                  while (switching) {
                                                                      switching = false;
                                                                      rows = table.rows;
                                                                      for (i = 1; i < (rows.length - 2); i++) {
                                                                          shouldSwitch = false;
                                                                          x = rows[i].getElementsByTagName("TD")[n];
                                                                          y = rows[i + 1].getElementsByTagName("TD")[n];
                                                                          if (rows[i].style.display === 'none' || rows[i + 1].style.display === 'none')
                                                                              continue;
                                                                          if (dir == "asc") {
                                                                              if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                                                                                  shouldSwitch = true;
                                                                                  break;
                                                                              }
                                                                          } else if (dir == "desc") {
                                                                              if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                                                                                  shouldSwitch = true;
                                                                                  break;
                                                                              }
                                                                          }
                                                                      }
                                                                      if (shouldSwitch) {
                                                                          rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                                                                          switching = true;
                                                                          switchcount++;
                                                                      } else {
                                                                          if (switchcount == 0 && dir == "asc") {
                                                                              dir = "desc";
                                                                              switching = true;
                                                                          }
                                                                      }
                                                                  }
                                                              }
        </script>
    </body>
</html>