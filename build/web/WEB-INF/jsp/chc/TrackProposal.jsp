<%-- 
    Document   : TrackProposal
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Track Proposal | UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            /* PARCEL TRACKING TIMELINE CSS */
            .tracking-timeline {
                position: relative;
                padding-left: 3rem;
                margin-top: 1rem;
            }
            .tracking-timeline::before {
                content: '';
                position: absolute;
                left: 14px;
                top: 0;
                bottom: 0;
                width: 3px;
                background-color: #e9ecef;
                border-radius: 3px;
            }
            .timeline-item {
                position: relative;
                margin-bottom: 2.5rem;
            }
            .timeline-dot {
                position: absolute;
                left: -3rem;
                top: 0;
                width: 32px;
                height: 32px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 0.85rem;
                z-index: 1;
                border: 4px solid white;
                box-shadow: 0 0 0 2px #e9ecef;
            }
            .timeline-item:last-child {
                margin-bottom: 0;
            }
            .timeline-item:last-child .timeline-dot {
                box-shadow: 0 0 0 3px #0d6efd;
                animation: pulse 2s infinite;
            }
            .section-title {
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: #6c757d;
                font-weight: 700;
                margin-top: 1.5rem;
                margin-bottom: 0.75rem;
                border-bottom: 1px solid #e9ecef;
                padding-bottom: 0.5rem;
            }
            .content-text {
                white-space: pre-wrap;
                color: #212529;
                line-height: 1.6;
            }

            /* Konsep 1: Diff Highlights */
            .row-modified {
                background-color: rgba(255, 193, 7, 0.1) !important;
            }
            .row-removed {
                background-color: rgba(220, 53, 69, 0.05) !important;
                opacity: 0.7;
            }
            .row-added {
                background-color: rgba(25, 135, 84, 0.1) !important;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <%-- HEADER --%>
                <div class="d-flex align-items-center justify-content-between mb-4 pb-3 border-bottom">
                    <div>
                        <a href="${pageContext.request.contextPath}/chc/events" class="btn btn-sm btn-outline-secondary mb-2 rounded-pill shadow-sm">
                            <i class="fas fa-arrow-left me-1"></i> Back to My Events
                        </a>
                        <h3 class="fw-bold mb-0 text-dark"><i class="fas fa-route text-primary me-2"></i>Proposal Details & Tracking</h3>
                    </div>
                    <div class="text-end">
                        <span class="badge ${p.status == 'Rejected' || fn:containsIgnoreCase(p.status, 'Return') ? 'bg-danger' : (fn:containsIgnoreCase(p.status, 'Draft') ? 'bg-secondary' : 'bg-primary')} fs-6 px-4 py-2 rounded-pill shadow-sm d-block mb-2">Status: ${p.status}</span>
                        <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-sm btn-outline-primary shadow-sm" target="_blank">
                            <i class="fas fa-file-pdf me-1"></i> View PDF
                        </a>

                        <%-- BUTANG EDIT DRAFT JIKA PROPOSAL DITOLAK / DIKEMBALIKAN / DRAFT --%>
                        <c:if test="${p.status == 'Rejected' || fn:containsIgnoreCase(p.status, 'Return') || fn:containsIgnoreCase(p.status, 'Draft')}">
                            <a href="${pageContext.request.contextPath}/EditDraftServlet?id=${p.proposalId}" class="btn btn-sm btn-warning shadow-sm ms-1 fw-bold text-dark">
                                <i class="fas fa-edit me-1"></i> Edit Draft
                            </a>
                        </c:if>
                    </div>
                </div>

                <div class="row g-4">
                    <%-- LEFT COLUMN: PROPOSAL DETAILS --%>
                    <div class="col-lg-7">
                        <div class="card border-0 shadow-sm rounded-4 mb-4">
                            <div class="card-header bg-white py-3 border-0 border-bottom">
                                <h5 class="fw-bold mb-0 text-primary"><i class="fas fa-info-circle me-2"></i>Program Information</h5>
                            </div>
                            <div class="card-body p-4">

                                <h4 class="fw-bold text-dark mb-1">${p.title}</h4>
                                <p class="text-muted small mb-4">Tracking ID: #${p.proposalId}</p>

                                <table class="table table-borderless table-sm mb-4">
                                    <tbody>
                                        <tr><th class="text-muted w-25">Target Date</th><td class="text-dark"><i class="far fa-calendar-alt text-primary me-2"></i> <fmt:formatDate value="${p.proposedDate}" pattern="dd MMMM yyyy" /> <span class="text-muted ms-1">(${p.duration} Days)</span></td></tr>
                                        <tr><th class="text-muted">Venue</th><td class="text-dark"><i class="fas fa-map-marker-alt text-danger me-2"></i> ${p.venue}</td></tr>
                                        <tr><th class="text-muted">Audience</th><td class="text-dark"><i class="fas fa-users text-info me-2"></i> ${p.targetAudience} (${p.estimateParticipant} Pax)</td></tr>
                                        <tr>
                                            <th class="text-muted">Final Budget</th>
                                            <td class="text-success fw-bold">
                                                <i class="fas fa-wallet me-2"></i> RM <fmt:formatNumber value="${p.estimateBudget}" type="currency" currencySymbol="" />

                                                <%-- FIX 1: Use budgetAltered instead of isBudgetAltered --%>
                                                <c:if test="${p.budgetAltered}">
                                                    <span class="badge bg-warning text-dark ms-2 border" style="font-size: 0.7rem;"><i class="fas fa-exclamation-circle me-1"></i> Budget Modified</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="section-title">Background Details</div>
                                <p class="content-text">${p.description}</p>

                                <div class="section-title">Program Objectives</div>
                                <p class="content-text">${p.objective}</p>

                                <%-- DYNAMIC SDG SECTION --%>
                                <div class="section-title">Sustainable Development Goals (SDGs)</div>
                                <textarea id="rawSdgImpact" class="d-none">${p.sdgImpact}</textarea>
                                <textarea id="rawSdgReason" class="d-none">${p.sdgReason}</textarea>
                                <div id="sdgView" class="mb-4"></div>

                                <%-- DYNAMIC 3NF TABLES (JSTL) --%>
                                <div class="section-title">Committee Members</div>
                                <div class="table-responsive mb-4">
                                    <table class="table table-bordered table-sm mb-0">
                                        <thead class="table-light"><tr><th>Matric No.</th><th>Name</th><th>Role</th></tr></thead>
                                        <tbody>
                                            <c:forEach var="c" items="${p.committees}">
                                                <tr><td><small>${c.matricNo}</small></td><td><small>${c.name}</small></td><td><small>${c.role}</small></td></tr>
                                            </c:forEach>
                                            <c:if test="${empty p.committees}">
                                                <tr><td colspan="3" class="text-center text-muted fst-italic">No committee members listed.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="section-title">Tentative Schedule</div>
                                <div class="table-responsive mb-4">
                                    <table class="table table-bordered table-sm mb-0">
                                        <thead class="table-light"><tr><th width="20%">Day</th><th width="20%">Time</th><th>Activity</th></tr></thead>
                                        <tbody>
                                            <c:forEach var="itin" items="${p.itineraries}">
                                                <tr><td><small>${itin.day}</small></td><td><small>${itin.time}</small></td><td><small>${itin.activity}</small></td></tr>
                                            </c:forEach>
                                            <c:if test="${empty p.itineraries}">
                                                <tr><td colspan="3" class="text-center text-muted fst-italic">No itinerary provided.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="section-title">Final Financial Budget</div>

                                <%-- FIX 2: Use budgetAltered instead of isBudgetAltered --%>
                                <c:if test="${p.budgetAltered}">
                                    <div class="bg-light border-start border-warning border-4 p-3 mb-4 rounded-end shadow-sm d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="fw-bold text-dark mb-1"><i class="fas fa-microscope text-warning me-2"></i>Budget Modifications Detected</h6>
                                            <small class="text-muted">Changes were made to your original budget by the management.</small>
                                        </div>
                                        <button type="button" class="btn btn-sm btn-primary shadow-sm rounded-pill px-3 fw-bold" data-bs-toggle="modal" data-bs-target="#diffAuditModal">
                                            <i class="fas fa-search-dollar me-1"></i> Track Changes
                                        </button>
                                    </div>
                                </c:if>

                                <div class="table-responsive mb-4">
                                    <table class="table table-bordered table-sm mb-0">
                                        <thead class="table-light"><tr><th>Item / Description</th><th class="text-center">Qty</th><th class="text-center">Unit Price (RM)</th><th class="text-end">Total (RM)</th></tr></thead>
                                        <tbody>
                                            <c:forEach var="b" items="${p.budgets}">
                                                <tr><td><small>${b.itemName}</small></td><td class="text-center"><small>${b.quantity}</small></td><td class="text-center"><small><fmt:formatNumber value="${b.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></small></td><td class="text-end fw-bold"><small><fmt:formatNumber value="${b.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></small></td></tr>
                                                        </c:forEach>
                                        </tbody>
                                        <tfoot class="table-light">
                                            <tr class="fw-bold"><td colspan="3" class="text-end text-uppercase">Grand Total (RM)</td><td class="text-success fs-6 text-end"><fmt:formatNumber value="${p.estimateBudget}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td></tr>
                                        </tfoot>
                                    </table>
                                </div>

                                <%-- FIX 3: Removed originalBudgetDetails because the flat string is gone! --%>
                                <textarea id="rawOriginalBudget" class="d-none"></textarea>
                                <textarea id="rawBudget" class="d-none"><c:forEach var="b" items="${p.budgets}">${b.itemName}|${b.quantity}|${b.unitPrice}|${b.totalPrice}&#13;</c:forEach>GRANDTOTAL| | |${p.estimateBudget}</textarea>

                                </div>
                            </div>
                        </div>

                    <%-- RIGHT COLUMN: TRACKING TIMELINE --%>
                    <div class="col-lg-5">
                        <div class="card border-0 shadow-sm rounded-4 sticky-top" style="top: 20px;">
                            <div class="card-header bg-white py-3 border-0 border-bottom">
                                <h5 class="fw-bold mb-0 text-dark"><i class="fas fa-history text-primary me-2"></i>Approval Timeline</h5>
                            </div>
                            <div class="card-body p-4">

                                <div class="tracking-timeline">
                                    <c:forEach var="log" items="${timeline}">

                                        <%-- PROCESS THE LOG: Clean up the '^' symbol --%>
                                        <c:set var="cleanDesc" value="${log.description}" />
                                        <c:if test="${fn:contains(log.description, '^')}">
                                            <c:set var="cleanDesc" value="${fn:substringBefore(log.description, '^')}" />

                                            <%-- Extract hidden table data for JS diff engine --%>
                                            <c:set var="hiddenTable" value="${fn:substringAfter(log.description, '^')}" />

                                            <%-- Determine who altered it --%>
                                            <c:set var="editorRole" value="Unknown" />
                                            <c:if test="${fn:containsIgnoreCase(log.action, 'MPP')}"><c:set var="editorRole" value="MPP" /></c:if>
                                            <c:if test="${fn:containsIgnoreCase(log.action, 'Faculty')}"><c:set var="editorRole" value="Faculty" /></c:if>
                                            <c:if test="${fn:containsIgnoreCase(log.action, 'HEPA')}"><c:set var="editorRole" value="HEPA" /></c:if>

                                                <textarea class="audit-data-source d-none" data-role="${editorRole}">${hiddenTable}</textarea>
                                        </c:if>

                                        <div class="timeline-item">
                                            <c:choose>
                                                <c:when test="${fn:containsIgnoreCase(log.action, 'Reject')}"><div class="timeline-dot bg-danger"><i class="fas fa-times"></i></div></c:when>
                                                <c:when test="${fn:containsIgnoreCase(log.action, 'Alter')}"><div class="timeline-dot bg-warning text-dark"><i class="fas fa-edit"></i></div></c:when>
                                                <c:otherwise><div class="timeline-dot bg-primary"><i class="fas fa-check"></i></div></c:otherwise>
                                                </c:choose>

                                            <div class="ms-3">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <h6 class="fw-bold mb-0 text-dark">${log.action}</h6>
                                                    <small class="text-muted fw-bold"><c:set var="logTime" value="${fn:replace(log.timestamp, '.0', '')}" />${logTime}</small>
                                                </div>
                                                <p class="text-secondary small mb-0 p-3 bg-light rounded-3 border mt-2">
                                                    ${cleanDesc}
                                                </p>
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

        <%-- DIFF AUDIT MODAL (KONSEP 1) --%>
        <div class="modal fade" id="diffAuditModal" tabindex="-1">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-dark text-white border-0">
                        <h5 class="modal-title"><i class="fas fa-microscope me-2"></i>Budget Audit Trail (Smart Diff)</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body bg-light p-4">

                        <%-- ENGLISH INFO BANNER --%>
                        <div class="alert alert-info border-0 shadow-sm small mb-4">
                            <i class="fas fa-info-circle me-1"></i> This table displays the final approved budget and tracks any modifications made by the reviewers. The badges indicate the history of alterations for each item.
                        </div>

                        <div class="card border-0 shadow-sm">
                            <div class="card-body p-0">
                                <div id="diffAuditView"></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 bg-light">
                        <button type="button" class="btn btn-secondary rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Close Audit</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // ==========================================
            // Render Dynamic Multiple SDGs
            // ==========================================
            function renderSDGs() {
                const impactRaw = document.getElementById('rawSdgImpact')?.value || "";
                const reasonRaw = document.getElementById('rawSdgReason')?.value || "";
                const container = document.getElementById('sdgView');

                if (!container)
                    return;

                if (!reasonRaw.trim() && !impactRaw.trim()) {
                    container.innerHTML = '<p class="text-muted fst-italic">No SDGs specified.</p>';
                    return;
                }

                let html = '<div class="d-flex flex-column gap-3">';
                if (reasonRaw.includes(' ^ ')) {
                    let reasonsArray = reasonRaw.split(' ||| ');
                    reasonsArray.forEach(reasonCombo => {
                        let parts = reasonCombo.split(' ^ ');
                        if (parts.length >= 2) {
                            let title = parts[0].trim();
                            let desc = parts.slice(1).join(' ^ ').trim();
                            html += '<div class="p-3 bg-light border border-primary border-opacity-25 rounded-3">' +
                                    '<span class="badge bg-primary mb-2 fs-6"><i class="fas fa-bullseye me-1"></i> ' + title + '</span>' +
                                    '<p class="mb-0 text-dark small content-text mt-2">' + desc + '</p></div>';
                        }
                    });
                } else {
                    let cleanSdg = impactRaw.replace(/[\[\]"]/g, '').trim();
                    html += '<div class="p-3 bg-light border border-primary border-opacity-25 rounded-3">' +
                            '<span class="badge bg-primary mb-2 fs-6"><i class="fas fa-bullseye me-1"></i> ' + (cleanSdg || 'SDG Impact') + '</span>' +
                            '<p class="mb-0 text-dark small content-text mt-2">' + reasonRaw + '</p></div>';
                }
                html += '</div>';
                container.innerHTML = html;
            }

            // ==========================================
            // SMART DIFF ENGINE (BULLETPROOF)
            // ==========================================
            function buildDiffAudit() {
                const currRaw = document.getElementById('rawBudget')?.value.trim();
                const sources = Array.from(document.querySelectorAll('.audit-data-source'));

                // Fail-safe: If no budget exists at all
                if (!currRaw) {
                    document.getElementById('diffAuditView').innerHTML = '<div class="alert alert-warning border-0 m-3"><i class="fas fa-exclamation-triangle me-2"></i>No budget data available to compare.</div>';
                    return;
                }

                let stages = [];

                // 1. Grab all snapshots from the Audit Timeline (if any)
                sources.forEach(s => {
                    let val = s.value.trim();
                    if (val && val !== 'null') {
                        stages.push({role: s.getAttribute('data-role') || 'System', raw: val});
                    }
                });

                // 2. ALWAYS append the Final Current State to guarantee rendering
                stages.push({role: 'Final Approved', raw: currRaw});

                let allKeys = new Set();
                let parsedStages = stages.map(s => {
                    let parsed = {role: s.role, items: {}, gt: '0.00'};
                    s.raw.split(/[\r\n]+/).forEach(line => {
                        let cols = line.split('|');
                        if (cols.length >= 4) {
                            let name = cols[0].trim();
                            let qty = cols[1].trim();
                            let price = cols[2].trim();
                            let total = cols[3].trim();
                            if (name === 'GRANDTOTAL') {
                                parsed.gt = total;
                            } else {
                                parsed.items[name] = {qty, price, total};
                                allKeys.add(name);
                            }
                        }
                    });
                    return parsed;
                });

                // Fail-safe: If string splitting failed
                if (allKeys.size === 0) {
                    document.getElementById('diffAuditView').innerHTML = '<div class="alert alert-warning border-0 m-3"><i class="fas fa-exclamation-triangle me-2"></i>Could not parse budget data.</div>';
                    return;
                }

                let html = '<div class="table-responsive"><table class="table align-middle text-center mb-0"><thead class="table-dark text-white"><tr><th class="text-start" style="width: 30%;">Item Description</th><th style="width: 45%;">Modification Trail</th><th style="width: 25%;">Final Approved (RM)</th></tr></thead><tbody>';

                allKeys.forEach(itemName => {
                    let finalNode = parsedStages[parsedStages.length - 1].items[itemName];
                    let finalDisplay = finalNode ? '<span class="fw-bold fs-6 text-success">RM ' + finalNode.total + '</span><br><small class="text-muted">(' + finalNode.qty + ' x RM' + finalNode.price + ')</small>' : '<span class="text-muted fst-italic">Removed</span>';

                    let changesHTML = '';
                    let prevTotal = null;

                    // Trace the history of this item through the stages safely
                    for (let i = 0; i < parsedStages.length - 1; i++) {
                        let st = parsedStages[i];
                        let currNode = st.items[itemName];
                        let currTotal = currNode ? parseFloat(currNode.total) : 0;

                        if (prevTotal === null) {
                            // First appearance in the audit log
                            prevTotal = currTotal;
                            changesHTML += '<div class="badge bg-secondary text-white mt-1 mb-1 d-block text-start"><i class="fas fa-history me-1"></i> Recorded by ' + st.role + ' (RM ' + currTotal.toFixed(2) + ')</div>';
                        } else if (currTotal !== prevTotal) {
                            let diff = currTotal - prevTotal;
                            let actionText = "";
                            let badgeClass = "";

                            if (!currNode) {
                                actionText = '<i class="fas fa-times me-1"></i> Removed by ' + st.role;
                                badgeClass = "bg-danger";
                            } else if (prevTotal === 0) {
                                actionText = '<i class="fas fa-plus me-1"></i> Added by ' + st.role + ' (RM ' + currTotal.toFixed(2) + ')';
                                badgeClass = "bg-success";
                            } else {
                                actionText = '<i class="fas fa-edit me-1"></i> Edited by ' + st.role + ' (' + (diff > 0 ? '+' : '') + 'RM ' + diff.toFixed(2) + ')';
                                badgeClass = "bg-warning text-dark border border-warning";
                            }

                            changesHTML += '<div class="badge ' + badgeClass + ' mt-1 mb-1 d-block text-start text-wrap">' + actionText + '</div>';
                            prevTotal = currTotal;
                        }
                    }

                    if (!changesHTML) {
                        changesHTML = '<span class="text-muted small fst-italic">No modifications tracked prior to approval</span>';
                    }

                    html += '<tr class="border-bottom">' +
                            '<td class="fw-bold text-start">' + itemName + '</td>' +
                            '<td class="bg-light">' + changesHTML + '</td>' +
                            '<td class="border-start border-2 border-primary">' + finalDisplay + '</td>' +
                            '</tr>';
                });

                html += '<tr class="table-light fs-5"><td colspan="2" class="text-end fw-bold">FINAL GRAND TOTAL</td>' +
                        '<td class="fw-bold text-primary">RM ' + parsedStages[parsedStages.length - 1].gt + '</td></tr></tbody></table></div>';

                const target = document.getElementById('diffAuditView');
                if (target)
                    target.innerHTML = html;
            }

            document.addEventListener('DOMContentLoaded', function () {
                renderSDGs();
                buildDiffAudit(); // Execute the Smart Diff engine
            });
        </script>
    </body>
</html>