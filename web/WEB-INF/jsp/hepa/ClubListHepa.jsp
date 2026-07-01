<%-- 
    Document   : ClubListHepa.jsp
    Author     : Haikal Danial
    Purpose    : HEPA SuperAdmin Club Health Matrix & Management
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Club Health Matrix (HEPA) - UMT ClubSphere</title>

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
            .folder-card {
                transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
                cursor: pointer;
                border: 2px solid transparent;
            }
            .folder-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 14px 28px rgba(0,0,0,0.1) !important;
                border-color: #0d6efd;
            }
            .breadcrumb-nav {
                cursor: pointer;
                color: #0d6efd;
                font-weight: bold;
            }
            .breadcrumb-nav:hover {
                text-decoration: underline;
            }
            .fade-in-up {
                animation: fadeInUp 0.4s ease-out forwards;
            }
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Traffic Light Dropdown Fixes */
            select.traffic-light {
                color: #fff !important;
                font-weight: bold;
                border: none;
                text-align: center;
            }
            select.traffic-light option {
                background-color: #fff;
                color: #000;
                font-weight: normal;
                text-align: left;
            }
            select.bg-warning.traffic-light {
                color: #212529 !important;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="top-header mb-4">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                            <i class="fas fa-bars fa-lg"></i>
                        </button>
                        <i class="fas fa-heartbeat fa-2x text-primary me-4 d-none d-lg-block"></i>
                        <h3 class="fw-bold mb-0">Club Health Matrix</h3>
                    </div>

                    <div class="btn-group shadow-sm bg-white rounded-pill p-1" role="group">
                        <input type="radio" class="btn-check" name="viewToggle" id="viewTable" autocomplete="off" checked onchange="toggleView('table')">
                        <label class="btn btn-outline-primary border-0 rounded-pill px-4 fw-bold" for="viewTable"><i class="fas fa-list me-1"></i> Matrix</label>

                        <input type="radio" class="btn-check" name="viewToggle" id="viewCard" autocomplete="off" onchange="toggleView('card')">
                        <label class="btn btn-outline-primary border-0 rounded-pill px-4 fw-bold" for="viewCard"><i class="fas fa-th-large me-1"></i> Directory</label>
                    </div>
                </div>
            </div>

            <%-- COMMAND CENTER ACTION CARD --%>
            <div class="welcome-card mb-4 border-start border-5 border-danger bg-white shadow-sm rounded-4 p-4">
                <div class="row align-items-center">
                    <div class="col-md-5">
                        <h4 class="text-danger fw-bold"><i class="fas fa-shield-alt me-2"></i>Administration Hub</h4>
                        <p class="text-muted small mb-0">Monitor club health, AGM submissions, and manage executive access.</p>
                    </div>
                    <div class="col-md-7 text-md-end mt-3 mt-md-0 d-flex flex-wrap justify-content-md-end gap-2">

                        <button class="btn btn-warning shadow-sm rounded-pill px-3 fw-bold text-dark" onclick="alert('Module in Progress: Bulk email will be sent to all clubs with Missing AGMs.')">
                            <i class="fas fa-bell me-1"></i> Remind Missing AGMs
                        </button>

                        <button class="btn btn-outline-dark shadow-sm rounded-pill px-3 fw-bold bg-light" data-bs-toggle="modal" data-bs-target="#studentAuditModal">
                            <i class="fas fa-user-check me-1"></i> Student Audit
                        </button>

                        <button class="btn btn-primary shadow-sm rounded-pill px-3 fw-bold" data-bs-toggle="modal" data-bs-target="#registerModal">
                            <i class="fas fa-plus-circle me-1"></i> New Club
                        </button>

                        <form action="${pageContext.request.contextPath}/hepa/club" method="post" class="m-0" 
                              onsubmit="return confirm('⚠️ EXTREME WARNING ⚠️\n\nAre you sure you want to END THE ACADEMIC SESSION?\n\nThis will instantly revoke system access for ALL current club Presidents and Committee Members. They will become past alumni.\n\nClick OK to proceed.');">
                            <input type="hidden" name="action" value="endSession">
                            <button type="submit" class="btn btn-danger shadow-sm rounded-pill px-3 fw-bold" title="End Academic Session & Revoke All Access">
                                <i class="fas fa-power-off me-1"></i> End Session
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show mb-4 shadow-sm rounded-4" role="alert">
                    <i class="fas fa-check-circle me-2"></i> <strong>${message}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="message" scope="session" />
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4 shadow-sm rounded-4" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> <strong>${errorMessage}</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <%-- CLUB HEALTH MATRIX TABLE --%>
            <div id="tableContainer" class="card border-0 shadow-sm rounded-4 overflow-hidden fade-in-up">
                <div class="card-header bg-white py-3 border-bottom">
                    <div class="row g-3 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 rounded-start-pill"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" id="searchInput" class="form-control border-start-0 bg-light rounded-end-pill" placeholder="Search by club name or ID...">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select id="clusterFilter" class="form-select bg-light rounded-pill">
                                <option value="all">All Clusters</option>
                                <option value="Akademik">Kelab Akademik</option>
                                <option value="Kelab Keusahawanan">Kelab Keusahawanan</option>
                                <option value="Kelab Anak Negeri">Kelab Anak Negeri</option>
                                <option value="Kelab Sukan">Kelab Sukan</option>
                                <option value="Kelab Kebudayaan">Kelab Kebudayaan</option>
                                <option value="Kelab Eksekutif">Kelab Eksekutif</option>
                                <option value="Kelab Badan Beruniform">Kelab Badan Beruniform</option>
                                <option value="Kelab Sosial">Kelab Sosial</option>
                                <option value="Kerohanian">Kelab Kerohanian</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select id="statusFilter" class="form-select bg-light rounded-pill">
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
                                <th style="width: 50px;" class="ps-4">No</th> 
                                <th class="sortable" onclick="sortTable(1)">Club Profile</th>
                                <th>Leadership</th> 
                                <th>Club Status</th>
                                <th>AGM Health</th>
                                <th class="text-end pe-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="club" items="${clubs}" varStatus="loop">
                                <%-- Data attributes for JS engine --%>
                                <tr class="club-row" 
                                    data-id="${club.clubId}" 
                                    data-name="${club.clubName}" 
                                    data-cluster="${club.cluster}" 
                                    data-category="${club.category}" 
                                    data-status="${club.status}" 
                                    data-agm="${club.lastAGMStatus}" 
                                    data-president="${empty club.presidentName ? 'Vacant' : club.presidentName}">

                                    <td class="text-secondary fw-bold ps-4">${loop.count}</td>

                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/images/${empty club.logoPath ? 'default_logo.png' : club.logoPath}" 
                                                 class="rounded-circle shadow-sm me-3 border" style="width: 45px; height: 45px; object-fit: cover;">
                                            <div>
                                                <a href="#" class="text-decoration-none text-primary fw-bold club-name-link fs-6" data-bs-toggle="modal" data-bs-target="#viewModal${club.clubId}" title="View Profile">
                                                    ${club.clubName}
                                                </a>
                                                <div class="small text-muted mt-1">
                                                    ID: #${club.clubId} &nbsp;|&nbsp; <span class="badge bg-light text-dark border club-cluster-badge">${club.cluster}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </td>

                                    <td class="president-name">
                                        <c:choose>
                                            <c:when test="${empty club.presidentName || club.presidentName == 'Vacant'}">
                                                <button class="btn btn-sm btn-outline-danger rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#assignPresModal${club.clubId}">
                                                    <i class="fas fa-exclamation-triangle me-1"></i> Vacant (Assign)
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="#" class="text-dark text-decoration-none fw-bold d-inline-flex align-items-center bg-light px-3 py-1 rounded-pill border" data-bs-toggle="modal" data-bs-target="#managePresModal${club.clubId}" title="Manage Leadership">
                                                    <i class="fas fa-user-circle text-primary me-2"></i> ${club.presidentName}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <form action="${pageContext.request.contextPath}/hepa/club" method="post" class="m-0">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="clubId" value="${club.clubId}">
                                            <select name="status" class="form-select form-select-sm shadow-sm rounded-pill traffic-light px-3
                                                    ${club.status == 'active' ? 'bg-success' : club.status == 'suspended' ? 'bg-warning' : 'bg-danger'}" 
                                                    style="width: 140px; cursor: pointer;" onchange="this.form.submit()">
                                                <option value="active" ${club.status == 'active' ? 'selected' : ''}>&#9679; Active</option>
                                                <option value="suspended" ${club.status == 'suspended' ? 'selected' : ''}>&#9679; Suspended</option>
                                                <option value="inactive" ${club.status == 'inactive' ? 'selected' : ''}>&#9679; Inactive</option>
                                            </select>
                                        </form>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${club.lastAGMStatus == 'Approved'}">
                                                <span class="badge bg-success rounded-pill px-3 py-2 shadow-sm border border-success"><i class="fas fa-check-circle me-1"></i> AGM Approved</span>
                                            </c:when>
                                            <c:when test="${club.lastAGMStatus == 'Pending'}">
                                                <span class="badge bg-warning text-dark rounded-pill px-3 py-2 shadow-sm border border-warning"><i class="fas fa-clock me-1"></i> AGM Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger rounded-pill px-3 py-2 shadow-sm border border-danger"><i class="fas fa-times-circle me-1"></i> AGM Missing</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end pe-4"> 
                                        <button class="btn btn-sm btn-light border text-primary edit-btn rounded-circle" style="width: 32px; height: 32px;" data-bs-toggle="modal" data-bs-target="#editModal${club.clubId}" title="Edit Details">
                                            <i class="fas fa-pen"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/hepa/club" method="post" class="d-inline" onsubmit="return confirm('EXTREME WARNING: DELETE this club permanently?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="clubId" value="${club.clubId}">
                                            <button type="submit" class="btn btn-sm btn-light border text-danger rounded-circle ms-1" style="width: 32px; height: 32px;" title="Purge Club"><i class="fas fa-trash-alt"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <tr id="noResultsRow" style="display: none;"><td colspan="6" class="text-center py-5 text-muted"><i class="fas fa-search fa-3x mb-3 opacity-25"></i><br>No clubs found in the matrix.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- DYNAMIC CARD DIRECTORY VIEW --%>
            <div id="cardContainer" class="d-none fade-in-up">
                <div class="d-flex align-items-center mb-4 bg-white p-3 rounded-4 shadow-sm border">
                    <i class="fas fa-folder-open text-warning fa-lg me-3"></i>
                    <span id="navHome" class="breadcrumb-nav" onclick="renderCategories()"><i class="fas fa-home"></i> Directory Hub</span>
                    <span id="navCat" class="d-none"> <i class="fas fa-chevron-right mx-2 text-muted" style="font-size:0.8rem;"></i> <span class="breadcrumb-nav" onclick="renderClusters(currentCat)">Category</span></span>
                    <span id="navCluster" class="d-none"> <i class="fas fa-chevron-right mx-2 text-muted" style="font-size:0.8rem;"></i> <span class="text-dark fw-bold" id="lblCluster">Cluster</span></span>
                </div>
                <div id="dynamicCardGrid" class="row g-4"></div>
            </div>

        </div> 

        <%-- Modal Register New Club & Assign Advisor --%>
        <div class="modal fade" id="registerModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <form action="${pageContext.request.contextPath}/hepa/club" method="post">
                        <div class="modal-header bg-primary text-white border-0 py-3">
                            <h5 class="modal-title fw-bold"><i class="fas fa-plus-circle me-2"></i>Register New Club & Advisor</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body bg-light p-4">
                            <input type="hidden" name="action" value="register">

                            <div class="alert alert-info border-0 shadow-sm small mb-4">
                                <i class="fas fa-envelope me-1"></i> <strong>System Action:</strong><br>
                                The club will be set to Active. A new user account (Role: Advisor) will be created instantly and a temporary password will be emailed to the assigned staff member.
                            </div>

                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3"><i class="fas fa-users me-2 text-primary"></i>1. Club Information</h6>
                            <div class="row g-3 mb-4">
                                <div class="col-md-12">
                                    <label class="form-label fw-bold text-muted small">Official Club Name</label>
                                    <input type="text" name="clubName" class="form-control shadow-sm border-0" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small">Category</label>
                                    <select name="category" class="form-select shadow-sm border-0" required>
                                        <option value="Academic">Academic</option>
                                        <option value="Non-Academic">Non-Academic</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small">Cluster</label>
                                    <select name="cluster" class="form-select shadow-sm border-0" required>
                                        <option value="Akademik">Kelab Akademik</option>
                                        <option value="Kelab Keusahawanan">Kelab Keusahawanan</option>
                                        <option value="Kelab Anak Negeri">Kelab Anak Negeri</option>
                                        <option value="Kelab Sukan">Kelab Sukan</option>
                                        <option value="Kelab Kebudayaan">Kelab Kebudayaan</option>
                                        <option value="Kelab Eksekutif">Kelab Eksekutif</option>
                                        <option value="Kelab Badan Beruniform">Kelab Badan Beruniform</option>
                                        <option value="Kelab Sosial">Kelab Sosial</option>
                                        <option value="Kerohanian">Kelab Kerohanian</option>
                                    </select>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label fw-bold text-muted small">Established Year</label>
                                    <input type="number" name="establishedYear" class="form-control shadow-sm border-0" value="2026" required>
                                </div>
                            </div>

                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3"><i class="fas fa-chalkboard-teacher me-2 text-primary"></i>2. Advisor Appointment</h6>
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label class="form-label fw-bold text-muted small">Staff ID (Username)</label>
                                    <input type="text" name="advisorId" class="form-control shadow-sm border-0" placeholder="e.g. P12345" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small">Full Name</label>
                                    <input type="text" name="advisorName" class="form-control shadow-sm border-0" placeholder="Dr. / Prof. / Mr. / Ms." required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-muted small">Staff Email</label>
                                    <input type="email" name="advisorEmail" class="form-control shadow-sm border-0" placeholder="staff@umt.edu.my" required>
                                </div>
                            </div>

                        </div>
                        <div class="modal-footer border-0 bg-white py-3 px-4">
                            <button type="button" class="btn btn-light border rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">Register & Send Email</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%-- Loop Semua Modal untuk setiap kelab di LUAR container table --%>
        <c:forEach var="club" items="${clubs}">

            <%-- 1. View Profile Modal --%>
            <div class="modal fade text-start" id="viewModal${club.clubId}" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 shadow">
                        <div class="modal-header bg-dark text-white">
                            <h5 class="modal-title fw-bold"><i class="fas fa-info-circle me-2"></i>Official Club Profile</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body text-center">
                            <img src="${pageContext.request.contextPath}/images/${empty club.logoPath ? 'default_logo.png' : club.logoPath}" class="img-fluid rounded-circle mb-3 border shadow-sm" style="width: 100px; height: 100px; object-fit: cover;">
                            <h4 class="fw-bold mb-0">${club.clubName}</h4>
                            <span class="badge bg-primary mt-2 rounded-pill px-3">${club.cluster}</span>
                            <hr>
                            <div class="row g-3">
                                <div class="col-4"><small class="text-muted text-uppercase fw-bold">Est</small><p class="fw-bold">${club.establishedYear}</p></div>
                                <div class="col-4"><small class="text-muted text-uppercase fw-bold">Category</small><p class="fw-bold">${club.category}</p></div>
                                <div class="col-4"><small class="text-muted text-uppercase fw-bold">Status</small><p class="text-uppercase fw-bold text-${club.status == 'active' ? 'success' : club.status == 'suspended' ? 'warning' : 'danger'}">${club.status}</p></div>
                            </div>
                        </div>
                        <div class="modal-footer bg-light d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/hepa/clubMembers?clubId=${club.clubId}" class="btn btn-primary fw-bold shadow-sm rounded-pill px-4">
                                <i class="fas fa-users me-2"></i>Member List
                            </a>
                            <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 2. Edit Details Modal --%>
            <div class="modal fade text-start" id="editModal${club.clubId}" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content border-0 shadow-lg rounded-4">
                        <form action="${pageContext.request.contextPath}/hepa/club" method="post">
                            <div class="modal-header bg-dark text-white border-0"><h5 class="modal-title"><i class="fas fa-pen me-2"></i>Edit Details</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                            <div class="modal-body bg-light">
                                <input type="hidden" name="action" value="editDetails">
                                <input type="hidden" name="clubId" value="${club.clubId}">
                                <div class="mb-3"><label class="form-label fw-bold text-muted small">Club Name</label><input type="text" name="clubName" class="form-control border-0 shadow-sm" value="${club.clubName}" required></div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold text-muted small">Category</label>
                                        <select name="category" class="form-select border-0 shadow-sm">
                                            <option value="Academic" ${club.category == 'Academic' ? 'selected' : ''}>Academic</option>
                                            <option value="Non-Academic" ${club.category == 'Non-Academic' ? 'selected' : ''}>Non-Academic</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold text-muted small">Cluster</label>
                                        <select name="cluster" class="form-select border-0 shadow-sm">
                                            <option value="Akademik" ${club.cluster == 'Akademik' ? 'selected' : ''}>Kelab Akademik</option>
                                            <option value="Kelab Keusahawanan" ${club.cluster == 'Kelab Keusahawanan' ? 'selected' : ''}>Kelab Keusahawanan</option>
                                            <option value="Kelab Anak Negeri" ${club.cluster == 'Kelab Anak Negeri' ? 'selected' : ''}>Kelab Anak Negeri</option>
                                            <option value="Kelab Sukan" ${club.cluster == 'Kelab Sukan' ? 'selected' : ''}>Kelab Sukan</option>
                                            <option value="Kelab Kebudayaan" ${club.cluster == 'Kelab Kebudayaan' ? 'selected' : ''}>Kelab Kebudayaan</option>
                                            <option value="Kelab Eksekutif" ${club.cluster == 'Kelab Eksekutif' ? 'selected' : ''}>Kelab Eksekutif</option>
                                            <option value="Kelab Badan Beruniform" ${club.cluster == 'Kelab Badan Beruniform' ? 'selected' : ''}>Kelab Badan Beruniform</option>
                                            <option value="Kelab Sosial" ${club.cluster == 'Kelab Sosial' ? 'selected' : ''}>Kelab Sosial</option>
                                            <option value="Kerohanian" ${club.cluster == 'Kerohanian' ? 'selected' : ''}>Kelab Kerohanian</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3"><label class="form-label fw-bold text-muted small">Established Year</label><input type="number" name="establishedYear" class="form-control border-0 shadow-sm" value="${club.establishedYear}" required></div>
                            </div>
                            <div class="modal-footer bg-white border-0"><button type="button" class="btn btn-light rounded-pill px-4 border" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-dark rounded-pill px-4 fw-bold">Save Changes</button></div>
                        </form>
                    </div>
                </div>
            </div>

            <%-- 3. Assign President Modal --%>
            <div class="modal fade text-start" id="assignPresModal${club.clubId}" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content border-0 shadow-lg rounded-4">
                        <form action="${pageContext.request.contextPath}/hepa/club" method="post">
                            <div class="modal-header bg-success text-white border-0">
                                <h5 class="modal-title fw-bold"><i class="fas fa-user-tie me-2"></i>Assign President</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body bg-light">
                                <input type="hidden" name="action" value="assignPresident">
                                <input type="hidden" name="clubId" value="${club.clubId}">
                                <c:if test="${club.presidentName != 'Vacant' && club.presidentName != null}">
                                    <div class="alert alert-warning border-0 shadow-sm small"><i class="fas fa-exclamation-circle me-1"></i><strong>Warning:</strong> This club currently has a president (<strong>${club.presidentName}</strong>). Proceeding will replace them automatically.</div>
                                        </c:if>
                                <div class="alert alert-info border-0 shadow-sm small"><i class="fas fa-envelope text-primary me-1"></i><strong>System Action:</strong><br>A user account (Role: CHC) will be created.<br>A <strong>Temporary Password</strong> will be emailed to the student.</div>
                                <div class="mb-3"><label class="form-label text-muted small fw-bold">Student ID (Matric No)</label><input type="text" name="userId" class="form-control border-0 shadow-sm" placeholder="e.g. S12345" required></div>
                                <div class="mb-3"><label class="form-label text-muted small fw-bold">Full Name</label><input type="text" name="fullName" class="form-control border-0 shadow-sm" placeholder="e.g. Ali Bin Abu" required></div>
                                <div class="mb-3"><label class="form-label text-muted small fw-bold">Student Email</label><input type="email" name="email" class="form-control border-0 shadow-sm" placeholder="e.g. ali@student.umt.edu.my" required></div>
                            </div>
                            <div class="modal-footer border-0 bg-white"><button type="button" class="btn btn-light border rounded-pill px-4" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-success rounded-pill px-4 fw-bold shadow-sm">Assign President</button></div>
                        </form>
                    </div>
                </div>
            </div>

            <%-- 4. Manage President Modal --%>
            <div class="modal fade text-start" id="managePresModal${club.clubId}" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 shadow-lg rounded-4">
                        <div class="modal-header bg-dark text-white border-0">
                            <h5 class="modal-title fw-bold"><i class="fas fa-user-cog me-2"></i>Manage Leadership</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body text-center pt-4 bg-light">
                            <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm mb-3" style="width: 80px; height: 80px;">
                                <i class="fas fa-user-tie fa-3x"></i>
                            </div>
                            <h4 class="fw-bold">${club.presidentName}</h4>
                            <p class="text-muted mb-4">Current President of ${club.clubName}</p>
                            <div class="row g-3">
                                <div class="col-6">
                                    <button class="btn btn-warning shadow-sm w-100 py-3 rounded-4" onclick="openModalFromModal('assignPresModal${club.clubId}', 'managePresModal${club.clubId}')">
                                        <i class="fas fa-exchange-alt fa-2x mb-2 text-dark"></i><br><strong class="text-dark">Replace</strong>
                                        <div class="small text-dark mt-1 opacity-75" style="font-size: 0.75rem;">Appoint a new student</div>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <form action="${pageContext.request.contextPath}/hepa/club" method="post" onsubmit="return confirm('Confirm Removal?\n\nThis will leave the President position VACANT.');">
                                        <input type="hidden" name="action" value="removePresident">
                                        <input type="hidden" name="clubId" value="${club.clubId}">
                                        <button type="submit" class="btn btn-danger shadow-sm w-100 py-3 rounded-4">
                                            <i class="fas fa-user-slash fa-2x mb-2"></i><br><strong>Remove</strong>
                                            <div class="small text-white mt-1 opacity-75" style="font-size: 0.75rem;">Set position to Vacant</div>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </c:forEach>

        <%-- Modal Audit Student Membership  --%>
        <div class="modal fade" id="studentAuditModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-dark text-white border-0">
                        <h5 class="modal-title fw-bold"><i class="fas fa-user-graduate me-2"></i>Student Leadership Audit</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body bg-light p-4">
                        <form action="${pageContext.request.contextPath}/hepa/club" method="GET" class="mb-4">
                            <label class="form-label fw-bold text-muted small">Enter Student Matric No:</label>
                            <div class="input-group shadow-sm">
                                <span class="input-group-text bg-white border-0 text-primary rounded-start-pill ps-4"><i class="fas fa-id-card"></i></span>
                                <input type="text" name="searchUserId" class="form-control border-0 py-2" placeholder="e.g. S70622" value="${searchedId}" required>
                                <button type="submit" class="btn btn-primary px-4 fw-bold rounded-end-pill">Search Database</button>
                            </div>
                        </form>

                        <c:if test="${not empty searchError}">
                            <div class="alert alert-danger border-0 shadow-sm rounded-4"><i class="fas fa-exclamation-circle me-2"></i> ${searchError}</div>
                        </c:if>

                        <c:if test="${not empty searchedName}">
                            <div class="card border-0 shadow-sm rounded-4">
                                <div class="card-body p-4">
                                    <div class="d-flex align-items-center mb-4 border-bottom pb-3">
                                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3 shadow-sm" style="width: 50px; height: 50px;">
                                            <i class="fas fa-user-graduate fa-lg"></i>
                                        </div>
                                        <div>
                                            <h5 class="fw-bold mb-0 text-dark">${searchedName}</h5>
                                            <span class="badge bg-secondary mt-1 px-3">${searchedId}</span>
                                        </div>
                                    </div>

                                    <h6 class="fw-bold text-muted mb-3"><i class="fas fa-history me-2"></i>Club Involvement History</h6>

                                    <c:choose>
                                        <c:when test="${empty studentHistory}">
                                            <div class="text-center py-4 text-muted bg-light rounded-4 border">
                                                <i class="fas fa-folder-open fa-2x mb-2 opacity-50"></i><br>
                                                No club membership records found for this student.
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <ul class="list-group list-group-flush">
                                                <c:forEach var="hist" items="${studentHistory}">
                                                    <li class="list-group-item px-0 py-3 border-light bg-transparent">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <div>
                                                                <h6 class="fw-bold mb-1 text-dark">
                                                                    <c:choose>
                                                                        <c:when test="${hist.position == 'Pres'}"><i class="fas fa-crown text-warning me-1" title="President"></i> President</c:when>
                                                                        <c:when test="${hist.position == 'Secr'}"><i class="fas fa-pen-fancy text-info me-1" title="Secretary"></i> Secretary</c:when>
                                                                        <c:when test="${hist.position == 'Treas'}"><i class="fas fa-wallet text-success me-1" title="Treasurer"></i> Treasurer</c:when>
                                                                        <c:otherwise><i class="fas fa-user text-muted me-1"></i> Member</c:otherwise>
                                                                    </c:choose>
                                                                    <span class="text-muted fw-normal ms-2">of ${hist.clubName}</span>
                                                                </h6>
                                                                <small class="text-muted"><i class="fas fa-calendar-alt me-1"></i> Term: ${hist.joinYear} | Cluster: ${hist.cluster}</small>
                                                            </div>
                                                            <div>
                                                                <c:choose>
                                                                    <c:when test="${hist.isActive == 1}"><span class="badge bg-success border border-success rounded-pill px-3 shadow-sm">Active Term</span></c:when>
                                                                    <c:otherwise><span class="badge bg-light text-muted border rounded-pill px-3">Past Alumni</span></c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                        function openBootstrapModal(modalId) {
                                            var myModal = new bootstrap.Modal(document.getElementById(modalId));
                                            myModal.show();
                                        }

                                        function openModalFromModal(targetModalId, currentModalId) {
                                            var currentModalElement = document.getElementById(currentModalId);
                                            var currentModal = bootstrap.Modal.getInstance(currentModalElement);
                                            if (currentModal) {
                                                currentModal.hide();
                                            }
                                            setTimeout(function () {
                                                openBootstrapModal(targetModalId);
                                            }, 400);
                                        }

                                        // FILTERING LOGIC
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
                                                const clubName = row.getAttribute('data-name').toLowerCase();
                                                const clubId = row.getAttribute('data-id').toLowerCase();
                                                const clubCluster = row.getAttribute('data-cluster').toLowerCase();
                                                const clubStatus = row.getAttribute('data-status').toLowerCase();

                                                const matchesSearch = clubName.includes(searchText) || clubId.includes(searchText);
                                                const matchesStatus = (selectedStatus === 'all') || (clubStatus === selectedStatus);

                                                let matchesCluster = false;
                                                if (selectedCluster === 'all') {
                                                    matchesCluster = true;
                                                } else {
                                                    if (clubCluster.includes(selectedCluster)) {
                                                        matchesCluster = true;
                                                    }
                                                }

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

                                        // SORTING LOGIC (Safer string comparison)
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

                                                    // Extract text safely
                                                    let xVal = x.textContent || x.innerText;
                                                    let yVal = y.textContent || y.innerText;

                                                    if (dir == "asc") {
                                                        if (xVal.toLowerCase().trim() > yVal.toLowerCase().trim()) {
                                                            shouldSwitch = true;
                                                            break;
                                                        }
                                                    } else if (dir == "desc") {
                                                        if (xVal.toLowerCase().trim() < yVal.toLowerCase().trim()) {
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

                                        // TOGGLE VIEW & DRILL DOWN LOGIC
                                        const tableDiv = document.getElementById('tableContainer');
                                        const cardDiv = document.getElementById('cardContainer');
                                        let allClubsData = [];
                                        let currentCat = '';

                                        document.addEventListener("DOMContentLoaded", () => {
                                            document.querySelectorAll('.club-row').forEach(row => {
                                                allClubsData.push({
                                                    id: row.getAttribute('data-id'),
                                                    name: row.getAttribute('data-name'),
                                                    category: row.getAttribute('data-category'),
                                                    cluster: row.getAttribute('data-cluster'),
                                                    status: row.getAttribute('data-status'),
                                                    agm: row.getAttribute('data-agm'),
                                                    president: row.getAttribute('data-president')
                                                });
                                            });
                                        });

                                        function toggleView(type) {
                                            if (type === 'table') {
                                                cardDiv.classList.add('d-none');
                                                tableDiv.classList.remove('d-none');
                                            } else {
                                                tableDiv.classList.add('d-none');
                                                cardDiv.classList.remove('d-none');
                                                renderCategories();
                                            }
                                        }

                                        const grid = document.getElementById('dynamicCardGrid');
                                        const navCat = document.getElementById('navCat');
                                        const navCluster = document.getElementById('navCluster');

                                        function renderCategories() {
                                            navCat.classList.add('d-none');
                                            navCluster.classList.add('d-none');
                                            grid.innerHTML = `
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm rounded-4 folder-card h-100 bg-primary text-white" onclick="renderClusters('Academic')">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-book fa-4x mb-3 opacity-75"></i>
                                <h2 class="fw-bold">Academic Clubs</h2>
                                <p class="mb-0 opacity-75">Click to view clusters</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm rounded-4 folder-card h-100 bg-danger text-white" onclick="renderClusters('Non-Academic')">
                            <div class="card-body text-center py-5">
                                <i class="fas fa-running fa-4x mb-3 opacity-75"></i>
                                <h2 class="fw-bold">Non-Academic Clubs</h2>
                                <p class="mb-0 opacity-75">Click to view clusters</p>
                            </div>
                        </div>
                    </div>
                `;
                                        }

                                        function renderClusters(category) {
                                            currentCat = category;
                                            navCat.classList.remove('d-none');
                                            navCat.querySelector('.breadcrumb-nav').innerText = category;
                                            navCluster.classList.add('d-none');

                                            const clustersInCat = [...new Set(allClubsData.filter(c => c.category === category).map(c => c.cluster))];

                                            if (clustersInCat.length === 0) {
                                                grid.innerHTML = `<div class="col-12 text-center py-5 text-muted bg-white rounded-4 shadow-sm border"><i class="fas fa-folder-open fa-3x mb-3 opacity-50"></i><br>No clusters found in this category.</div>`;
                                                return;
                                            }

                                            let html = '';
                                            const colors = ['bg-info', 'bg-warning', 'bg-success', 'bg-dark', 'bg-secondary', 'bg-primary'];

                                            clustersInCat.forEach((clusterName, index) => {
                                                let color = colors[index % colors.length];
                                                let count = allClubsData.filter(c => c.cluster === clusterName).length;

                                                html += `
                        <div class="col-md-4 col-sm-6 fade-in-up" style="animation-delay: \${index * 0.05}s">
                            <div class="card border-0 shadow-sm rounded-4 folder-card h-100" onclick="renderClubs('\${clusterName}')">
                                <div class="card-body text-center py-4">
                                    <div class="\${color} text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3 shadow-sm" style="width: 70px; height: 70px;">
                                        <i class="fas fa-layer-group fa-2x"></i>
                                    </div>
                                    <h5 class="fw-bold text-dark">\${clusterName}</h5>
                                    <span class="badge bg-light text-muted border">\${count} Registered Clubs</span>
                                </div>
                            </div>
                        </div>
                    `;
                                            });
                                            grid.innerHTML = html;
                                        }

                                        function renderClubs(cluster) {
                                            document.getElementById('lblCluster').innerText = cluster;
                                            navCluster.classList.remove('d-none');

                                            const clubsInCluster = allClubsData.filter(c => c.cluster === cluster);
                                            let html = '';

                                            clubsInCluster.forEach((club, index) => {
                                                let statusBadge = club.status === 'active' ? '<span class="badge bg-success rounded-pill px-3 shadow-sm">Active</span>' :
                                                        (club.status === 'suspended' ? '<span class="badge bg-warning text-dark rounded-pill px-3 shadow-sm">Suspended</span>' : '<span class="badge bg-danger rounded-pill px-3 shadow-sm">Inactive</span>');

                                                let agmBadge = club.agm === 'Approved' ? '<span class="badge bg-success bg-opacity-10 text-success border border-success ms-2"><i class="fas fa-check"></i> AGM</span>' :
                                                        (club.agm === 'Pending' ? '<span class="badge bg-warning bg-opacity-10 text-dark border border-warning ms-2"><i class="fas fa-clock"></i> AGM</span>' :
                                                                '<span class="badge bg-danger bg-opacity-10 text-danger border border-danger ms-2"><i class="fas fa-times"></i> AGM</span>');

                                                html += `
                        <div class="col-md-6 col-lg-4 fade-in-up" style="animation-delay: \${index * 0.05}s">
                            <div class="card border-0 shadow-sm rounded-4 h-100">
                                <div class="card-body p-4 position-relative">
                                    <div class="position-absolute top-0 end-0 p-3">\${statusBadge}</div>
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="bg-light rounded-circle border d-flex align-items-center justify-content-center me-3" style="width: 60px; height: 60px;">
                                            <i class="fas fa-users fa-2x text-primary opacity-50"></i>
                                        </div>
                                        <div>
                                            <h5 class="fw-bold mb-0 text-dark" style="line-height:1.2;">\${club.name}</h5>
                                            <div class="mt-1"><small class="text-muted border-end pe-2 me-1">ID: #\${club.id}</small>\${agmBadge}</div>
                                        </div>
                                    </div>
                                    <div class="bg-light p-2 rounded-3 mb-4 text-center border">
                                        <small class="text-muted d-block text-uppercase fw-bold" style="font-size:0.7rem;">President</small>
                                        <span class="fw-bold \${club.president.includes('Vacant') ? 'text-danger' : 'text-primary'}">\${club.president}</span>
                                    </div>
                                    <button class="btn btn-outline-primary w-100 rounded-pill fw-bold" onclick="openBootstrapModal('viewModal\${club.id}')">
                                        <i class="fas fa-info-circle me-1"></i> View Profile
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                                            });
                                            grid.innerHTML = html;
                                        }

            <c:if test="${not empty searchedId || not empty searchError}">
                                        document.addEventListener("DOMContentLoaded", function () {
                                            var auditModal = new bootstrap.Modal(document.getElementById('studentAuditModal'));
                                            auditModal.show();
                                        });
            </c:if>
        </script>
    </body>
</html>