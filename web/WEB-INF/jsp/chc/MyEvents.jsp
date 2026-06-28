<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Proposals Pipeline | SCPMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            body {
                background-color: #f4f6f9;
                font-family: 'Segoe UI', system-ui, sans-serif;
            }

            /* --- BENTO STYLING --- */
            .bento-card {
                background: white;
                border-radius: 20px;
                border: 1px solid rgba(0,0,0,0.05);
                box-shadow: 0 10px 30px rgba(0,0,0,0.02);
                overflow: hidden;
            }

            /* --- STATUS PILLS SUMMARY --- */
            .status-summary-card {
                border-radius: 16px;
                padding: 1.5rem;
                color: white;
                display: flex;
                align-items: center;
                justify-content: space-between;
                box-shadow: 0 8px 20px rgba(0,0,0,0.1);
                transition: transform 0.2s;
            }
            .status-summary-card:hover {
                transform: translateY(-3px);
            }
            .bg-grad-draft {
                background: linear-gradient(135deg, #94a3b8, #64748b);
            }
            .bg-grad-pending {
                background: linear-gradient(135deg, #f59e0b, #d97706);
            }
            .bg-grad-approved {
                background: linear-gradient(135deg, #10b981, #059669);
            }

            /* --- DATA TABLE UPGRADES --- */
            .table-hover tbody tr {
                transition: all 0.2s ease;
                border-bottom: 1px solid #f8f9fa;
            }
            .table-hover tbody tr:hover {
                background-color: #f8fafc;
                transform: translateX(3px);
            }
            .table-hover tbody tr:last-child {
                border-bottom: none;
            }

            /* DataTables Overrides */
            div.dataTables_wrapper div.dataTables_filter input {
                border-radius: 50px;
                padding: 6px 15px;
                border: 1px solid #cbd5e1;
            }
            div.dataTables_wrapper div.dataTables_filter input:focus {
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                border-color: #4b0082;
                outline: none;
            }
            .page-item.active .page-link {
                background-color: #4b0082;
                border-color: #4b0082;
            }

            /* --- CUSTOM STATUS BADGES --- */
            .status-badge {
                font-weight: 700;
                padding: 8px 14px;
                border-radius: 50px;
                font-size: 0.75rem;
                letter-spacing: 0.5px;
                text-transform: uppercase;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }
            .badge-draft {
                background: #f1f5f9;
                color: #475569;
                border: 1px solid #cbd5e1;
            }
            .badge-pending {
                background: #fffbeb;
                color: #d97706;
                border: 1px solid #fde68a;
            }
            .badge-pitching {
                background: #eff6ff;
                color: #2563eb;
                border: 1px solid #bfdbfe;
                cursor: pointer;
                transition: 0.2s;
            }
            .badge-pitching:hover {
                transform: scale(1.05);
                background: #2563eb;
                color: white;
            }
            .badge-approved {
                background: #f0fdf4;
                color: #16a34a;
                border: 1px solid #bbf7d0;
            }
            .badge-rejected {
                background: #fef2f2;
                color: #dc2626;
                border: 1px solid #fecaca;
            }

            .action-btn {
                width: 32px;
                height: 32px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                transition: 0.2s;
                margin-left: 4px;
                border: none;
            }
            .action-btn:hover {
                transform: scale(1.1);
            }
            .btn-track {
                background: #e0e7ff;
                color: #4f46e5;
            }
            .btn-track:hover {
                background: #4f46e5;
                color: white;
            }
            .btn-pdf {
                background: #f3f4f6;
                color: #4b5563;
            }
            .btn-pdf:hover {
                background: #4b5563;
                color: white;
            }
            .btn-edit {
                background: #ecfdf5;
                color: #059669;
            }
            .btn-edit:hover {
                background: #059669;
                color: white;
            }
            .btn-delete {
                background: #fef2f2;
                color: #dc2626;
            }
            .btn-delete:hover {
                background: #dc2626;
                color: white;
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">

            <%-- CALCULATE COUNTS DYNAMICALLY FROM THE LIST --%>
            <c:set var="countDraft" value="0" />
            <c:set var="countPending" value="0" />
            <c:set var="countApproved" value="0" />

            <c:forEach var="p" items="${myProposals}">
                <c:choose>
                    <c:when test="${fn:toLowerCase(p.status) == 'draft'}"><c:set var="countDraft" value="${countDraft + 1}"/></c:when>
                    <c:when test="${p.status == 'Approved'}"><c:set var="countApproved" value="${countApproved + 1}"/></c:when>
                    <c:when test="${p.status != 'Rejected'}"><c:set var="countPending" value="${countPending + 1}"/></c:when>
                </c:choose>
            </c:forEach>

            <%-- TOP HEADER --%>
            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle"><i class="fas fa-bars fa-lg"></i></button>
                    <div>
                        <h3 class="fw-bold text-dark mb-0">My Proposals Pipeline</h3>
                        <p class="text-muted small mb-0"><i class="fas fa-route me-1"></i> Track, edit, and monitor your event applications</p>
                    </div>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/SubmitProposalServlet" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">
                        <i class="fas fa-plus me-2"></i> Draft New
                    </a>
                </div>
            </div>

            <%-- ALERTS --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible shadow-sm rounded-4 border-0 mb-4"><i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible shadow-sm rounded-4 border-0 mb-4"><i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

            <%-- STATUS SUMMARY CARDS --%>
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="status-summary-card bg-grad-draft">
                        <div>
                            <div class="text-uppercase small fw-bold opacity-75 mb-1">Drafts</div>
                            <h2 class="fw-bold mb-0">${countDraft}</h2>
                        </div>
                        <i class="fas fa-pencil-alt fa-2x opacity-50"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="status-summary-card bg-grad-pending">
                        <div>
                            <div class="text-uppercase small fw-bold opacity-75 mb-1">In Routing Pipeline</div>
                            <h2 class="fw-bold mb-0">${countPending}</h2>
                        </div>
                        <i class="fas fa-sync fa-spin fa-2x opacity-50"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="status-summary-card bg-grad-approved">
                        <div>
                            <div class="text-uppercase small fw-bold opacity-75 mb-1">Approved & Active</div>
                            <h2 class="fw-bold mb-0">${countApproved}</h2>
                        </div>
                        <i class="fas fa-check-double fa-2x opacity-50"></i>
                    </div>
                </div>
            </div>

            <%-- DATA TABLE BENTO --%>
            <div class="bento-card mb-5">
                <div class="p-4 border-bottom bg-white">
                    <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-list-ul text-primary me-2"></i> Document Directory</h5>
                </div>
                <div class="card-body p-4 bg-white">
                    <div class="table-responsive">
                        <table id="eventsTable" class="table table-hover align-middle w-100 border-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-muted small text-uppercase border-0">Event Title</th>
                                    <th class="text-muted small text-uppercase border-0">Est. Budget</th>
                                    <th class="text-muted small text-uppercase border-0">Created</th>
                                    <th class="text-muted small text-uppercase border-0">Current Status</th>
                                    <th class="text-end pe-4 text-muted small text-uppercase border-0">Manage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${myProposals}">
                                    <tr>
                                        <%-- TITLE & ID --%>
                                        <td class="py-3">
                                            <div class="fw-bold text-dark mb-1">
                                                <a href="${pageContext.request.contextPath}/chc/track?id=${p.proposalId}" class="text-decoration-none text-dark hover-primary" title="Click to track proposal">
                                                    ${p.title}
                                                </a>
                                            </div>
                                            <span class="badge bg-light text-dark border"><i class="fas fa-hashtag me-1 opacity-50"></i>${p.proposalId}</span>
                                        </td>

                                        <%-- BUDGET --%>
                                        <td>
                                            <div class="fw-bold text-success bg-success bg-opacity-10 d-inline-block px-2 py-1 rounded-2 small">
                                                RM <fmt:formatNumber value="${p.budget}" pattern="#,##0.00" />
                                            </div>
                                        </td>

                                        <%-- DATES --%>
                                        <td data-order="${p.createdAt.time}">
                                            <div class="small fw-bold text-secondary"><i class="far fa-calendar-alt me-1"></i><fmt:formatDate value="${p.createdAt}" pattern="dd MMM yyyy" /></div>
                                            <div class="small text-muted"><i class="far fa-clock me-1"></i><fmt:formatDate value="${p.createdAt}" pattern="hh:mm a" /></div>
                                        </td>

                                        <%-- STATUS BADGES --%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status == 'Draft' || p.status == 'draft'}">
                                                    <span class="status-badge badge-draft"><i class="fas fa-pencil-alt"></i> Draft</span>
                                                </c:when>
                                                <c:when test="${p.status == 'Submitted'}">
                                                    <span class="status-badge badge-pending"><i class="fas fa-user-tie"></i> Advisor Review</span>
                                                </c:when>
                                                <c:when test="${p.status == 'Pending_MPP'}">
                                                    <span class="status-badge badge-pending"><i class="fas fa-users"></i> MPP Review</span>
                                                </c:when>
                                                <c:when test="${p.status == 'Pending_Faculty'}">
                                                    <span class="status-badge badge-pending"><i class="fas fa-university"></i> Faculty Review</span>
                                                </c:when>
                                                <c:when test="${p.status == 'Pending_HEPA'}">
                                                    <span class="status-badge badge-pending"><i class="fas fa-building"></i> HEPA Endorsement</span>
                                                </c:when>
                                                <c:when test="${p.status == 'Meeting_Scheduled'}">
                                                    <span class="status-badge badge-pitching" data-bs-toggle="modal" data-bs-target="#pitchingModal${p.proposalId}" title="Click to view meeting info">
                                                        <i class="fas fa-video"></i> Pitching Set
                                                    </span>
                                                </c:when>
                                                <c:when test="${p.status == 'Approved'}">
                                                    <span class="status-badge badge-approved"><i class="fas fa-check-circle"></i> Approved</span>
                                                </c:when>
                                                <c:when test="${p.status == 'Rejected'}">
                                                    <span class="status-badge badge-rejected" data-bs-toggle="modal" data-bs-target="#feedbackModal${p.proposalId}"><i class="fas fa-times-circle"></i> Rejected (View)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge badge-draft">${p.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <%-- ACTION BUTTONS --%>
                                        <td class="text-end pe-3">

                                            <%-- Always Tracking, unless Draft --%>
                                            <c:if test="${fn:toLowerCase(p.status) != 'draft'}">
                                                <a href="${pageContext.request.contextPath}/chc/track?id=${p.proposalId}" class="action-btn btn-track" title="Track Proposal">
                                                    <i class="fas fa-route"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="action-btn btn-pdf" title="Download PDF" target="_blank">
                                                    <i class="fas fa-file-pdf"></i>
                                                </a>
                                            </c:if>

                                            <%-- Retract Proposal (Only when freshly submitted to Advisor) --%>
                                            <c:if test="${fn:toLowerCase(p.status) == 'submitted'}">
                                                <form action="${pageContext.request.contextPath}/chc/events" method="POST" class="d-inline" onsubmit="return confirm('Retract this proposal? This will cancel the review process.');">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                    <button type="submit" class="action-btn btn-delete" title="Retract Proposal"><i class="fas fa-undo"></i></button>
                                                </form>
                                            </c:if>

                                            <%-- Edit & Delete (Only for Drafts or Rejected) --%>
                                            <c:if test="${fn:toLowerCase(p.status) == 'draft' || p.status == 'Rejected'}">
                                                <a href="${pageContext.request.contextPath}/EditDraftServlet?id=${p.proposalId}" class="action-btn btn-edit" title="Edit Content">
                                                    <i class="fas fa-pen"></i>
                                                </a>
                                            </c:if>

                                            <c:if test="${fn:toLowerCase(p.status) == 'draft'}">
                                                <form action="${pageContext.request.contextPath}/chc/events" method="POST" class="d-inline" onsubmit="return confirm('Permanently delete this draft?');">
                                                    <input type="hidden" name="action" value="deleteDraft">
                                                    <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                    <button type="submit" class="action-btn btn-delete" title="Delete Draft"><i class="fas fa-trash-alt"></i></button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>

                                    <%-- FEEDBACK MODAL (For Rejected) --%>
                                    <c:if test="${not empty p.feedback && p.status == 'Rejected'}">
                                    <div class="modal fade" id="feedbackModal${p.proposalId}" tabindex="-1">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content border-0 shadow-lg rounded-4">
                                                <div class="modal-header bg-danger text-white border-0">
                                                    <h5 class="modal-title fw-bold"><i class="fas fa-comment-dots me-2"></i>Reviewer Remarks</h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body bg-light p-4">
                                                    <h6 class="fw-bold text-dark mb-4 border-bottom pb-2">Event: <span class="text-primary">${p.title}</span></h6>
                                                    <div class="p-4 bg-white border border-danger border-opacity-25 rounded-4 shadow-sm">
                                                        <h6 class="fw-bold text-danger mb-3">Rejection Reason:</h6>
                                                        <p class="mb-0 text-dark" style="white-space: pre-wrap;">${p.feedback}</p>
                                                    </div>
                                                </div>
                                                <div class="modal-footer border-0 bg-light">
                                                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Close</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <%-- PITCHING SESSION MODAL --%>
                                <c:if test="${p.status == 'Meeting_Scheduled'}">
                                    <div class="modal fade" id="pitchingModal${p.proposalId}" tabindex="-1">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content border-0 shadow-lg rounded-4">
                                                <div class="modal-header bg-primary text-white border-0">
                                                    <h5 class="modal-title fw-bold"><i class="fas fa-video me-2"></i>Pitching Details</h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body bg-light p-4">
                                                    <h6 class="fw-bold text-dark mb-4 border-bottom pb-2">Event: <span class="text-primary">${p.title}</span></h6>
                                                        <c:choose>
                                                            <c:when test="${not empty p.pitchingLocation}">
                                                            <div class="p-4 bg-white border border-primary border-opacity-25 rounded-4 shadow-sm">
                                                                <p class="mb-3"><i class="fas fa-clock text-muted me-2"></i><strong>Schedule:</strong> <br>
                                                                    <span class="text-dark fs-5 fw-bold"><fmt:formatDate value="${p.pitchingDate}" pattern="dd MMM yyyy, hh:mm a" /></span>
                                                                </p>
                                                                <p class="mb-0"><i class="fas fa-link text-muted me-2"></i><strong>Meet Link:</strong> <br>
                                                                    <a href="${p.pitchingLocation}" target="_blank" class="fw-bold text-decoration-none text-primary break-all">${p.pitchingLocation}</a>
                                                                </p>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="alert alert-warning border-0 small fw-bold">
                                                                <i class="fas fa-hourglass-half me-1"></i> Meeting link is being generated. Please check back shortly.
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="modal-footer border-0 bg-light">
                                                    <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Close</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <script>
                                                    $(document).ready(function () {
                                                        // Initialize DataTables with advanced features
                                                        $('#eventsTable').DataTable({
                                                            "order": [[2, "desc"]], // Sort by 'Created At' column
                                                            "language": {
                                                                "search": "",
                                                                "searchPlaceholder": "Search document or status...",
                                                                "lengthMenu": "Show _MENU_ entries"
                                                            },
                                                            "pageLength": 10,
                                                            "columnDefs": [
                                                                {"orderable": false, "targets": 4} // Disable sorting on Action column
                                                            ]
                                                        });
                                                    });
        </script>
    </body>
</html>