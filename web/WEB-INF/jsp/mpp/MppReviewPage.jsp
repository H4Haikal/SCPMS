<%-- 
    Document   : MppReviewPage
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Review Proposal | MPP</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
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
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <%-- Header --%>
                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <div>
                        <a href="${pageContext.request.contextPath}/mpp/proposals" class="btn btn-sm btn-outline-secondary mb-2 rounded-pill shadow-sm">
                            <i class="fas fa-arrow-left me-1"></i> Back to Proposals
                        </a>
                        <h3 class="fw-bold mb-0 text-dark"><i class="fas fa-file-signature text-primary me-2"></i>MPP Review Dashboard</h3>
                    </div>
                    <div>
                        <span class="badge bg-secondary fs-6 px-4 py-2 rounded-pill me-2">Status: ${p.status}</span>
                        <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-primary rounded-pill shadow-sm" target="_blank">
                            <i class="fas fa-file-pdf me-2"></i> View Full PDF
                        </a>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success shadow-sm"><i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}</div>
                        <c:remove var="successMessage" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger shadow-sm"><i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.errorMessage}</div>
                        <c:remove var="errorMessage" scope="session"/>
                    </c:if>

                <div class="row g-4">
                    <%-- LEFT COLUMN: FULL PROPOSAL DATA --%>
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 mb-4">
                            <div class="card-header bg-white py-3 border-0 border-bottom">
                                <h5 class="fw-bold mb-0 text-primary"><i class="fas fa-info-circle me-2"></i>Program Details</h5>
                            </div>
                            <div class="card-body p-4">
                                <h4 class="fw-bold text-dark mb-1">${p.title}</h4>
                                <p class="text-muted small mb-4">ID: #${p.proposalId} &nbsp;|&nbsp; Club: <span class="badge bg-dark">${p.clubName}</span></p>

                                <table class="table table-borderless mb-4">
                                    <tbody>
                                        <tr><th class="text-muted w-25">Target Date</th><td><i class="far fa-calendar-alt text-primary me-2"></i> <fmt:formatDate value="${p.proposedDate}" pattern="dd MMMM yyyy" /> (${p.duration} Days)</td></tr>
                                        <tr><th class="text-muted">Venue</th><td><i class="fas fa-map-marker-alt text-danger me-2"></i> ${p.venue}</td></tr>
                                        <tr>
                                            <th class="text-muted">Est. Budget</th>
                                            <td class="text-success fw-bold">
                                                <i class="fas fa-wallet me-2"></i> RM <fmt:formatNumber value="${p.estimateBudget}" type="currency" currencySymbol="" />

                                                <%-- The MPP Altered Badge --%>
                                                <c:if test="${p.budgetAltered}">
                                                    <span class="badge bg-warning text-dark ms-2 border" style="font-size: 0.7rem;"><i class="fas fa-edit me-1"></i> Edited by MPP</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="section-title">Background</div>
                                <p class="content-text">${p.description}</p>

                                <div class="section-title">Objectives</div>
                                <p class="content-text">${p.objective}</p>

                                <div class="row">
                                    <div class="col-12">
                                        <div class="section-title">Sustainable Development Goals (SDGs)</div>
                                        <textarea id="rawSdgImpact" class="d-none">${p.sdgImpact}</textarea>
                                        <textarea id="rawSdgReason" class="d-none">${p.sdgReason}</textarea>
                                        <div id="sdgView" class="mb-4"></div>
                                    </div>
                                </div>

                                <div class="section-title mt-4">Tentative Schedule</div>
                                <div class="table-responsive mb-4">
                                    <table class="table table-bordered table-sm mb-0">
                                        <thead class="table-light"><tr><th width="20%">Day</th><th width="20%">Time</th><th>Activity</th></tr></thead>
                                        <tbody>
                                            <c:forEach var="itin" items="${p.itineraries}">
                                                <tr><td><small>${itin.day}</small></td><td><small>${itin.time}</small></td><td><small>${itin.activity}</small></td></tr>
                                            </c:forEach>
                                            <c:if test="${empty p.itineraries}"><tr><td colspan="3" class="text-center text-muted">No itinerary.</td></tr></c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="section-title">Financial Implications</div>
                                    <div class="table-responsive mb-4">
                                        <table class="table table-bordered table-sm mb-0">
                                            <thead class="table-light"><tr><th>Item / Description</th><th class="text-center">Qty</th><th class="text-center">Unit Price (RM)</th><th class="text-end">Total (RM)</th></tr></thead>
                                            <tbody>
                                            <c:forEach var="b" items="${p.budgets}">
                                                <tr><td><small>${b.itemName}</small></td><td class="text-center"><small>${b.quantity}</small></td><td class="text-center"><small><fmt:formatNumber value="${b.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></small></td><td class="text-end fw-bold"><small><fmt:formatNumber value="${b.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></small></td></tr>
                                                        </c:forEach>
                                                                        <c:if test="${empty p.budgets}"><tr><td colspan="4" class="text-center text-muted">No budget details.</td></tr></c:if>
                                            </tbody>
                                            <tfoot class="table-light">
                                                <tr class="fw-bold"><td colspan="3" class="text-end text-uppercase">Grand Total (RM)</td><td class="text-success fs-6 text-end"><fmt:formatNumber value="${p.estimateBudget}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td></tr>
                                        </tfoot>
                                    </table>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%-- RIGHT COLUMN: ACTIONS & ATTACHMENTS --%>
                    <div class="col-lg-4">
                        <div class="sticky-top" style="top: 20px; z-index: 1;">

                            <%-- 1. ADVISOR E-RISK VIEW --%>
                            <div class="card border-0 shadow-sm rounded-4 border-top border-4 border-success mb-4">
                                <div class="card-body p-4">
                                    <h6 class="fw-bold text-success mb-2"><i class="fas fa-shield-alt me-2"></i>Advisor's E-Risk Assessment</h6>
                                    <c:choose>
                                        <c:when test="${not empty p.eriskFile}">
                                            <p class="small text-muted mb-3">The club advisor has uploaded the approved risk assessment.</p>
                                            <a href="${pageContext.request.contextPath}/${p.eriskFile}" target="_blank" class="btn btn-sm btn-outline-success w-100"><i class="fas fa-file-pdf me-1"></i> View E-Risk Document</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger small"><i class="fas fa-times-circle me-1"></i> No E-Risk document was uploaded.</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <%-- 2. MPP MEETING MINUTES VIEW/UPLOAD --%>
                            <div class="card border-0 shadow-sm rounded-4 border-top border-4 border-primary mb-4">
                                <div class="card-body p-4">
                                    <h6 class="fw-bold text-primary mb-3"><i class="fas fa-file-alt me-2"></i>MPP Meeting Minutes</h6>
                                    <c:choose>
                                        <c:when test="${not empty p.mppMinutesFile}">
                                            <div class="alert alert-success py-2 px-3 small mb-3"><i class="fas fa-check-circle me-2"></i> <a href="${pageContext.request.contextPath}/${p.mppMinutesFile}" target="_blank" class="text-success fw-bold text-decoration-none">View Attached Minutes</a></div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger small mb-3 d-block"><i class="fas fa-times-circle me-1"></i> No Minutes uploaded yet.</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:if test="${p.status == 'Pending_MPP' || p.status == 'Meeting_Scheduled'}">
                                        <form action="${pageContext.request.contextPath}/UploadMPPMinutesServlet" method="POST" enctype="multipart/form-data">
                                            <input type="hidden" name="proposalId" value="${p.proposalId}">
                                            <div class="input-group input-group-sm">
                                                <input type="file" name="mppMinutesFile" class="form-control" accept=".pdf,.doc,.docx" required>
                                                <button type="submit" class="btn btn-primary"><i class="fas fa-upload"></i></button>
                                            </div>
                                        </form>
                                    </c:if>
                                </div>
                            </div>

                            <%-- 3. ACTIONS PANEL --%>
                            <c:choose>
                                <c:when test="${p.status == 'Pending_MPP' || p.status == 'Meeting_Scheduled'}">
                                    <div class="card border-0 shadow-sm rounded-4 border-top border-4 border-warning">
                                        <div class="card-body p-4">
                                            <h6 class="fw-bold text-dark border-bottom pb-2 mb-3"><i class="fas fa-gavel text-warning me-2"></i>MPP Actions</h6>

                                            <%-- Pitching & Alter Tools --%>
                                            <div class="d-flex gap-2 mb-4">
                                                <button type="button" class="btn btn-sm btn-info text-white w-50" data-bs-toggle="modal" data-bs-target="${p.status == 'Meeting_Scheduled' ? '#editScheduleModal' : '#scheduleModal'}">
                                                    <i class="fas fa-video"></i> ${p.status == 'Meeting_Scheduled' ? 'View/Edit Pitching' : 'Set Pitching'}
                                                </button>
                                                <button type="button" class="btn btn-sm btn-primary w-50" data-bs-toggle="modal" data-bs-target="#alterModal" onclick="calculateAlterTotal()">
                                                    <i class="fas fa-edit"></i> Alter Data
                                                </button>
                                            </div>

                                            <%-- Endorse / Reject Form --%>
                                            <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST" onsubmit="return confirm('Confirm this decision?');">
                                                <input type="hidden" name="proposalId" value="${p.proposalId}">
                                                <label class="form-label fw-bold text-muted small">Final Remarks / Feedback</label>
                                                <textarea name="feedback" class="form-control bg-light mb-3" rows="4" placeholder="Type feedback for CHC/HEPA..."></textarea>
                                                <div class="d-grid gap-2">
                                                    <c:choose>
                                                        <c:when test="${empty p.mppMinutesFile}">
                                                            <button type="button" class="btn btn-secondary fw-bold" onclick="alert('Action Locked: Please upload Meeting Minutes first.');"><i class="fas fa-lock me-2"></i> Endorse (Locked)</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="submit" name="action" value="approve" class="btn btn-success fw-bold"><i class="fas fa-check-double me-2"></i> Endorse to HEPA</button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button type="submit" name="action" value="reject" class="btn btn-outline-danger fw-bold"><i class="fas fa-undo me-2"></i> Return to CHC</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="card border-0 shadow-sm rounded-4 border-top border-4 border-secondary text-center p-5">
                                        <i class="fas fa-check-circle fa-3x text-success mb-3 opacity-75"></i>
                                        <h5 class="fw-bold text-dark">Review Completed</h5>
                                        <p class="text-muted small mb-0">The MPP cycle is closed for this proposal.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- SCHEDULE MODALS (Same as before) --%>
        <div class="modal fade" id="scheduleModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-info text-white"><h5 class="modal-title">Schedule Pitching</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div>
                    <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="schedule"><input type="hidden" name="proposalId" value="${p.proposalId}">
                            <div class="row g-3">
                                <div class="col-6"><label class="small fw-bold">Start Time</label><input type="datetime-local" name="startTime" class="form-control" required></div>
                                <div class="col-6"><label class="small fw-bold">End Time</label><input type="datetime-local" name="endTime" class="form-control" required></div>
                                <div class="col-12"><label class="small fw-bold">Google Meet Link</label><input type="url" name="meetingLink" class="form-control" placeholder="Optional"></div>
                            </div>
                        </div>
                        <div class="modal-footer"><button type="submit" class="btn btn-info text-white w-100">Send Invite</button></div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editScheduleModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-warning text-dark"><h5 class="modal-title">Edit Pitching Schedule</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                    <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="reschedule"><input type="hidden" name="proposalId" value="${p.proposalId}">
                            <div class="alert alert-light border"><strong>Current:</strong> <fmt:formatDate value="${p.pitchingDate}" pattern="dd MMM yyyy, hh:mm a" /><br><strong>Link:</strong> <a href="${p.pitchingLocation}" target="_blank">View Link</a></div>
                            <div class="row g-3">
                                <div class="col-6"><label class="small fw-bold">New Start</label><input type="datetime-local" name="startTime" class="form-control" required></div>
                                <div class="col-6"><label class="small fw-bold">New End</label><input type="datetime-local" name="endTime" class="form-control" required></div>
                                <div class="col-12"><label class="small fw-bold">New Meet Link</label><input type="url" name="meetingLink" class="form-control" placeholder="Optional"></div>
                            </div>
                        </div>
                        <div class="modal-footer"><button type="submit" class="btn btn-warning w-100 fw-bold">Update & Notify</button></div>
                    </form>
                </div>
            </div>
        </div>

        <%-- ALTER PROPOSAL MODAL (DYNAMIC 3NF TABLE) --%>
        <div class="modal fade text-start" id="alterModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-primary text-white border-0">
                        <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Alter Budget Details</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/mpp/proposals" method="POST">
                        <div class="modal-body bg-light">
                            <input type="hidden" name="action" value="alter"><input type="hidden" name="proposalId" value="${p.proposalId}">

                            <div class="alert alert-primary border-0 small mb-4">
                                <i class="fas fa-info-circle me-2"></i> Edit quantities, prices, or remove items. Items modified will be tagged so the CHC knows what changed.
                            </div>

                            <div class="table-responsive bg-white border rounded-3 mb-3">
                                <table class="table table-sm align-middle mb-0" id="alterBudgetTable">
                                    <thead class="table-light">
                                        <tr><th style="width: 45%;">Item Name</th><th style="width: 15%;">Qty</th><th style="width: 20%;">Price (RM)</th><th style="width: 15%;">Total</th><th style="width: 5%;"></th></tr>
                                    </thead>
                                    <tbody id="alterBudgetBody">
                                        <%-- JSTL loops through current budgets! No Javascript parsing needed! --%>
                                        <c:forEach var="b" items="${p.budgets}">
                                            <tr>
                                                <td><input type="text" name="itemName[]" class="form-control form-control-sm item-name" value="${b.itemName}" required></td>
                                                <td><input type="number" name="itemQty[]" class="form-control form-control-sm item-qty" value="${b.quantity}" min="1" required oninput="calculateAlterTotal()"></td>
                                                <td><input type="number" name="itemPrice[]" step="0.01" class="form-control form-control-sm item-price" value="${b.unitPrice}" required oninput="calculateAlterTotal()"></td>
                                                <td><input type="text" class="form-control form-control-sm item-total border-0 bg-transparent fw-bold" readonly value="${b.totalPrice}"></td>
                                                <td><button type="button" class="btn btn-sm btn-outline-danger border-0" onclick="this.closest('tr').remove(); calculateAlterTotal()"><i class="fas fa-trash"></i></button></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
                                        <tr class="table-light"><td colspan="5"><button type="button" class="btn btn-sm btn-outline-primary fw-bold" onclick="addAlterRow()"><i class="fas fa-plus me-1"></i> Add Row</button></td></tr>
                                        <tr><td colspan="3" class="text-end fw-bold">NEW GRAND TOTAL (RM):</td><td colspan="2"><input type="text" id="alterGrandTotal" class="form-control form-control-sm fw-bold text-success border-0 bg-transparent" readonly value="${p.estimateBudget}"></td></tr>
                                    </tfoot>
                                </table>
                            </div>

                            <div class="mb-3">
                                <label class="small fw-bold text-secondary">Alteration Reason (Required)</label>
                                <textarea name="alterFeedback" class="form-control" rows="2" placeholder="E.g., Removed VIP food, slashed banner budget..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer border-0 bg-light">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary fw-bold">Save Alterations</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                            // --- RENDER SDGs ---
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
                                                            html += '<div class="p-3 bg-light border border-primary border-opacity-25 rounded-3"><span class="badge bg-primary mb-2 fs-6"><i class="fas fa-bullseye me-1"></i> ' + title + '</span><p class="mb-0 text-dark small content-text mt-2">' + desc + '</p></div>';
                                                        }
                                                    });
                                                } else {
                                                    let cleanSdg = impactRaw.replace(/[\[\]"]/g, '').trim();
                                                    html += '<div class="p-3 bg-light border border-primary border-opacity-25 rounded-3"><span class="badge bg-primary mb-2 fs-6"><i class="fas fa-bullseye me-1"></i> ' + (cleanSdg || 'SDG Impact') + '</span><p class="mb-0 text-dark small content-text mt-2">' + reasonRaw + '</p></div>';
                                                }
                                                html += '</div>';
                                                container.innerHTML = html;
                                            }

                                            // --- ALTER BUDGET DYNAMIC TABLE ---
                                            const alterBody = document.getElementById('alterBudgetBody');
                                            const alterGrandTotal = document.getElementById('alterGrandTotal');

                                            function addAlterRow(name = '', qty = '1', price = '0.00') {
                                                const tr = document.createElement('tr');
                                                tr.innerHTML = `
                <td><input type="text" name="itemName[]" class="form-control form-control-sm item-name" value="` + name + `" required></td>
                <td><input type="number" name="itemQty[]" class="form-control form-control-sm item-qty" value="` + qty + `" min="1" required oninput="calculateAlterTotal()"></td>
                <td><input type="number" name="itemPrice[]" step="0.01" class="form-control form-control-sm item-price" value="` + price + `" required oninput="calculateAlterTotal()"></td>
                <td><input type="text" class="form-control form-control-sm item-total border-0 bg-transparent fw-bold" readonly value="0.00"></td>
                <td><button type="button" class="btn btn-sm btn-outline-danger border-0" onclick="this.closest('tr').remove(); calculateAlterTotal()"><i class="fas fa-trash"></i></button></td>`;
                                                alterBody.appendChild(tr);
                                                calculateAlterTotal();
                                            }

                                            function calculateAlterTotal() {
                                                let grand = 0;
                                                document.querySelectorAll('#alterBudgetBody tr').forEach(row => {
                                                    const qty = parseFloat(row.querySelector('.item-qty').value) || 0;
                                                    const price = parseFloat(row.querySelector('.item-price').value) || 0;
                                                    const total = qty * price;
                                                    row.querySelector('.item-total').value = total.toFixed(2);
                                                    grand += total;
                                                });
                                                alterGrandTotal.value = grand.toFixed(2);
                                            }

                                            document.addEventListener('DOMContentLoaded', () => {
                                                renderSDGs();
                                                calculateAlterTotal(); // Ensure calculation is correct on load
                                            });
        </script>
    </body>
</html>