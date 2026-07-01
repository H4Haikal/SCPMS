<%-- 
    Document   : CHCDocumentation
    Created on : 29 Jun 2026, 2:22:28 pm
    Author     : User
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <title>Club Guidelines & Doc | UMT ClubSphere</title>
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
            .bento-card {
                background: white;
                border-radius: 20px;
                border: 1px solid rgba(0,0,0,0.05);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
                overflow: hidden;
                transition: transform 0.2s ease-in-out;
            }
            .bento-card:hover {
                transform: translateY(-3px);
            }
            .doc-list-item {
                transition: all 0.2s ease;
                border: 1px solid transparent;
                border-radius: 12px !important;
                margin-bottom: 0.5rem;
            }
            .doc-list-item:hover {
                background-color: #f8f9fa;
                border-color: #e9ecef;
            }
            .doc-icon-wrapper {
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 10px;
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
                            <i class="fas fa-book-open me-2 d-none d-lg-inline"></i>Guidelines & Docs
                        </h3>
                        <p class="text-muted small mb-0 mt-1">Download official UMT guidelines, proposal templates, and marketing formats before submitting your paperwork.</p>
                    </div>
                </div>
                <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty groupedDocs}">
                        <c:forEach var="entry" items="${groupedDocs}">
                            <div class="col-lg-6">
                                <div class="bento-card p-4 h-100">

                                    <div class="d-flex align-items-center mb-4">
                                        <div class="doc-icon-wrapper bg-primary bg-opacity-10 text-primary me-3">
                                            <i class="fas fa-folder-open fa-lg"></i>
                                        </div>
                                        <h5 class="fw-bold text-dark mb-0">${entry.key}</h5>
                                    </div>

                                    <ul class="list-group list-group-flush">
                                        <c:forEach var="doc" items="${entry.value}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center doc-list-item px-3 py-3 border-0">
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-file-${doc.fileType == 'word' ? 'word text-primary' : 'pdf text-danger'} me-3 fa-2x"></i>
                                                    <div>
                                                        <h6 class="mb-0 fw-semibold text-dark">${doc.title}</h6>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${doc.updatedAt}" pattern="dd MMM yyyy" /> • ${doc.fileSize}
                                                        </small>
                                                    </div>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/${doc.filePath}" target="_blank" class="btn btn-sm btn-light border rounded-pill px-3 fw-bold text-primary">
                                                    <i class="fas fa-download me-1"></i> Download
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>

                                </div>
                            </div>
                        </c:forEach>
                    </c:when>

                    <c:otherwise>
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-folder-open fa-4x text-muted opacity-25 mb-3"></i>
                            <h4 class="fw-bold text-dark">No Documents Available</h4>
                            <p class="text-muted">HEPA has not uploaded any official guidelines or templates yet. Please check back later.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>