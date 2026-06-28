<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <title>AGM Report | UMT ClubSphere</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            .file-upload-wrapper {
                position: relative;
                border: 2px dashed #cbd5e1;
                border-radius: 8px;
                padding: 30px 20px;
                text-align: center;
                background-color: #f8fafc;
                transition: all 0.3s ease;
            }
            .file-upload-wrapper:hover {
                border-color: #0d6efd;
                background-color: #e9ecef;
            }
            .file-upload-input {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                opacity: 0;
                cursor: pointer;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="top-header mb-4 d-flex align-items-center">
                <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                    <i class="fas fa-bars fa-lg"></i>
                </button>

                <div>
                    <h3 class="fw-bold mb-0 text-primary"><i class="fas fa-file-signature me-2"></i>Annual AGM Report</h3>
                    <p class="text-muted mt-1 mb-0">Upload your club's meeting minutes and financial statements.</p>
                </div>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="alert alert-primary shadow-sm border-0 mb-4">
                <i class="fas fa-info-circle me-2"></i> The AGM report must contain the meeting minutes, the latest committee list, and financial statements consolidated into a <strong>single PDF file</strong>.
            </div>

            <div class="row g-4 mb-5">
                <div class="col-xl-4 col-lg-5">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-header bg-white py-3 border-bottom-0">
                            <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-upload text-primary me-2"></i>Upload Report</h5>
                        </div>
                        <div class="card-body p-4 pt-2">
                            <form action="${pageContext.request.contextPath}/common/agm" method="POST" enctype="multipart/form-data" id="agmForm">
                                <input type="hidden" name="action" value="upload">
                                <input type="hidden" name="clubId" value="${sessionScope.userClubId != null ? sessionScope.userClubId : 1002}"> 

                                <div class="mb-4">
                                    <label class="form-label fw-bold text-secondary">Report Year</label>
                                    <select name="reportYear" class="form-select bg-light" required>
                                        <option value="" disabled selected>Select Year...</option>
                                        <option value="2026">2026</option>
                                        <option value="2025">2025</option>
                                        <option value="2024">2024</option>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold text-secondary">Supporting Document (PDF)</label>
                                    <div class="file-upload-wrapper">
                                        <i class="fas fa-file-pdf fa-3x text-danger mb-3"></i>
                                        <h6 class="fw-bold text-dark mb-1">Click or Drag File Here</h6>
                                        <small class="text-muted">Max. 10MB</small>
                                        <input type="file" name="reportFile" class="file-upload-input" accept=".pdf" required onchange="updateFileName(this)">
                                    </div>
                                    <div id="fileNameDisplay" class="mt-2 text-center text-primary fw-bold small"></div>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 py-2 fw-bold rounded-pill">
                                    <i class="fas fa-paper-plane me-2"></i> Submit to MPP
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-xl-8 col-lg-7">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-header bg-white py-3 border-bottom-0">
                            <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-history text-primary me-2"></i>Submission History</h5>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty reports}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-folder-open fa-4x text-muted opacity-25 mb-3"></i>
                                        <h5 class="fw-bold text-muted">No Records Found</h5>
                                        <p class="text-muted small">Your club has not uploaded any AGM reports yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th class="ps-4 py-3">Year</th>
                                                    <th>Date Submitted</th>
                                                    <th>Status</th>
                                                    <th class="pe-4 text-end">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${reports}">
                                                    <tr>
                                                        <td class="ps-4 fw-bold text-dark">${r.reportYear}</td>
                                                        <td>
                                                            <small class="text-muted"><i class="far fa-calendar-check me-1"></i> 
                                                                <fmt:formatDate value="${r.submittedAt}" pattern="dd MMM yyyy, hh:mm a" />
                                                            </small>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${r.status == 'Accepted'}"><span class="badge bg-success shadow-sm"><i class="fas fa-check-circle me-1"></i>Approved (HEPA)</span></c:when>
                                                                <c:when test="${r.status == 'Pending_MPP'}"><span class="badge bg-warning text-dark"><i class="fas fa-hourglass-half me-1"></i>Pending MPP</span></c:when>
                                                                <c:when test="${r.status == 'Pending_HEPA'}"><span class="badge bg-info text-dark"><i class="fas fa-user-tie me-1"></i>Pending HEPA</span></c:when>
                                                                <c:when test="${r.status == 'Missing'}"><span class="badge bg-danger shadow-sm"><i class="fas fa-times-circle me-1"></i>Rejected</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">${r.status}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="pe-4 text-end">
                                                            <div class="d-flex flex-column align-items-end">
                                                                <a href="${pageContext.request.contextPath}/viewAGM?file=${r.reportPath}" target="_blank" class="btn btn-sm btn-outline-dark rounded-pill mb-1">
                                                                    <i class="fas fa-eye me-1"></i> View
                                                                </a>

                                                                <c:if test="${r.status == 'Missing'}">
                                                                    <button type="button" class="btn btn-sm btn-danger rounded-pill" data-bs-toggle="modal" data-bs-target="#remarksModal${r.agmId}">
                                                                        <i class="fas fa-comment-dots me-1"></i> Feedback
                                                                    </button>
                                                                </c:if>
                                                            </div>

                                                            <div class="modal fade" id="remarksModal${r.agmId}" tabindex="-1" aria-hidden="true">
                                                                <div class="modal-dialog modal-dialog-centered">
                                                                    <div class="modal-content text-start">
                                                                        <div class="modal-header bg-danger text-white border-0">
                                                                            <h5 class="modal-title"><i class="fas fa-exclamation-circle me-2"></i>Rejection Reason (${r.reportYear})</h5>
                                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                        </div>
                                                                        <div class="modal-body py-4 bg-light">
                                                                            <p class="text-muted small mb-2">Feedback from MPP/HEPA:</p>
                                                                            <div class="p-3 bg-white border-start border-danger border-4 rounded shadow-sm">
                                                                                <p class="mb-0 fw-bold text-dark">
                                                                                    ${not empty r.remarks ? r.remarks : "No specific remarks provided. Please contact MPP for more details."}
                                                                                </p>
                                                                            </div>
                                                                        </div>
                                                                        <div class="modal-footer border-0 bg-light">
                                                                            <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
                                                                            <button type="button" class="btn btn-primary rounded-pill px-4" onclick="window.scrollTo(0, 0); document.querySelector('select[name=reportYear]').value = '${r.reportYear}';
                                                                                    bootstrap.Modal.getInstance(this.closest('.modal')).hide();">
                                                                                Fix Now
                                                                            </button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                                function updateFileName(input) {
                                                                                    var display = document.getElementById('fileNameDisplay');
                                                                                    if (input.files && input.files.length > 0) {
                                                                                        display.innerHTML = '<i class="fas fa-file-pdf me-1"></i> ' + input.files[0].name;
                                                                                    } else {
                                                                                        display.innerHTML = '';
                                                                                    }
                                                                                }

                                                                                document.getElementById('agmForm').addEventListener('submit', function (e) {
                                                                                    var fileInput = document.querySelector('.file-upload-input');
                                                                                    var yearInput = document.querySelector('select[name="reportYear"]');

                                                                                    if (yearInput.value === "") {
                                                                                        e.preventDefault();
                                                                                        alert("⚠️ Please select the AGM Report Year!");
                                                                                        return;
                                                                                    }

                                                                                    if (fileInput.files.length === 0) {
                                                                                        e.preventDefault();
                                                                                        alert("⚠️ Please upload your AGM document (PDF) file first!");
                                                                                    }
                                                                                });
        </script>
    </body>
</html>