<%-- 
    Document   : UserSettings.jsp
    Purpose    : Account Settings with Security Enforcement
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Account Settings - UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            :root {
                --umt-purple: #4b0082;
            }
            .nav-pills .nav-link {
                color: #555;
                background-color: #f8f9fa;
                margin-right: 10px;
                border-radius: 50px;
                padding: 10px 25px;
                font-weight: 600;
                border: 1px solid #eee;
                transition: all 0.3s ease;
            }
            .nav-pills .nav-link:hover {
                background-color: #e9ecef;
                transform: translateY(-2px);
            }
            .nav-pills .nav-link.active {
                background-color: var(--umt-purple);
                color: white;
                box-shadow: 0 4px 10px rgba(75, 0, 130, 0.3);
                border-color: var(--umt-purple);
            }
            .profile-header-bg {
                height: 100px;
                background: linear-gradient(135deg, #4b0082, #000080);
                border-radius: 15px 15px 0 0;
            }
            .profile-avatar-container {
                margin-top: -50px;
            }
            .profile-avatar {
                width: 100px;
                height: 100px;
                font-size: 2.5rem;
                font-weight: bold;
                border: 5px solid white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="d-flex align-items-center mb-4">
                <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                    <i class="fas fa-bars fa-lg"></i>
                </button>
                <div>
                    <h3 class="fw-bold text-dark mb-0">Account Settings</h3>
                    <p class="text-muted small mb-0">Manage your personal information and security</p>
                </div>
            </div>

            <%-- Success/Error Messages --%>
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm border-start border-4 border-success">
                    <i class="fas fa-check-circle me-2"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm border-start border-4 border-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="profile-header-bg"></div>
                        <div class="card-body text-center pt-0 pb-4">
                            <div class="profile-avatar-container mb-3">
                                <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center profile-avatar">
                                    ${fn:substring(sessionScope.user.fullName, 0, 1)}
                                </div>
                            </div>
                            <h5 class="fw-bold mb-1">${sessionScope.user.fullName}</h5>

                            <%-- LOGIK ROLE YANG DIBETULKAN --%>
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'MPP'}">
                                    <span class="badge rounded-pill bg-primary bg-opacity-10 text-primary mb-3 px-3 py-2">
                                        <i class="fas fa-user-tie me-1"></i> Student Council (MPP)
                                    </span>
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'Advisor'}">
                                    <span class="badge rounded-pill bg-info bg-opacity-10 text-dark mb-3 px-3 py-2">
                                        <i class="fas fa-chalkboard-teacher me-1"></i> Club Advisor
                                    </span>
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'Faculty'}">
                                    <span class="badge rounded-pill bg-warning bg-opacity-10 text-dark mb-3 px-3 py-2">
                                        <i class="fas fa-university me-1"></i> Faculty Admin
                                    </span>
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'CHC'}">
                                    <span class="badge rounded-pill bg-success bg-opacity-10 text-success mb-3 px-3 py-2">
                                        <i class="fas fa-users me-1"></i> Club High Committee
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge rounded-pill bg-secondary bg-opacity-10 text-secondary mb-3 px-3 py-2">
                                        ${sessionScope.user.role}
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <div class="d-flex justify-content-center gap-2 mt-2">
                                <div class="p-2 border rounded bg-light flex-fill">
                                    <small class="text-muted d-block">User ID</small>
                                    <span class="fw-bold text-dark">${sessionScope.user.userId}</span>
                                </div>
                                <div class="p-2 border rounded bg-light flex-fill">
                                    <small class="text-muted d-block">Status</small>
                                    <span class="fw-bold text-success"><i class="fas fa-circle fa-xs me-1"></i>Active</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white border-bottom-0 pt-4 px-4 pb-0">
                            <ul class="nav nav-pills" id="settingTabs" role="tablist">
                                <li class="nav-item">
                                    <button class="nav-link ${param.tab == 'security' ? '' : 'active'}" id="profile-tab" data-bs-toggle="pill" data-bs-target="#profile" type="button">
                                        <i class="fas fa-user-edit me-2"></i> Edit Profile
                                    </button>
                                </li>
                                <li class="nav-item">
                                    <button class="nav-link ${param.tab == 'security' ? 'active' : ''}" id="security-tab" data-bs-toggle="pill" data-bs-target="#security" type="button">
                                        <i class="fas fa-shield-alt me-2"></i> Security
                                    </button>
                                </li>
                            </ul>
                        </div>

                        <div class="card-body p-4">

                            <%-- SECURITY FORCE ALERT --%>
                            <c:if test="${param.alert == 'force'}">
                                <div class="alert alert-warning border-0 shadow-sm d-flex align-items-center mb-4">
                                    <i class="fas fa-exclamation-circle fa-2x me-3 text-warning"></i>
                                    <div>
                                        <h6 class="fw-bold mb-0 text-dark">Security Update Required</h6>
                                        <p class="mb-0 small text-muted">You are using a temporary password. Please change it now to access your dashboard.</p>
                                    </div>
                                </div>
                            </c:if>

                            <div class="tab-content" id="settingTabsContent">

                                <div class="tab-pane fade ${param.tab == 'security' ? '' : 'show active'}" id="profile" role="tabpanel">
                                    <h6 class="fw-bold text-muted text-uppercase small mb-3">Personal Information</h6>
                                    <form action="${pageContext.request.contextPath}/user/settings" method="post">
                                        <input type="hidden" name="action" value="updateProfile">

                                        <div class="mb-3">
                                            <label class="form-label fw-bold small">Full Name</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light border-end-0"><i class="fas fa-user text-muted"></i></span>
                                                <input type="text" name="fullName" class="form-control border-start-0 ps-0" value="${sessionScope.user.fullName}" required>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold small">Faculty / Department</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light border-end-0"><i class="fas fa-university text-muted"></i></span>
                                                <select name="faculty" class="form-select border-start-0 ps-0">
                                                    <option value="" disabled ${empty sessionScope.user.department ? 'selected' : ''}>Pilih fakulti anda</option>
                                                    <option value="FSMA" ${sessionScope.user.department == 'FSMA' ? 'selected' : ''}>FSMA - Fakulti Sains Makanan dan Agroteknologi</option>
                                                    <option value="FPM" ${sessionScope.user.department == 'FPM' ? 'selected' : ''}>FPM - Fakulti Pengajian Maritim</option>
                                                    <option value="FSKM" ${sessionScope.user.department == 'FSKM' ? 'selected' : ''}>FSKM - Fakulti Sains Komputer dan Matematik</option>
                                                    <option value="FPEPS" ${sessionScope.user.department == 'FPEPS' ? 'selected' : ''}>FPEPS - Fakulti Perniagaan Ekonomi dan Pembangunan Sosial</option>
                                                    <option value="FTKK" ${sessionScope.user.department == 'FTKK' ? 'selected' : ''}>FTKK - Fakulti Teknologi Kejuruteraan Kelautan</option>
                                                    <option value="FSSM" ${sessionScope.user.department == 'FSSM' ? 'selected' : ''}>FSSM - Fakulti Sains dan Sekitaran Marin</option>
                                                    <option value="FSPA" ${sessionScope.user.department == 'FSPA' ? 'selected' : ''}>FSPA - Fakulti Sains Perikanan dan Akuakultur</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="row g-3 mb-4">
                                            <div class="col-md-6">
                                                <label class="form-label fw-bold small">Phone Number</label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light border-end-0"><i class="fas fa-phone text-muted"></i></span>
                                                    <input type="text" name="phone" class="form-control border-start-0 ps-0" value="${sessionScope.user.phone}">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label fw-bold small">Email Address</label>
                                                <div class="input-group">
                                                    <span class="input-group-text bg-light border-end-0"><i class="fas fa-envelope text-muted"></i></span>
                                                    <input type="email" name="email" class="form-control border-start-0 ps-0" value="${sessionScope.user.email}" required>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-end">
                                            <button type="submit" class="btn btn-primary px-4 rounded-pill shadow-sm">
                                                <i class="fas fa-save me-2"></i> Save Changes
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <div class="tab-pane fade ${param.tab == 'security' ? 'show active' : ''}" id="security" role="tabpanel">
                                    <h6 class="fw-bold text-muted text-uppercase small mb-3">Password Management</h6>
                                    <form action="${pageContext.request.contextPath}/user/settings" method="post">
                                        <input type="hidden" name="action" value="changePassword">

                                        <div class="mb-3">
                                            <label class="form-label fw-bold small">Current Password</label>
                                            <input type="password" name="currentPassword" class="form-control" placeholder="Enter current password to verify" required>
                                        </div>

                                        <div class="bg-light p-3 rounded mb-3 border">
                                            <div class="row g-3">
                                                <div class="col-md-6">
                                                    <label class="form-label fw-bold small">New Password</label>
                                                    <input type="password" name="newPassword" class="form-control" placeholder="Min. 8 characters" required minlength="8">
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label fw-bold small">Confirm Password</label>
                                                    <input type="password" name="confirmPassword" class="form-control" placeholder="Retype new password" required>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="text-muted small">
                                                <i class="fas fa-info-circle me-1"></i> Ensure you use a strong password.
                                            </div>
                                            <button type="submit" class="btn btn-danger px-4 rounded-pill shadow-sm">
                                                <i class="fas fa-key me-2"></i> Update Password
                                            </button>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>