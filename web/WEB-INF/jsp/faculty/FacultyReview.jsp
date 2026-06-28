<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Review Proposal | Faculty</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            :root {
                --faculty-color: #800000;
            }
            .text-faculty {
                color: var(--faculty-color) !important;
            }
            .border-faculty {
                border-top: 4px solid var(--faculty-color) !important;
            }
            .bg-faculty {
                background-color: var(--faculty-color) !important;
                color: white;
            }
            .btn-faculty {
                background-color: var(--faculty-color);
                color: white;
                transition: 0.3s;
            }
            .btn-faculty:hover {
                background-color: #600000;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(128,0,0,0.2);
            }
            .stepper-wrapper {
                display: flex;
                justify-content: space-between;
                position: relative;
                margin-bottom: 2rem;
            }
            .stepper-wrapper::before {
                content: '';
                position: absolute;
                top: 15px;
                left: 10%;
                right: 10%;
                height: 3px;
                background: #e9ecef;
                z-index: 1;
            }
            .step {
                position: relative;
                z-index: 2;
                text-align: center;
                width: 25%;
            }
            .step-icon {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                background: #e9ecef;
                color: #6c757d;
                line-height: 35px;
                margin: 0 auto 10px;
                font-weight: bold;
                border: 3px solid #fff;
            }
            .step.completed .step-icon {
                background: #198754;
                color: white;
            }
            .step.active .step-icon {
                background: var(--faculty-color);
                color: white;
                box-shadow: 0 0 0 4px rgba(128,0,0,0.2);
            }
            .step-label {
                font-size: 0.8rem;
                font-weight: 700;
                color: #6c757d;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .step.active .step-label {
                color: var(--faculty-color);
            }
            .section-title {
                font-size: 0.9rem;
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

                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <div>
                        <a href="${pageContext.request.contextPath}/faculty/proposals" class="btn btn-sm btn-outline-secondary mb-2 rounded-pill shadow-sm">
                            <i class="fas fa-arrow-left me-1"></i> Back to Directory
                        </a>
                        <h3 class="fw-bold mb-0 text-dark"><i class="fas fa-file-signature text-faculty me-2"></i>Faculty Proposal Review</h3>
                    </div>
                    <a href="${pageContext.request.contextPath}/GenerateDocument?id=${p.proposalId}" class="btn btn-outline-primary rounded-pill shadow-sm px-4" target="_blank">
                        <i class="fas fa-print me-2"></i> Print / PDF
                    </a>
                </div>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible shadow-sm rounded-3 mb-4">
                        <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible shadow-sm rounded-3 mb-4">
                        <i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="card border-0 shadow-sm rounded-4 mb-4">
                    <div class="card-body p-4">
                        <div class="stepper-wrapper">
                            <div class="step completed"><div class="step-icon"><i class="fas fa-check"></i></div><div class="step-label">1. Student Club</div></div>
                            <div class="step completed"><div class="step-icon"><i class="fas fa-check"></i></div><div class="step-label">2. Club Advisor</div></div>
                            <div class="step active"><div class="step-icon"><i class="fas fa-search"></i></div><div class="step-label">3. Faculty Review</div></div>
                            <div class="step"><div class="step-icon"><i class="fas fa-university"></i></div><div class="step-label">4. HEPA Final</div></div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 mb-4">
                            <div class="card-header bg-white py-3 border-0 border-bottom d-flex justify-content-between align-items-center">
                                <h5 class="fw-bold mb-0 text-faculty"><i class="fas fa-info-circle me-2"></i>Program Information</h5>
                                <span class="badge bg-light text-dark border"><i class="fas fa-hashtag me-1"></i> ID: ${p.proposalId}</span>
                            </div>
                            <div class="card-body p-4">
                                <h4 class="fw-bold text-dark mb-3">${p.title}</h4>
                                <table class="table table-borderless table-sm mb-4 bg-light rounded-3">
                                    <tbody>
                                        <tr><th class="text-muted w-25 ps-3 py-2">Club Organizer</th><td class="fw-bold text-dark py-2">${p.clubName}</td></tr>
                                        <tr><th class="text-muted ps-3 py-2">Target Date</th><td class="text-dark py-2"><i class="far fa-calendar-alt text-faculty me-2"></i> <fmt:formatDate value="${p.proposedDate}" pattern="dd MMMM yyyy" /> (${p.duration} Days)</td></tr>
                                        <tr><th class="text-muted ps-3 py-2">Target Audience</th><td class="text-dark py-2"><i class="fas fa-users text-info me-2"></i> ${p.targetAudience} (${p.estimateParticipant} Pax)</td></tr>
                                        <tr>
                                            <th class="text-muted ps-3 py-2 pb-3">Requested Budget</th>
                                            <td class="text-success fw-bold py-2 pb-3">
                                                <i class="fas fa-wallet me-2"></i>RM <fmt:formatNumber value="${p.estimateBudget}" pattern="#,##0.00" />
                                                <c:if test="${p.budgetAltered}">
                                                    <span class="badge bg-warning text-dark ms-2 border" style="font-size: 0.7rem;"><i class="fas fa-edit me-1"></i> Altered</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <div class="section-title">Background / Description</div>
                                <p class="content-text">${p.description}</p>

                                <div class="section-title">Academic Objectives</div>
                                <p class="content-text">${p.objective}</p>

                                <div class="row">
                                    <div class="col-12">
                                        <div class="section-title">Sustainable Development Goals (SDGs)</div>
                                        <textarea id="rawSdgImpact" class="d-none">${p.sdgImpact}</textarea>
                                        <textarea id="rawSdgReason" class="d-none">${p.sdgReason}</textarea>
                                        <div id="sdgView" class="mb-4"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card border-0 shadow-sm rounded-4 mb-4">
                            <div class="card-header bg-white py-3 border-0 border-bottom">
                                <h5 class="fw-bold mb-0 text-faculty"><i class="fas fa-list-alt me-2"></i>Detailed Planning</h5>
                            </div>
                            <div class="card-body p-4">

                                <div class="section-title mt-0">Committee Members</div>
                                <div class="table-responsive mb-4">
                                    <table class="table table-bordered table-sm mb-0">
                                        <thead class="table-light"><tr><th>Matric No.</th><th>Name</th><th>Role</th></tr></thead>
                                        <tbody>
                                            <c:forEach var="c" items="${p.committees}">
                                                <tr><td><small>${c.matricNo}</small></td><td><small>${c.name}</small></td><td><small>${c.role}</small></td></tr>
                                            </c:forEach>
                                            <c:if test="${empty p.committees}"><tr><td colspan="3" class="text-center text-muted">No committee members.</td></tr></c:if>
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
                                            <c:if test="${empty p.itineraries}"><tr><td colspan="3" class="text-center text-muted">No itinerary.</td></tr></c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="section-title d-flex justify-content-between align-items-center">
                                        <span>Financial Implications</span>
                                    <c:if test="${p.status == 'Pending_Faculty'}">
                                        <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#alterModal">
                                            <i class="fas fa-edit me-1"></i> Alter Budget Line-Items
                                        </button>
                                    </c:if>
                                </div>
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

                    <div class="col-lg-4">
                        <div class="card border-0 shadow-lg rounded-4 border-faculty sticky-top" style="top: 80px;">
                            <div class="card-header bg-faculty text-white py-3 border-0 rounded-top-4">
                                <h5 class="fw-bold mb-0"><i class="fas fa-stamp me-2"></i>Faculty Action Desk</h5>
                            </div>
                            <div class="card-body p-4">
                                <c:choose>
                                    <c:when test="${p.status == 'Pending_Faculty'}">
                                        <div class="card mb-4 border-0 bg-light shadow-sm">
                                            <div class="card-body d-flex align-items-center justify-content-between">
                                                <div>
                                                    <h6 class="fw-bold mb-0 text-dark"><i class="fas fa-shield-alt text-warning me-2"></i>E-Risk Doc</h6>
                                                    <small class="text-muted">Verified by Advisor.</small>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${not empty p.eriskFile}">
                                                        <a href="${pageContext.request.contextPath}/${p.eriskFile}" class="btn btn-sm btn-warning fw-bold text-dark" target="_blank"><i class="fas fa-download"></i> DL</a>
                                                    </c:when>
                                                    <c:otherwise><span class="badge bg-secondary">No File</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <form action="${pageContext.request.contextPath}/faculty/review" method="POST" id="approvalForm">
                                            <input type="hidden" name="proposalId" value="${p.proposalId}">
                                            <input type="hidden" name="action" id="formAction" value=""> 

                                            <button type="button" class="btn btn-success w-100 rounded-pill py-3 shadow-sm fw-bold mb-2" onclick="submitForm('approve_final', 'Beri kelulusan penuh (Final Approval) secara terus tanpa memanjangkan kepada HEPA?')">
                                                <i class="fas fa-check-double me-2 fs-5"></i> Final Approval (Bypass)
                                            </button>

                                            <button type="button" class="btn btn-faculty w-100 rounded-pill py-2 shadow-sm fw-bold mb-4" onclick="submitForm('approve_hepa', 'Sokong kertas kerja ini dan panjangkan ke pihak HEPA untuk kelulusan akhir?')">
                                                <i class="fas fa-share-square me-2"></i> Endorse to HEPA
                                            </button>

                                            <button type="button" class="btn btn-outline-danger w-100 rounded-pill py-2 fw-bold" data-bs-toggle="modal" data-bs-target="#rejectModal">
                                                <i class="fas fa-times-circle me-2"></i> Reject & Return
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <i class="fas fa-lock fa-4x mb-3 text-muted opacity-25"></i>
                                            <h5 class="fw-bold text-dark">Action Locked</h5>
                                            <p class="text-muted mb-0">This proposal is currently <span class="badge bg-secondary">${p.status}</span>.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- REJECT MODAL --%>
        <div class="modal fade" id="rejectModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-danger text-white border-0">
                        <h5 class="modal-title fw-bold"><i class="fas fa-exclamation-triangle me-2"></i>Return Proposal</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/faculty/review" method="POST">
                        <div class="modal-body p-4 bg-light">
                            <input type="hidden" name="proposalId" value="${p.proposalId}">
                            <input type="hidden" name="action" value="reject">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-dark">Reason for rejection / Required amendments:</label>
                                <textarea name="rejectFeedback" class="form-control border-danger" rows="5" placeholder="E.g., Objectives are not aligned with faculty goals..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold">Confirm Rejection</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%-- ALTER BUDGET MODAL --%>
        <div class="modal fade" id="alterModal" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-primary text-white border-0">
                        <h5 class="modal-title fw-bold"><i class="fas fa-edit me-2"></i>Alter Budget Line-Items</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/faculty/review" method="POST">
                        <div class="modal-body p-4 bg-light">
                            <div class="alert alert-info border-0 small d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-info-circle me-1"></i> Add, remove, or modify items as needed.</span>
                                <button type="button" class="btn btn-sm btn-success rounded-pill px-3" onclick="addBudgetRow()"><i class="fas fa-plus me-1"></i> Add Item</button>
                            </div>

                            <input type="hidden" name="proposalId" value="${p.proposalId}">
                            <input type="hidden" name="action" value="alter">

                            <div class="mb-4">
                                <label class="form-label fw-bold text-dark">Reason for Alteration (Audit Trail):</label>
                                <textarea name="alterFeedback" class="form-control" rows="2" placeholder="E.g., Reduced food budget per faculty guidelines..." required></textarea>
                            </div>

                            <div class="table-responsive bg-white rounded-3 border">
                                <table class="table table-hover align-middle mb-0" id="editableBudgetTable">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Item Description</th>
                                            <th style="width: 15%">Qty</th>
                                            <th style="width: 20%">Price/Unit (RM)</th>
                                            <th style="width: 20%" class="text-end">Total (RM)</th>
                                            <th style="width: 5%" class="text-center"><i class="fas fa-cog"></i></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%-- JSTL loops through current budgets! No Javascript parsing needed! --%>
                                        <c:forEach var="b" items="${p.budgets}">
                                            <tr>
                                                <td><input type="text" name="itemName[]" class="form-control form-control-sm" value="${b.itemName}" required></td>
                                                <td><input type="number" name="itemQty[]" class="form-control form-control-sm qty-input" value="${b.quantity}" min="1" onchange="calculateNewTotals()" required></td>
                                                <td><input type="number" step="0.01" name="itemPrice[]" class="form-control form-control-sm price-input" value="${b.unitPrice}" min="0" onchange="calculateNewTotals()" required></td>
                                                <td class="text-end fw-bold row-total">RM ${b.totalPrice}</td>
                                                <td class="text-center"><button type="button" class="btn btn-sm btn-outline-danger" onclick="this.closest('tr').remove(); calculateNewTotals();"><i class="fas fa-trash"></i></button></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot class="table-light">
                                        <tr>
                                            <th colspan="3" class="text-end fw-bold">New Grand Total:</th>
                                            <th class="text-end fw-bold text-primary fs-5" id="newGrandTotalDisplay" colspan="2">RM ${p.estimateBudget}</th>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Save Alterations</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                    // --- Render Dynamic Multiple SDGs ---
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

                                                    function submitForm(actionValue, confirmMsg) {
                                                        if (confirm(confirmMsg)) {
                                                            document.getElementById('formAction').value = actionValue;
                                                            document.getElementById('approvalForm').submit();
                                                        }
                                                    }

                                                    function addBudgetRow() {
                                                        const tbody = document.querySelector('#editableBudgetTable tbody');
                                                        const tr = document.createElement('tr');
                                                        tr.innerHTML = `
                    <td><input type="text" name="itemName[]" class="form-control form-control-sm" placeholder="E.g., Cenderahati" required></td>
                    <td><input type="number" name="itemQty[]" class="form-control form-control-sm qty-input" value="1" min="1" onchange="calculateNewTotals()" required></td>
                    <td><input type="number" step="0.01" name="itemPrice[]" class="form-control form-control-sm price-input" value="0.00" min="0" onchange="calculateNewTotals()" required></td>
                    <td class="text-end fw-bold row-total">RM 0.00</td>
                    <td class="text-center"><button type="button" class="btn btn-sm btn-outline-danger" onclick="this.closest('tr').remove(); calculateNewTotals();"><i class="fas fa-trash"></i></button></td>
                `;
                                                        tbody.appendChild(tr);
                                                    }

                                                    function calculateNewTotals() {
                                                        let grandTotal = 0;
                                                        const rows = document.querySelectorAll('#editableBudgetTable tbody tr');
                                                        rows.forEach(row => {
                                                            const qty = parseFloat(row.querySelector('.qty-input').value) || 0;
                                                            const price = parseFloat(row.querySelector('.price-input').value) || 0;
                                                            const total = qty * price;
                                                            row.querySelector('.row-total').innerText = 'RM ' + total.toFixed(2);
                                                            grandTotal += total;
                                                        });
                                                        document.getElementById('newGrandTotalDisplay').innerText = 'RM ' + grandTotal.toFixed(2);
                                                    }

                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        renderSDGs();
                                                        calculateNewTotals(); // Calculate immediately on load for accuracy
                                                    });
        </script>
    </body>
</html>