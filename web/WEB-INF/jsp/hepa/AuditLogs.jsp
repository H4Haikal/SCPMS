<%-- 
    Document   : AuditLogs
    Created on : 18 Jan 2026
    Author     : Haikal Danial
    Purpose    : HEPA Forensic Audit Timeline with Live Search
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Forensic Audit Trail - UMT ClubSphere</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            /* FORENSIC TIMELINE CSS */
            .audit-timeline {
                position: relative;
                padding-left: 2rem;
                margin-top: 1rem;
            }
            .audit-timeline::before {
                content: '';
                position: absolute;
                left: 15px;
                top: 0;
                bottom: 0;
                width: 3px;
                background-color: #e9ecef;
                border-radius: 3px;
            }
            .audit-item {
                position: relative;
                margin-bottom: 2rem;
                transition: all 0.3s ease;
            }
            .audit-dot {
                position: absolute;
                left: -2.75rem;
                top: 0;
                width: 28px;
                height: 28px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 0.75rem;
                z-index: 1;
                border: 4px solid white;
                box-shadow: 0 0 0 2px #e9ecef;
            }
            .audit-card {
                background: #fff;
                border: 1px solid #f1f3f5;
                border-radius: 12px;
                padding: 1.25rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.03);
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .audit-card:hover {
                transform: translateX(5px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border-color: #dee2e6;
            }
            .fade-in-up {
                animation: fadeInUp 0.4s ease-out forwards;
            }
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(15px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .search-highlight {
                background-color: rgba(255, 193, 7, 0.4);
                padding: 0 2px;
                border-radius: 3px;
            }
        </style>
    </head>
    <body class="bg-light">
        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">

            <%-- Sticky Header & Search Bar --%>
            <div class="sticky-top bg-light pt-3 pb-3" style="z-index: 10;">
                <div class="row align-items-center mb-3">
                    <div class="col-md-6 d-flex align-items-center">
                        <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                            <i class="fas fa-bars fa-lg"></i>
                        </button>
                        <i class="fas fa-fingerprint fa-2x text-primary me-3 d-none d-lg-block"></i>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">Forensic Audit Trail</h3>
                            <p class="text-muted small mb-0">Track all system activities, logins, and modifications in real-time.</p>
                        </div>
                    </div>
                    <div class="col-md-6 mt-3 mt-md-0">
                        <div class="input-group shadow-sm rounded-pill overflow-hidden border">
                            <span class="input-group-text bg-white border-0 ps-4"><i class="fas fa-search text-muted"></i></span>
                            <input type="text" id="liveSearch" class="form-control border-0 py-3 bg-white" placeholder="Search by User ID, Action, or Keywords...">
                        </div>
                    </div>
                </div>
            </div>

            <%-- Forensic Timeline Container --%>
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-4 p-md-5">

                    <div id="noResults" class="text-center py-5 d-none">
                        <i class="fas fa-search-minus fa-3x text-muted opacity-25 mb-3"></i>
                        <h5 class="text-muted fw-bold">No matching records found.</h5>
                        <p class="text-muted small">Try using different keywords.</p>
                    </div>

                    <div class="audit-timeline" id="timelineContainer">
                        <c:forEach var="log" items="${logs}" varStatus="loop">

                            <%-- 1. CLEAN UP STRINGS --%>
                            <c:set var="actionUp" value="${fn:toUpperCase(log.action)}" />
                            <c:set var="cleanTime" value="${fn:replace(log.timestamp, '.0', '')}" />

                            <%-- Clean out hidden table data (Smart Diff data) if it exists so it doesn't clutter the UI --%>
                            <c:set var="cleanDesc" value="${log.description}" />
                            <c:if test="${fn:contains(log.description, '^')}">
                                <c:set var="cleanDesc" value="${fn:substringBefore(log.description, '^')} (Includes Budget Modifications)" />
                            </c:if>

                            <%-- 2. AUTO COLOR CODING ENGINE --%>
                            <c:set var="dotColor" value="bg-primary" />
                            <c:set var="dotIcon" value="fa-info" />
                            <c:set var="badgeColor" value="bg-primary text-primary border-primary" />

                            <%-- Red: Danger/Deletions/Rejections --%>
                            <c:if test="${fn:contains(actionUp, 'DELETE') || fn:contains(actionUp, 'REMOVE') || fn:contains(actionUp, 'REJECT') || fn:contains(actionUp, 'END SESSION')}">
                                <c:set var="dotColor" value="bg-danger" />
                                <c:set var="dotIcon" value="fa-times" />
                                <c:set var="badgeColor" value="bg-danger text-danger border-danger" />
                            </c:if>

                            <%-- Green: Additions/Approvals/Assignments --%>
                            <c:if test="${fn:contains(actionUp, 'REGISTER') || fn:contains(actionUp, 'ASSIGN') || fn:contains(actionUp, 'APPROVE') || fn:contains(actionUp, 'SUBMIT')}">
                                <c:set var="dotColor" value="bg-success" />
                                <c:set var="dotIcon" value="fa-check" />
                                <c:set var="badgeColor" value="bg-success text-success border-success" />
                            </c:if>

                            <%-- Yellow/Warning: Edits/Alterations/Updates --%>
                            <c:if test="${fn:contains(actionUp, 'ALTER') || fn:contains(actionUp, 'EDIT') || fn:contains(actionUp, 'UPDATE')}">
                                <c:set var="dotColor" value="bg-warning text-dark border-warning" />
                                <c:set var="dotIcon" value="fa-pen" />
                                <c:set var="badgeColor" value="bg-warning text-dark border-warning" />
                            </c:if>

                            <%-- Gray: System/Auth logs --%>
                            <c:if test="${fn:contains(actionUp, 'LOGIN') || fn:contains(actionUp, 'LOGOUT')}">
                                <c:set var="dotColor" value="bg-secondary" />
                                <c:set var="dotIcon" value="fa-sign-in-alt" />
                                <c:set var="badgeColor" value="bg-secondary text-secondary border-secondary" />
                            </c:if>

                            <%-- 3. RENDER ITEM --%>
                            <div class="audit-item fade-in-up searchable-item" style="animation-delay: ${loop.index < 20 ? loop.index * 0.03 : 0}s">
                                <div class="audit-dot ${dotColor} shadow-sm">
                                    <i class="fas ${dotIcon}"></i>
                                </div>
                                <div class="audit-card">
                                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-2">
                                        <div class="d-flex align-items-center mb-2 mb-md-0">
                                            <div class="bg-light rounded-circle d-flex align-items-center justify-content-center me-2 border" style="width: 35px; height: 35px;">
                                                <i class="fas fa-user text-secondary"></i>
                                            </div>
                                            <div>
                                                <h6 class="fw-bold mb-0 text-dark search-target">${log.userName}</h6>
                                                <div class="small text-muted mb-2 search-target" style="font-size: 0.75rem;">
                                                    <span class="fw-bold text-primary">${log.userId}</span> &nbsp;|&nbsp; 
                                                    <i class="fas fa-user-tag text-secondary me-1"></i><span class="text-secondary fw-bold">${log.userRole}</span>
                                                </div>
                                                <span class="badge ${badgeColor} bg-opacity-10 border rounded-pill search-target px-3">${log.action}</span>
                                            </div>
                                        </div>
                                        <div class="text-md-end text-muted small fw-bold">
                                            <i class="far fa-clock me-1"></i> ${cleanTime}
                                        </div>
                                    </div>
                                    <p class="mb-0 text-secondary mt-2 ms-md-5 ps-md-2 border-start border-2 border-light search-target" style="font-size: 0.95rem;">
                                        ${cleanDesc}
                                    </p>
                                </div>
                            </div>
                        </c:forEach>

                        <%-- NEW: LOAD MORE BUTTON --%>
                        <div id="loadMoreContainer" class="text-center mt-5 mb-3" style="display: none;">
                            <button id="loadMoreBtn" class="btn btn-outline-primary rounded-pill px-5 py-2 fw-bold shadow-sm">
                                <i class="fas fa-chevron-down me-2"></i> Load Older Logs
                            </button>
                        </div>
                        <%-- ---------------------- --%>


                        <c:if test="${empty logs}">
                            <div class="text-center py-5 text-muted">
                                <i class="fas fa-history fa-3x mb-3 opacity-25"></i>
                                <h5>No activity recorded yet.</h5>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // LIVE SEARCH & SMART PAGINATION ENGINE
            document.addEventListener('DOMContentLoaded', function () {
                const searchInput = document.getElementById('liveSearch');
                const auditItems = document.querySelectorAll('.searchable-item');
                const noResultsDiv = document.getElementById('noResults');
                const loadMoreBtn = document.getElementById('loadMoreBtn');
                const loadMoreContainer = document.getElementById('loadMoreContainer');

                let currentLimit = 10; // Set initial visible logs to 10

                function renderLogs() {
                    const query = searchInput.value.toLowerCase().trim();
                    let visibleCount = 0;

                    auditItems.forEach((item, index) => {
                        const targets = item.querySelectorAll('.search-target');
                        let matchFound = false;

                        targets.forEach(target => {
                            const text = target.textContent || target.innerText;
                            if (text.toLowerCase().includes(query)) {
                                matchFound = true;
                            }
                        });

                        // MODE 1: Searching (Ignore limits, show all matches)
                        if (query !== '') {
                            if (matchFound) {
                                item.style.display = '';
                                item.classList.add('fade-in-up');
                                visibleCount++;
                            } else {
                                item.style.display = 'none';
                                item.classList.remove('fade-in-up');
                            }
                            // Hide the load more button while searching
                            if (loadMoreContainer)
                                loadMoreContainer.style.display = 'none';
                        }
                        // MODE 2: Normal Viewing (Apply the 10-item limit)
                        else {
                            if (index < currentLimit) {
                                item.style.display = '';
                            } else {
                                item.style.display = 'none';
                            }

                            // Only show the "Load More" button if there are more hidden logs
                            if (loadMoreContainer) {
                                loadMoreContainer.style.display = (currentLimit >= auditItems.length) ? 'none' : 'block';
                            }
                            visibleCount = 1; // Prevent the 'No Results' div from showing
                        }
                    });

                    // Show 'No Results' if search yields nothing
                    if (visibleCount === 0 && query !== '') {
                        noResultsDiv.classList.remove('d-none');
                    } else {
                        noResultsDiv.classList.add('d-none');
                    }
                }

                // 1. Run on first load
                renderLogs();

                // 2. Run whenever user types in the search bar
                searchInput.addEventListener('input', function () {
                    renderLogs();
                });

                // 3. Run when 'Load Older Logs' is clicked
                if (loadMoreBtn) {
                    loadMoreBtn.addEventListener('click', function () {
                        currentLimit += 10; // Show 10 more logs
                        renderLogs();
                    });
                }
            });
        </script>
    </body>
</html>