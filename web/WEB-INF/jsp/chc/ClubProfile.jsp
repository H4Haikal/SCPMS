<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Club Profile - UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .profile-banner {
                height: 160px;
                background: linear-gradient(120deg, #2c3e50, #4ca1af);
                border-radius: 15px 15px 0 0;
            }
            .committee-badge {
                width: 45px;
                height: 45px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                font-size: 1.2rem;
            }
            /* Add this for smooth hover effect on the card */
            .card-body h2 {
                margin-top: 10px;
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">

            <div class="d-flex align-items-center justify-content-between mb-4">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <h3 class="fw-bold mb-0">Club Profile</h3>
                </div>

<!--                <div class="badge bg-danger">SYSTEM_DEBUG: |${userPosition}|</div>-->

                <c:if test="${userPosition == 'Pres'}">
                    <button class="btn btn-dark px-4 rounded-pill shadow-sm" onclick="showEditMode()" id="editBtn">
                        <i class="fas fa-pen me-2"></i> Edit Details
                    </button>
                </c:if>

            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm"><i class="fas fa-check-circle me-2"></i>${message}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                    </c:if>

            <div class="card border-0 shadow-sm rounded-4 mb-5">
                <div class="profile-banner"></div>

                <div class="px-4 position-relative" style="height: 80px;"> <div class="position-absolute" style="top: -70px; left: 40px; z-index: 10;">
                        <div class="position-relative">
                            <img src="${pageContext.request.contextPath}/ServeImage?file=${empty club.logoPath ? 'default_logo.png' : club.logoPath}" 
                                 class="shadow-sm" 
                                 style="width: 140px; height: 140px; border: 5px solid white; border-radius: 50%; object-fit: cover; background: white;">

                            <form id="logoForm" action="${pageContext.request.contextPath}/chc/uploadLogo" method="post" enctype="multipart/form-data">
                                <input type="file" id="logoInput" name="clubLogo" accept="image/*" onchange="this.form.submit()" style="display:none;">
                                <button type="button" class="btn btn-dark btn-sm rounded-circle position-absolute shadow-sm" 
                                        style="width:36px; height:36px; bottom: 5px; right: 5px; border: 2px solid white;" 
                                        onclick="document.getElementById('logoInput').click();">
                                    <i class="fas fa-camera fa-xs"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="card-body px-4 pb-5 pt-0">

                    <div id="viewSection">
                        <div class="row">
                            <div class="col-lg-8">
                                <h2 class="fw-bold mb-1">${club.clubName}</h2>
                                <div class="mb-4">
                                    <span class="badge bg-light text-dark border me-1">${club.cluster}</span>
                                    <span class="badge ${club.status == 'active' ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-warning'} text-uppercase">
                                        ${club.status != null ? club.status : 'Active'}
                                    </span>
                                </div>

                                <div class="mb-4">
                                    <h5 class="fw-bold text-secondary text-uppercase small mb-2">Mission</h5>
                                    <p class="text-muted">
                                        ${not empty club.mission ? club.mission : "<em>No mission statement provided. Click Edit to add one.</em>"}
                                    </p>
                                </div>

                                <div class="mb-4">
                                    <h5 class="fw-bold text-secondary text-uppercase small mb-2">Vision</h5>
                                    <p class="text-muted">
                                        ${not empty club.vision ? club.vision : "<em>No vision statement provided.</em>"}
                                    </p>
                                </div>
                            </div>

                            <div class="col-lg-4 border-start">
                                <h6 class="fw-bold text-dark mb-3">Leadership Team</h6>

                                <div class="d-flex align-items-center mb-3">
                                    <div class="committee-badge bg-primary bg-opacity-10 text-primary me-3"><i class="fas fa-user-tie"></i></div>
                                    <div>
                                        <small class="text-uppercase text-muted fw-bold" style="font-size: 0.7rem;">President</small>
                                        <div class="fw-bold">${not empty club.presidentName ? club.presidentName : 'Vacant'}</div>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center mb-3">
                                    <div class="committee-badge bg-info bg-opacity-10 text-info me-3"><i class="fas fa-pen-fancy"></i></div>
                                    <div>
                                        <small class="text-uppercase text-muted fw-bold" style="font-size: 0.7rem;">Secretary</small>
                                        <div class="fw-bold">${not empty club.secretaryName ? club.secretaryName : 'Vacant'}</div>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center">
                                    <div class="committee-badge bg-success bg-opacity-10 text-success me-3"><i class="fas fa-wallet"></i></div>
                                    <div>
                                        <small class="text-uppercase text-muted fw-bold" style="font-size: 0.7rem;">Treasurer</small>
                                        <div class="fw-bold">${not empty club.treasurerName ? club.treasurerName : 'Vacant'}</div>
                                    </div>
                                </div>

                                <div class="mt-4 pt-3 border-top">
                                    <small class="text-muted"><i class="far fa-calendar-alt me-2"></i>Established: <strong>${not empty club.establishedYear ? club.establishedYear : 'N/A'}</strong></small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="editSection" style="display: none;">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="fw-bold mb-0">Edit Profile Details</h4>
                            <button type="button" class="btn btn-light text-muted" onclick="hideEditMode()">Cancel</button>
                        </div>

                        <form action="${pageContext.request.contextPath}/chc/profile" method="post">
                            <input type="hidden" name="clubId" value="${club.clubId}">

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="text" class="form-control bg-light" id="clubName" value="${club.clubName}" readonly>
                                        <label>Club Name (Read Only)</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="number" class="form-control" id="estYear" name="estYear" value="${club.establishedYear}">
                                        <label>Established Year</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-floating mb-3">
                                <select name="cluster" class="form-select">
                                    <option value="Kelab Akademik" ${club.cluster == 'Kelab Akademik' ? 'selected' : ''}>Kelab Akademik</option>
                                    <option value="Kelab Keusahawanan" ${club.cluster == 'Kelab Keusahawanan' ? 'selected' : ''}>Kelab Keusahawanan</option>
                                    <option value="Kelab Anak Negeri" ${club.cluster == 'Kelab Anak Negeri' ? 'selected' : ''}>Kelab Anak Negeri</option>
                                    <option value="Kelab Sukan" ${club.cluster == 'Kelab Sukan' ? 'selected' : ''}>Kelab Sukan</option>
                                    <option value="Kelab Kebudayaan" ${club.cluster == 'Kelab Kebudayaan' ? 'selected' : ''}>Kelab Kebudayaan</option>
                                    <option value="Kelab Eksekutif" ${club.cluster == 'Kelab Eksekutif' ? 'selected' : ''}>Kelab Eksekutif</option>
                                    <option value="Kelab Badan Beruniform" ${club.cluster == 'Kelab Badan Beruniform' ? 'selected' : ''}>Kelab Badan Beruniform</option>
                                    <option value="Kelab Sosial" ${club.cluster == 'Kelab Sosial' ? 'selected' : ''}>Kelab Sosial</option>
                                    <option value="Kelab Kerohanian" ${club.cluster == 'Kelab Kerohanian' ? 'selected' : ''}>Kelab Kerohanian</option>
                                </select>
                                <label>Cluster</label>
                            </div>

                            <div class="form-floating mb-3">
                                <textarea class="form-control" placeholder="Mission" id="mission" name="mission" style="height: 120px">${club.mission}</textarea>
                                <label>Club Mission</label>
                            </div>

                            <div class="form-floating mb-4">
                                <textarea class="form-control" placeholder="Vision" id="vision" name="vision" style="height: 120px">${club.vision}</textarea>
                                <label>Club Vision</label>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <button type="button" class="btn btn-light" onclick="hideEditMode()">Cancel</button>
                                <button type="submit" class="btn btn-primary px-4">
                                    <i class="fas fa-save me-2"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>

        <script>
            function showEditMode() {
                document.getElementById('viewSection').style.display = 'none';
                document.getElementById('editSection').style.display = 'block';
                document.getElementById('editBtn').style.display = 'none';
            }

            function hideEditMode() {
                document.getElementById('viewSection').style.display = 'block';
                document.getElementById('editSection').style.display = 'none';
                document.getElementById('editBtn').style.display = 'block';
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body> 
<!--    nice-->
</html>