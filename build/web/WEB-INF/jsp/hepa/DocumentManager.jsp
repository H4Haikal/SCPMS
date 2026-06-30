<%-- 
    Document   : DocumentManager
    Created on : 29 Jun 2026, 1:03:36 pm
    Author     : User
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <title>Manage System Documents | HEPA</title>
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
                            <i class="fas fa-file-upload me-2 d-none d-lg-inline"></i>Manage Documents
                        </h3>
                        <p class="text-muted small mb-0 mt-1">Upload and organize guidelines, templates, and rulebooks for all clubs.</p>
                    </div>
                </div>
                <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
            </div>

            <div class="container-fluid px-0">
                <c:if test="${not empty sessionScope.successMsg}">
                    <div class="alert alert-success shadow-sm"><i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}</div>
                        <c:remove var="successMsg" scope="session"/>
                    </c:if>

                <div class="row g-4">
                    <div class="col-lg-4">
                        <div class="card shadow-sm border-0 rounded-4 h-100">
                            <div class="card-body p-4">
                                <h5 class="fw-bold mb-4">Upload New File</h5>
                                <form action="${pageContext.request.contextPath}/hepa/documents" method="POST" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="upload">

                                    <div class="mb-3">
                                        <label class="form-label text-muted small fw-bold">Document Title</label>
                                        <input type="text" name="docTitle" class="form-control" placeholder="e.g., Poster Guidelines" required>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label text-muted small fw-bold">Section / Category</label>
                                        <select name="existingCategory" class="form-select mb-2" id="categorySelect" onchange="toggleNewCategory()">
                                            <c:forEach var="group" items="${groupedDocs}">
                                                <option value="${group.key}">${group.key}</option>
                                            </c:forEach>
                                            <option value="NEW" class="text-primary fw-bold">+ Create New Category...</option>
                                        </select>

                                        <input type="text" name="newCategory" id="newCategoryInput" class="form-control" placeholder="Enter new category name..." style="display:none;">
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label text-muted small fw-bold">Upload File (PDF/Word)</label>
                                        <input type="file" name="documentFile" class="form-control" accept=".pdf,.doc,.docx" required>
                                    </div>

                                    <button type="submit" class="btn btn-primary w-100 fw-bold rounded-pill">Upload to System</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-8">
                        <div class="card shadow-sm border-0 rounded-4 bg-white h-100">
                            <div class="card-body p-4">
                                <h5 class="fw-bold mb-4 text-secondary"><i class="fas fa-eye me-2"></i> Live Advisor/CHC View Preview</h5>

                                <div class="row g-3">
                                    <c:forEach var="group" items="${groupedDocs}">
                                        <div class="col-md-6">
                                            <div class="p-3 border border-light-subtle rounded bg-light h-100">
                                                <h6 class="fw-bold text-dark"><i class="fas fa-folder-open text-warning me-2"></i> ${group.key}</h6>
                                                <ul class="list-unstyled mb-0 mt-3">
                                                    <c:forEach var="doc" items="${group.value}">
                                                        <li class="mb-2 small border-bottom border-light-subtle pb-2 d-flex justify-content-between align-items-center">
                                                            <a href="${pageContext.request.contextPath}/${doc.filePath}" target="_blank" class="text-decoration-none text-primary fw-medium text-truncate" style="max-width: 80%;">
                                                                <i class="fas fa-file-pdf text-danger me-1"></i> ${doc.title}
                                                            </a>

                                                            <form action="${pageContext.request.contextPath}/hepa/documents" method="POST" style="margin:0;" onsubmit="return confirm('Delete this document? This cannot be undone.');">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="docId" value="${doc.docId}">
                                                                <button type="submit" class="btn btn-sm btn-link text-danger p-0" title="Delete File">
                                                                    <i class="fas fa-trash-alt"></i>
                                                                </button>
                                                            </form>

                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                function toggleNewCategory() {
                                                                    var select = document.getElementById("categorySelect");
                                                                    var input = document.getElementById("newCategoryInput");
                                                                    if (select.value === "NEW") {
                                                                        input.style.display = "block";
                                                                        input.setAttribute("required", "true");
                                                                    } else {
                                                                        input.style.display = "none";
                                                                        input.removeAttribute("required");
                                                                        input.value = "";
                                                                    }
                                                                }
        </script>
    </body>
</html>