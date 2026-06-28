<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <title>SCPMS | Club Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .top-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding: 1rem 0;
            }

            .stat-card {
                background: white;
                border-radius: 15px;
                padding: 1.5rem;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
                transition: transform 0.2s, box-shadow 0.2s;
                height: 100%;
                border: none;
            }
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            }

            .welcome-card {
                background: linear-gradient(135deg, #4b0082 0%, #000080 100%);
                color: white;
                border-radius: 20px;
                padding: 2.5rem;
                margin-bottom: 2rem;
                box-shadow: 0 10px 30px rgba(75, 0, 130, 0.3);
                position: relative;
                overflow: hidden;
            }
            .welcome-card::after {
                content: '\f518';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                position: absolute;
                right: -20px;
                bottom: -40px;
                font-size: 15rem;
                opacity: 0.1;
            }

            .quick-action-card {
                text-decoration: none;
                border-radius: 15px;
                transition: 0.3s;
                border: 2px solid transparent;
                background: white;
            }
            .quick-action-card:hover {
                border-color: #4b0082;
                transform: scale(1.03);
                background: #f8f9fa;
            }
            .icon-wrapper {
                width: 50px;
                height: 50px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 12px;
                margin-bottom: 15px;
            }

            /* Add hover effect for table rows */
            .table-hover tbody tr:hover {
                background-color: #f8f9fa;
            }

            /* Club Logo Styling inside Welcome Banner */
            .dashboard-logo {
                width: 130px;
                height: 130px;
                border: 5px solid rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                object-fit: cover;
                background: white;
                box-shadow: 0 8px 25px rgba(0,0,0,0.2);
                transition: transform 0.3s ease;
            }
            .dashboard-logo:hover {
                transform: scale(1.05);
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="top-header">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle"><i class="fas fa-bars fa-lg"></i></button>
                    <i class="fas fa-tachometer-alt fa-2x text-primary me-3 d-none d-lg-block" style="color: #4b0082 !important;"></i>
                    <h3 class="fw-bold mb-0 text-dark">Command Center</h3>
                </div>
                <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
            </div>

            <%-- WELCOME BANNER WITH CLUB LOGO --%>
            <div class="welcome-card">
                <div class="row align-items-center">
                    <div class="col-md-9 position-relative" style="z-index: 2;">
                        <h2 class="fw-bold mb-2">Welcome back, ${sessionScope.user.fullName}!</h2>
                        <h5 class="text-warning mb-3"><i class="fas fa-users me-2"></i>${clubName}</h5>
                        <p class="lead mb-0 opacity-75">
                            Student Club Proposal Management System (SCPMS)<br>
                            <span class="fs-6"><i class="far fa-clock me-1"></i> <fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, dd MMMM yyyy" /></span>
                        </p>
                    </div>
                    <%-- NEW: CLUB LOGO DISPLAY --%>
                    <div class="col-md-3 text-end d-none d-md-block position-relative" style="z-index: 2;">
                        <img src="${pageContext.request.contextPath}/ServeImage?file=${empty club.logoPath ? 'default_logo.png' : club.logoPath}" 
                             alt="Club Logo" 
                             class="dashboard-logo">
                    </div>
                </div>
            </div>

            <%-- PROPOSAL KPI METRICS --%>
            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card border-bottom border-4 border-primary">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="text-muted small fw-bold text-uppercase mb-1">Total Proposals</div>
                                <h2 class="fw-bold mb-0 text-dark">${pStats.total != null ? pStats.total : 0}</h2>
                            </div>
                            <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-3"><i class="fas fa-file-alt fa-lg"></i></div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card border-bottom border-4 border-warning">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="text-muted small fw-bold text-uppercase mb-1">Pending Review</div>
                                <h2 class="fw-bold mb-0 text-dark">${pStats.pending != null ? pStats.pending : 0}</h2>
                            </div>
                            <div class="bg-warning bg-opacity-10 text-warning p-3 rounded-3"><i class="fas fa-clock fa-lg"></i></div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card border-bottom border-4 border-success">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="text-muted small fw-bold text-uppercase mb-1">Approved Events</div>
                                <h2 class="fw-bold mb-0 text-dark">${pStats.approved != null ? pStats.approved : 0}</h2>
                            </div>
                            <div class="bg-success bg-opacity-10 text-success p-3 rounded-3"><i class="fas fa-check-circle fa-lg"></i></div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card border-bottom border-4 border-info">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="text-muted small fw-bold text-uppercase mb-1">Total Funds Secured</div>
                                <h3 class="fw-bold mb-0 text-dark">RM <fmt:formatNumber value="${pStats.funds != null ? pStats.funds : 0}" pattern="#,##0.00" /></h3>
                            </div>
                            <div class="bg-info bg-opacity-10 text-info p-3 rounded-3"><i class="fas fa-wallet fa-lg"></i></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <%-- LEFT: RECENT PROPOSALS TABLE --%>
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-header bg-white py-3 border-bottom-0 d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-history text-primary me-2"></i>Recent Proposals</h5>
                            <a href="${pageContext.request.contextPath}/chc/events" class="btn btn-sm btn-outline-primary rounded-pill">View All</a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4">Proposal Title</th>
                                            <th>Target Date</th>
                                            <th>Est. Budget</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="rp" items="${recentProposals}">
                                            <tr>
                                                <td class="ps-4">
                                                    <%-- CLICKABLE TITLE USING CORRECT URL --%>
                                                    <a href="${pageContext.request.contextPath}/chc/track?id=${rp.proposalId}" class="text-decoration-none fw-bold text-primary">
                                                        ${rp.title}
                                                    </a>
                                                    <br><small class="text-muted fw-normal">ID: #${rp.proposalId}</small>
                                                </td>
                                                <td><small><i class="far fa-calendar-alt text-muted me-1"></i><fmt:formatDate value="${rp.proposedDate}" pattern="dd MMM yyyy" /></small></td>
                                                <td class="text-success fw-bold"><small>RM <fmt:formatNumber value="${rp.estimateBudget}" pattern="#,##0.00"/></small></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${rp.status == 'Approved'}"><span class="badge bg-success rounded-pill px-3 py-2"><i class="fas fa-check me-1"></i>Approved</span></c:when>
                                                        <c:when test="${rp.status == 'Rejected'}"><span class="badge bg-danger rounded-pill px-3 py-2"><i class="fas fa-times me-1"></i>Rejected</span></c:when>
                                                        <c:when test="${rp.status == 'Draft'}"><span class="badge bg-secondary rounded-pill px-3 py-2"><i class="fas fa-pencil-alt me-1"></i>Draft</span></c:when>
                                                        <c:otherwise><span class="badge bg-warning text-dark rounded-pill px-3 py-2 shadow-sm"><i class="fas fa-hourglass-half me-1"></i>${rp.status}</span></c:otherwise>
                                                        </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty recentProposals}">
                                            <tr><td colspan="4" class="text-center py-5 text-muted"><i class="fas fa-folder-open fa-3x mb-3 opacity-25"></i><br>No proposals drafted yet.</td></tr>
                                                </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- RIGHT: QUICK ACTIONS & MEMBER STATS --%>
                <div class="col-lg-4">
                    <h6 class="fw-bold text-muted text-uppercase mb-3">Quick Actions</h6>

                    <a href="${pageContext.request.contextPath}/SubmitProposalServlet" class="card quick-action-card shadow-sm mb-3 d-block">
                        <div class="card-body d-flex align-items-center">
                            <div class="icon-wrapper bg-primary bg-opacity-10 text-primary mb-0 me-3"><i class="fas fa-plus fa-lg"></i></div>
                            <div><h6 class="fw-bold text-dark mb-0">Draft New Proposal</h6><small class="text-muted">Start the AI-assisted process</small></div>
                        </div>
                    </a>

                    <%-- TRACK PROPOSAL ACTION TRIGGERS MODAL --%>
                    <a href="#" class="card quick-action-card shadow-sm mb-3 d-block" data-bs-toggle="modal" data-bs-target="#trackProposalModal">
                        <div class="card-body d-flex align-items-center">
                            <div class="icon-wrapper bg-warning bg-opacity-10 text-warning mb-0 me-3"><i class="fas fa-search-location fa-lg"></i></div>
                            <div><h6 class="fw-bold text-dark mb-0">Track Proposal</h6><small class="text-muted">View live audit trails</small></div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/chc/events" class="card quick-action-card shadow-sm mb-4 d-block">
                        <div class="card-body d-flex align-items-center">
                            <div class="icon-wrapper bg-success bg-opacity-10 text-success mb-0 me-3"><i class="fas fa-calendar-check fa-lg"></i></div>
                            <div><h6 class="fw-bold text-dark mb-0">My Events</h6><small class="text-muted">Manage approved club activities</small></div>
                        </div>
                    </a>

                    <div class="card border-0 shadow-sm rounded-4">
                        <div class="card-body p-4 text-center">
                            <h6 class="fw-bold text-dark mb-4 border-bottom pb-2">Club Roster Overview</h6>
                            <div class="d-flex justify-content-around">
                                <div>
                                    <h3 class="fw-bold text-primary mb-0">${memberCount}</h3>
                                    <span class="small text-muted fw-bold text-uppercase">Members</span>
                                </div>
                                <div class="border-end"></div>
                                <div>
                                    <h3 class="fw-bold text-success mb-0">${committeeCount}</h3>
                                    <span class="small text-muted fw-bold text-uppercase">Committee</span>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/chc/members" class="btn btn-sm btn-outline-secondary rounded-pill w-100 mt-4">Manage Roster</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- TRACK PROPOSAL SELECTION MODAL USING CORRECT URL --%>
        <div class="modal fade" id="trackProposalModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-primary text-white border-0">
                        <h5 class="modal-title fw-bold"><i class="fas fa-search-location me-2"></i>Select Proposal to Track</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <%-- Fixed the action mapping right here --%>
                    <form action="${pageContext.request.contextPath}/chc/track" method="GET">
                        <div class="modal-body p-4 bg-light">
                            <label class="form-label fw-bold text-dark mb-2">Select a recent proposal:</label>

                            <select name="id" class="form-select mb-3 shadow-sm" required>
                                <option value="" disabled selected>-- Choose Proposal --</option>
                                <c:forEach var="rp" items="${recentProposals}">
                                    <option value="${rp.proposalId}">#${rp.proposalId} - ${rp.title} (${rp.status})</option>
                                </c:forEach>
                            </select>

                            <p class="small text-muted mb-0">
                                <i class="fas fa-info-circle me-1"></i> Only showing your 5 most recent proposals. To track older records, please visit the <a href="${pageContext.request.contextPath}/chc/events" class="fw-bold text-decoration-none">Full Directory</a>.
                            </p>
                        </div>
                        <div class="modal-footer border-0 bg-light">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Track Now</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%-- FORCE PASSWORD CHANGE MODAL --%>
        <c:if test="${sessionScope.isTemp == 1}">
            <div class="modal fade" id="forceChangePasswordModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 shadow-lg">
                        <div class="modal-header bg-warning"><h5 class="modal-title fw-bold text-dark"><i class="fas fa-shield-alt me-2"></i> Security Update</h5></div>
                        <form action="${pageContext.request.contextPath}/AccountSecurityServlet" method="post" id="forceChangeForm">
                            <div class="modal-body p-4">
                                <p class="text-dark">You are using a temporary password. Please set a new password to continue.</p>
                                <input type="hidden" name="action" value="forceChangePassword">
                                <div class="mb-3"><label class="form-label fw-bold">New Password</label><input type="password" name="newPassword" id="newPassword" class="form-control" required minlength="8"></div>
                                <div class="mb-3"><label class="form-label fw-bold">Confirm New Password</label><input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required><div class="invalid-feedback" id="passMismatch">Passwords do not match!</div></div>
                            </div>
                            <div class="modal-footer border-0"><button type="submit" class="btn btn-warning w-100 fw-bold">Update & Save</button></div>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <c:if test="${sessionScope.isTemp == 1}">
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    new bootstrap.Modal(document.getElementById('forceChangePasswordModal')).show();
                    const form = document.getElementById('forceChangeForm');
                    const pass = document.getElementById('newPassword'), confirm = document.getElementById('confirmPassword');
                    form.addEventListener('submit', function (event) {
                        if (pass.value !== confirm.value) {
                            event.preventDefault();
                            confirm.classList.add('is-invalid');
                            document.getElementById('passMismatch').style.display = 'block';
                        }
                    });
                });
            </script>
        </c:if>
    </body>
</html>