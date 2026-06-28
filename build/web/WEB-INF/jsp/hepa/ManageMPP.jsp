<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage MPP - UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">

            <div class="top-header mb-4">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <h3 class="fw-bold mb-0"><i class="fas fa-user-tie text-primary me-3"></i>MPP Leadership Management</h3>
                </div>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible shadow-sm"><i class="fas fa-check-circle me-2"></i> ${message}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                    <c:remove var="message" scope="session" />
                </c:if>
                <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible shadow-sm"><i class="fas fa-exclamation-triangle me-2"></i> ${errorMessage}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div class="card-header bg-white py-3 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                    <h5 class="fw-bold mb-0 text-dark">Current MPP Members</h5>
                    <div class="d-flex gap-2">
                        <button class="btn btn-primary rounded-pill fw-bold px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#assignMppModal">
                            <i class="fas fa-user-plus me-1"></i> Assign MPP
                        </button>
                        <form action="${pageContext.request.contextPath}/hepa/mpp" method="post" class="m-0" onsubmit="return confirm('⚠️ WARNING: Are you sure you want to END the MPP session? All current MPP members will lose their privileges and become standard students.');">
                            <input type="hidden" name="action" value="endSession">
                            <button type="submit" class="btn btn-dark rounded-pill fw-bold px-3 shadow-sm"><i class="fas fa-power-off text-danger me-1"></i> End Session</button>
                        </form>
                    </div>
                </div>
                <div class="card-body p-0 table-responsive">
                    <table class="table table-hover align-middle mb-0 text-nowrap">
                        <thead class="table-dark">
                            <tr>
                                <th class="ps-4">No</th>
                                <th>Matric No</th>
                                <th>Full Name</th>
                                <th>Portfolio</th>
                                <th>Faculty/Dept</th>
                                <th class="text-end pe-4">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="mpp" items="${mppList}" varStatus="loop">
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">${loop.count}</td>
                                    <td><span class="badge bg-light border text-dark">${mpp.userId}</span></td>
                                    <td class="fw-bold text-dark">
                                        <i class="${mpp.portfolio == 'Yang Di-Pertua (YDP)' ? 'fas fa-crown text-warning' : 'fas fa-user-shield text-primary'} me-2"></i>
                                        ${mpp.fullName}
                                    </td>
                                    <td>
                                        <span class="badge bg-primary text-white shadow-sm px-3 py-2" style="font-size: 0.85rem;">
                                            ${not empty mpp.portfolio ? mpp.portfolio : 'Ahli Majlis'}
                                        </span>
                                    </td>
                                    <td>${mpp.department != null ? mpp.department : 'N/A'}</td>

                                    <td class="text-end pe-4">
                                        <div class="d-inline-flex gap-1">
                                            <button class="btn btn-sm btn-outline-primary rounded-pill" title="Edit Profile" data-bs-toggle="modal" data-bs-target="#editMppModal${mpp.userId}">
                                                <i class="fas fa-pen"></i> Edit
                                            </button>

                                            <form action="${pageContext.request.contextPath}/hepa/mpp" method="post" class="m-0" onsubmit="return confirm('Remove ${mpp.fullName} from MPP?');">
                                                <input type="hidden" name="action" value="removeMPP">
                                                <input type="hidden" name="userId" value="${mpp.userId}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill" title="Demote to Student"><i class="fas fa-user-minus"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty mppList}">
                                <tr><td colspan="6" class="text-center py-5 text-muted"><i class="fas fa-users-slash fa-3x mb-3 opacity-25"></i><br>No MPP members registered for this session.</td></tr>
                                    </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="modal fade" id="assignMppModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="${pageContext.request.contextPath}/hepa/mpp" method="post">
                        <div class="modal-header bg-primary text-white border-0">
                            <h5 class="modal-title fw-bold"><i class="fas fa-user-plus me-2"></i>Appoint New MPP</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body bg-light">
                            <input type="hidden" name="action" value="assignMPP">
                            <div class="alert alert-info small border-0 shadow-sm"><i class="fas fa-info-circle me-1"></i> If the student already exists, their role will be upgraded. Otherwise, a new account will be created.</div>

                            <div class="mb-3"><label class="form-label fw-bold">Matric No</label><input type="text" name="userId" class="form-control shadow-sm" placeholder="e.g. S12345" required></div>
                            <div class="mb-3"><label class="form-label fw-bold">Full Name</label><input type="text" name="fullName" class="form-control shadow-sm" required></div>
                            <div class="mb-3"><label class="form-label fw-bold">Email</label><input type="email" name="email" class="form-control shadow-sm" required></div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Portfolio</label>
                                    <select name="portfolio" class="form-select shadow-sm" required>
                                        <option value="Yang Di-Pertua (YDP)">Yang Di-Pertua (YDP)</option>
                                        <option value="Timbalan YDP">Timbalan YDP</option>
                                        <option value="Setiausaha Agung">Setiausaha Agung</option>
                                        <option value="Bendahari Kehormat">Bendahari Kehormat</option>
                                        <option value="Exco Kerohanian & Kebudayaan">Exco Kerohanian & Kebudayaan</option>
                                        <option value="Exco Sukan & Rekreasi">Exco Sukan & Rekreasi</option>
                                        <option value="Exco Akademik">Exco Akademik</option>
                                        <option value="Exco Kebajikan">Exco Kebajikan</option>
                                        <option value="Ahli Biasa MPP">Ahli Biasa MPP</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Faculty</label>
                                    <input type="text" name="department" class="form-control shadow-sm" placeholder="e.g. FSKM">
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer bg-light border-0"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-primary fw-bold px-4">Appoint MPP</button></div>
                    </form>
                </div>
            </div>
        </div>

        <c:forEach var="mpp" items="${mppList}">
            <div class="modal fade" id="editMppModal${mpp.userId}" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/hepa/mpp" method="post">
                            <div class="modal-header bg-warning text-dark border-0">
                                <h5 class="modal-title fw-bold"><i class="fas fa-user-edit me-2"></i>Edit MPP Profile</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body bg-light">
                                <input type="hidden" name="action" value="editMPP">
                                <input type="hidden" name="userId" value="${mpp.userId}">

                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted">Matric No</label>
                                    <input type="text" class="form-control shadow-sm bg-white" value="${mpp.userId}" disabled>
                                    <div class="form-text small">Matric number cannot be changed.</div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Full Name</label>
                                    <input type="text" name="fullName" class="form-control shadow-sm" value="${mpp.fullName}" required>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Portfolio</label>
                                        <select name="portfolio" class="form-select shadow-sm" required>
                                            <option value="Yang Di-Pertua (YDP)" ${mpp.portfolio == 'Yang Di-Pertua (YDP)' ? 'selected' : ''}>Yang Di-Pertua (YDP)</option>
                                            <option value="Timbalan YDP" ${mpp.portfolio == 'Timbalan YDP' ? 'selected' : ''}>Timbalan YDP</option>
                                            <option value="Setiausaha Agung" ${mpp.portfolio == 'Setiausaha Agung' ? 'selected' : ''}>Setiausaha Agung</option>
                                            <option value="Bendahari Kehormat" ${mpp.portfolio == 'Bendahari Kehormat' ? 'selected' : ''}>Bendahari Kehormat</option>
                                            <option value="Exco Kerohanian & Kebudayaan" ${mpp.portfolio == 'Exco Kerohanian & Kebudayaan' ? 'selected' : ''}>Exco Kerohanian & Kebudayaan</option>
                                            <option value="Exco Sukan & Rekreasi" ${mpp.portfolio == 'Exco Sukan & Rekreasi' ? 'selected' : ''}>Exco Sukan & Rekreasi</option>
                                            <option value="Exco Akademik" ${mpp.portfolio == 'Exco Akademik' ? 'selected' : ''}>Exco Akademik</option>
                                            <option value="Exco Kebajikan" ${mpp.portfolio == 'Exco Kebajikan' ? 'selected' : ''}>Exco Kebajikan</option>
                                            <option value="Ahli Biasa MPP" ${mpp.portfolio == 'Ahli Biasa MPP' ? 'selected' : ''}>Ahli Biasa MPP</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Faculty</label>
                                        <input type="text" name="department" class="form-control shadow-sm" value="${mpp.department}">
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer bg-light border-0">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-warning fw-bold px-4 text-dark">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>