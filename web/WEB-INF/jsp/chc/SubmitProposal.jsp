<%-- 
    Document   : ProposalCreate
    Purpose    : Submit or Edit Proposal with Heuristic AI & Dynamic SDGs
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${isEditMode ? 'Edit Draft' : 'Submit Proposal'} | UMT ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .form-section-title {
                color: #0d6efd;
                font-weight: 700;
                font-size: 1.1rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 1.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #e9ecef;
            }
            .custom-textarea {
                min-height: 120px;
            }
            @keyframes pulse {
                0% {
                    box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.7);
                    opacity: 1;
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(220, 53, 69, 0);
                    opacity: 0.8;
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(220, 53, 69, 0);
                    opacity: 1;
                }
            }
            .fab-btn {
                position: fixed;
                bottom: 2rem;
                right: 2rem;
                width: 65px;
                height: 65px;
                border-radius: 50%;
                z-index: 1040;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: transform 0.2s;
            }
            .fab-btn:active {
                transform: scale(0.9);
            }
            /* The Modern Sticky Drawer */
            #aiDrawerContainer {
                position: -webkit-sticky;
                position: sticky;
                top: 2rem;
                max-height: 75vh; /* Lowered from 85vh to 75vh for plenty of bottom clearance */
                overflow-y: auto;
                overscroll-behavior-y: contain;
                z-index: 1020;
                padding-bottom: 1rem; /* Adds a nice cushion of space at the very bottom of the scroll */
            }

            /* Custom Scrollbar for the Drawer */
            #aiDrawerContainer::-webkit-scrollbar {
                width: 6px;
            }
            #aiDrawerContainer::-webkit-scrollbar-track {
                background: transparent;
            }
            #aiDrawerContainer::-webkit-scrollbar-thumb {
                background-color: rgba(13, 110, 253, 0.3);
                border-radius: 10px;
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">

            <div class="top-header mb-4 d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <div>
                        <h3 class="fw-bold mb-0 text-primary">
                            <i class="fas fa-file-signature me-2"></i>
                            ${isEditMode ? 'Edit Draft Proposal' : 'Submit New Proposal'}
                        </h3>
                        <p class="text-muted mt-1 mb-0">
                            ${isEditMode ? 'Continue editing your saved draft.' : 'Draft and submit your club\'s event proposal for review.'}
                        </p>
                    </div>
                </div>
            </div>

            <div class="alert alert-info border-info shadow-sm rounded-4 mb-4 d-flex align-items-center">
                <i class="fas fa-wallet fa-2x me-3 text-info"></i>
                <div>
                    <h6 class="fw-bold mb-0 text-dark">Club Annual Financial Limit</h6>
                    <span class="small text-muted">Remaining Balance: </span>
                    <strong class="text-success fs-5">RM <fmt:formatNumber value="${remainingBudget}" pattern="#,##0.00" /></strong> <span class="small text-muted">/ RM 1,000.00</span>
                </div>
            </div>

            <div class="row" id="mainFormRow">
                <%-- LEFT SIDE: LONG FORM --%>
                <div class="col-lg-8 mb-4">
                    <div class="card border-0 shadow-sm rounded-4">
                        <div class="card-body p-4 p-md-5">

                            <form action="${pageContext.request.contextPath}/SubmitProposalServlet" method="POST" id="proposalForm">

                                <c:if test="${isEditMode}">
                                    <input type="hidden" name="proposalId" value="${draft.proposalId}">
                                    <input type="hidden" name="isEditMode" value="true">
                                </c:if>
                                <input type="hidden" name="currentStatus" value="${draft.status}">

                                <c:if test="${draft.status == 'Approved_Condition'}">
                                    <div class="alert alert-warning border-4 border-warning shadow-sm rounded-4 mb-4 p-4">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="fas fa-exclamation-triangle fa-2x text-warning me-3"></i>
                                            <h5 class="alert-heading fw-bold mb-0 text-dark">Revision Required by HEPA</h5>
                                        </div>
                                        <p class="mb-2 text-dark">Your proposal has been reviewed, but it requires minor amendments before the final official approval can be granted.</p>
                                        <div class="bg-white p-3 rounded-3 border">
                                            <span class="badge bg-warning text-dark mb-2">HEPA Official Remarks</span>
                                            <p class="mb-0 text-dark" style="white-space: pre-wrap;"><strong>${draft.hepaRemark}</strong></p>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="form-section-title mt-2">
                                    <i class="fas fa-info-circle me-2"></i>Part A: Basic Event Details
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold text-secondary">Proposal Type <span class="text-danger">*</span></label>
                                    <select name="proposalType" class="form-select form-control-lg bg-light border-0 shadow-none" required>
                                        <option value="" disabled ${empty draft.proposalType ? 'selected' : ''}>Select proposal type...</option>
                                        <option value="AGM" ${draft.proposalType == 'AGM' ? 'selected' : ''}>Annual General Meeting (AGM)</option>
                                        <option value="Event" ${draft.proposalType == 'Event' ? 'selected' : ''}>Event / Program</option>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold text-secondary">Program / Event Title <span class="text-danger">*</span></label>
                                    <input type="text" name="title" class="form-control form-control-lg bg-light border-0 shadow-none" placeholder="E.g., Basic Robotics Workshop 2026" value="${draft.title}" required>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold text-secondary">Background / Executive Summary <span class="text-danger">*</span></label>
                                    <textarea name="description" class="form-control bg-light border-0 shadow-none" rows="3" placeholder="Briefly describe the background of the program..." required>${draft.description}</textarea>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-4 mb-3 mb-md-0">
                                        <label class="form-label fw-bold text-secondary">Start Date <span class="text-danger">*</span></label>
                                        <input type="date" name="proposedDate" id="startDate" class="form-control bg-light border-0 shadow-none" value="${draft.proposedDate}" required>
                                    </div>
                                    <div class="col-md-4 mb-3 mb-md-0">
                                        <label class="form-label fw-bold text-secondary">End Date <span class="text-danger">*</span></label>
                                        <input type="date" name="endDate" id="endDate" class="form-control bg-light border-0 shadow-none" value="${draft.endDate}" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold text-secondary">Duration (Days) <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-0"><i class="fas fa-clock text-muted"></i></span>
                                            <input type="number" name="duration" id="durationInput" class="form-control bg-light border-0 shadow-none fw-bold" value="${draft.duration}" readonly required>
                                        </div>
                                    </div>
                                </div>

                                <label class="form-label fw-bold text-secondary">Participants Breakdown <span class="text-danger">*</span></label>
                                <div class="row mb-4 g-2">
                                    <div class="col-md-3">
                                        <small class="text-muted d-block mb-1">UMT Students</small>
                                        <input type="number" name="participantUmt" id="partUmt"
                                               class="form-control bg-light border-0" min="0" placeholder="0" 
                                               value="${not empty draft.participantUmt ? draft.participantUmt : 0}" required>
                                    </div>
                                    <div class="col-md-3">
                                        <small class="text-muted d-block mb-1">UMT Staff</small>
                                        <input type="number" name="participantStaff" id="partStaff"
                                               class="form-control bg-light border-0" min="0" placeholder="0" 
                                               value="${not empty draft.participantStaff ? draft.participantStaff : 0}" required>
                                    </div>
                                    <div class="col-md-3">
                                        <small class="text-muted d-block mb-1">Public / Others</small>
                                        <input type="number" name="participantPublic" id="partPublic"
                                               class="form-control bg-light border-0" min="0" placeholder="0" 
                                               value="${not empty draft.participantPublic ? draft.participantPublic : 0}" required>
                                        <input type="text" name="participantOtherDesc" class="form-control form-control-sm bg-white border mt-1" placeholder="Specify (e.g. High schoolers)" value="${draft.participantOtherDesc}">
                                    </div>
                                    <div class="col-md-3">
                                        <small class="fw-bold text-primary d-block mb-1">Total</small>
                                        <input type="number" name="estimateParticipant" id="totalPart"
                                               class="form-control bg-primary-subtle text-primary border-0 fw-bold" placeholder="0"
                                               value="${not empty draft.estimateParticipant ? draft.estimateParticipant : 0}" readonly required>
                                    </div>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3 mb-md-0">
                                        <label class="form-label fw-bold text-secondary">Proposed Venue <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-0"><i class="fas fa-map-marker-alt text-muted"></i></span>
                                            <input type="text" name="venue" class="form-control bg-light border-0 shadow-none" placeholder="E.g., Dewan Sultan Mizan, UMT" value="${draft.venue}" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-secondary">Estimated Budget (RM) <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light border-0 text-muted fw-bold">RM</span>
                                            <input type="number" step="0.01" name="estimateBudget" id="mainBudgetInput" class="form-control bg-light border-0 shadow-none" placeholder="0.00" value="${draft.estimateBudget}" readonly required>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold text-secondary">Target Audience <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="fas fa-bullseye text-muted"></i></span>
                                        <input type="text" name="targetAudience" class="form-control bg-light border-0 shadow-none" placeholder="E.g., All FKK Students" value="${draft.targetAudience}" required>
                                    </div>
                                </div>

                                <%-- NEW: YES/NO CLUB FUNDING RADIO BUTTONS --%>
                                <div class="mb-4 p-3 border rounded-3 bg-white">
                                    <label class="form-label fw-bold text-secondary mb-1">Will this program utilize the Club's Annual RM 1,000 Wallet? <span class="text-danger">*</span></label>
                                    <p class="small text-muted mb-2">Select "No" if the event is 100% sponsored or independently funded.</p>
                                    <div class="d-flex flex-wrap gap-4 mt-2">
                                        <div class="form-check">
                                            <input class="form-check-input club-fund-radio" type="radio" name="isClubFunded" id="fundYes" value="true" ${draft.clubFunded != false ? 'checked' : ''} required>
                                            <label class="form-check-label fw-bold" for="fundYes">Yes, use club funds</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input club-fund-radio" type="radio" name="isClubFunded" id="fundNo" value="false" ${draft.clubFunded == false ? 'checked' : ''} required>
                                            <label class="form-check-label fw-bold text-success" for="fundNo">No, fully independent/sponsored</label>
                                        </div>
                                    </div>
                                </div>

                                <%-- NEW: STRUCTURED FINANCING SOURCE FIELDS --%>
                                <div class="mb-4 p-3 border rounded-3 bg-light">
                                    <label class="form-label fw-bold text-secondary mb-2">Alternative/External Sources of Revenue</label>
                                    <p class="small text-muted mb-3">Please fill out any additional revenue channels applicable to this event (Leave 0 if none).</p>

                                    <div class="row g-3">
                                        <!-- 1. Participant Fees -->
                                        <div class="col-md-4">
                                            <label class="form-label small fw-bold">Yuran Peserta Total (RM)</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-white border-end-0">RM</span>
                                                <input type="number" step="0.01" name="budgetYuran" class="form-control border-start-0" value="0.00" min="0">
                                            </div>
                                        </div>

                                        <!-- 2. University/PTj Contributions -->
                                        <div class="col-md-4">
                                            <label class="form-label small fw-bold">Sumbangan PTj/Universiti (RM)</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-white border-end-0">RM</span>
                                                <input type="number" step="0.01" name="budgetPtj" class="form-control border-start-0" value="0.00" min="0">
                                            </div>
                                        </div>

                                        <!-- 3. External Sponsors -->
                                        <div class="col-md-4">
                                            <label class="form-label small fw-bold">Sumbangan Luar/Penaja (RM)</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-white border-end-0">RM</span>
                                                <input type="number" step="0.01" name="budgetLuar" class="form-control border-start-0" value="0.00" min="0">
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div class="form-section-title mt-5">
                                    <i class="fas fa-file-pdf me-2"></i>Part B: Official Document Details
                                    <small class="d-block text-muted text-lowercase font-monospace mt-1" style="font-size: 0.8rem; letter-spacing: normal;">* Data provided here will be formatted into the PDF.</small>
                                </div>

                                <div class="row g-4 mb-4">
                                    <div class="col-12">
                                        <label class="form-label fw-bold text-secondary">1. Program Objectives <span class="text-danger">*</span></label>
                                        <textarea class="form-control bg-light border-0 shadow-none custom-textarea" name="objective" placeholder="1. Help students understand...&#10;2. Provide exposure to..." required>${draft.objective}</textarea>
                                    </div>

                                    <div class="col-12 mt-4">
                                        <label class="form-label fw-bold text-secondary">2. Sustainable Development Goals (SDGs) <span class="text-danger">*</span></label>
                                        <div class="bg-white p-3 border rounded-4 shadow-sm mb-3">
                                            <p class="text-muted small mb-3"><i class="fas fa-info-circle me-1"></i>Select all relevant SDGs for your event (you can choose multiple):</p>
                                            <div class="d-flex flex-wrap gap-2">
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg1" value="SDG 1: No Poverty" data-sdg="1" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg1">1. No Poverty</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg2" value="SDG 2: Zero Hunger" data-sdg="2" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg2">2. Zero Hunger</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg3" value="SDG 3: Good Health & Well-being" data-sdg="3" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg3">3. Good Health</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg4" value="SDG 4: Quality Education" data-sdg="4" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg4">4. Quality Education</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg5" value="SDG 5: Gender Equality" data-sdg="5" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg5">5. Gender Equality</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg6" value="SDG 6: Clean Water & Sanitation" data-sdg="6" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg6">6. Clean Water</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg7" value="SDG 7: Affordable & Clean Energy" data-sdg="7" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg7">7. Clean Energy</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg8" value="SDG 8: Decent Work & Economic Growth" data-sdg="8" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg8">8. Economic Growth</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg9" value="SDG 9: Industry, Innovation & Infrastructure" data-sdg="9" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg9">9. Innovation</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg10" value="SDG 10: Reduced Inequalities" data-sdg="10" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg10">10. Reduced Inequalities</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg11" value="SDG 11: Sustainable Cities & Communities" data-sdg="11" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg11">11. Sustainable Cities</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg12" value="SDG 12: Responsible Consumption & Production" data-sdg="12" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg12">12. Responsible Consumption</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg13" value="SDG 13: Climate Action" data-sdg="13" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg13">13. Climate Action</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg14" value="SDG 14: Life Below Water" data-sdg="14" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg14">14. Life Below Water</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg15" value="SDG 15: Life on Land" data-sdg="15" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg15">15. Life on Land</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg16" value="SDG 16: Peace, Justice & Strong Institutions" data-sdg="16" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg16">16. Peace & Justice</label>
                                                <input type="checkbox" class="btn-check sdg-checkbox" id="sdg17" value="SDG 17: Partnerships for the Goals" data-sdg="17" onchange="toggleSdgReason(this)">
                                                <label class="btn btn-outline-primary rounded-pill btn-sm fw-bold px-3 py-2" for="sdg17">17. Partnerships</label>
                                            </div>
                                        </div>

                                        <div id="sdg-reasons-container"></div>

                                        <textarea name="sdgImpact" id="hiddenSdgImpact" style="display:none;">${draft.sdgImpact}</textarea>
                                        <textarea name="sdgReason" id="hiddenSdgReason" style="display:none;">${draft.sdgReason}</textarea>
                                    </div>

                                    <%-- WE REBUILD THE HIDDEN TENTATIVE STRING FROM 3NF DATA FOR JS --%>
                                    <textarea name="tentative" id="hiddenTentative" style="display:none;"><c:forEach var="itin" items="${draft.itineraries}">${itin.day}|${itin.time}|${itin.activity}&#10;</c:forEach></textarea>
                                        <textarea name="committee" id="hiddenCommittee" style="display:none;"></textarea>

                                        <div class="col-12 mt-4">
                                            <label class="form-label fw-bold text-secondary">3. Tentative Program <span class="text-danger">*</span></label>
                                            <div id="tentative-container" class="border rounded-3 p-3 bg-white">
                                                <div class="text-center text-muted small py-3" id="tentative-placeholder">
                                                    <i class="fas fa-calendar-day fa-2x mb-2"></i><br>Please enter valid 'Dates' in Part A to generate the tentative schedule.
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-12 mt-4">
                                            <label class="form-label fw-bold text-secondary">4. Committee Members <span class="text-danger">*</span></label>
                                            <div class="table-responsive border rounded-3 bg-white p-2">
                                                <table class="table table-borderless table-sm mb-0" id="committee-table">
                                                    <thead class="border-bottom">
                                                        <tr>
                                                            <th width="20%" class="text-muted small">Matric No.</th>
                                                            <th width="45%" class="text-muted small">Full Name</th>
                                                            <th width="25%" class="text-muted small">Role / Position</th>
                                                            <th width="10%"></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="committee-body">
                                                    <c:choose>
                                                        <c:when test="${not empty draft.committees}">
                                                            <c:forEach var="c" items="${draft.committees}">
                                                                <tr>
                                                                    <td><input type="text" name="matricNo[]" class="form-control form-control-sm bg-light border-0 comm-matrik" value="${c.matricNo}" required></td>
                                                                    <td><input type="text" name="commName[]" class="form-control form-control-sm bg-light border-0 comm-nama" value="${c.name}" required></td>
                                                                    <td><input type="text" name="role[]" class="form-control form-control-sm bg-light border-0 comm-role" value="${c.role}" required></td>
                                                                    <td class="text-center"><button type="button" class="btn btn-sm text-danger" onclick="removeRow(this)"><i class="fas fa-trash"></i></button></td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <tr>
                                                                <td><input type="text" name="matricNo[]" class="form-control form-control-sm bg-light border-0 comm-matrik" placeholder="S12345" required></td>
                                                                <td><input type="text" name="commName[]" class="form-control form-control-sm bg-light border-0 comm-nama" placeholder="Member Name" required></td>
                                                                <td><input type="text" name="role[]" class="form-control form-control-sm bg-light border-0 comm-role" placeholder="Role" required></td>
                                                                <td class="text-center"><button type="button" class="btn btn-sm text-danger" onclick="removeRow(this)"><i class="fas fa-trash"></i></button></td>
                                                            </tr>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                            <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addCommitteeRow()"><i class="fas fa-plus me-1"></i> Add Member</button>
                                        </div>
                                    </div>

                                    <div class="col-12 mt-4">
                                        <label class="form-label fw-bold text-secondary">5. Financial Implications (Budget) <span class="text-danger">*</span></label>
                                        <div class="table-responsive border rounded-3 bg-white p-2">
                                            <table class="table table-borderless table-sm mb-0" id="financial-table">
                                                <thead class="border-bottom">
                                                    <tr>
                                                        <th width="45%" class="text-muted small">Item / Description</th>
                                                        <th width="15%" class="text-muted small text-center">Quantity</th>
                                                        <th width="15%" class="text-muted small text-center">Unit Price (RM)</th>
                                                        <th width="15%" class="text-muted small text-end">Total (RM)</th>
                                                        <th width="10%"></th>
                                                    </tr>
                                                </thead>
                                                <tbody id="financial-body">
                                                    <c:choose>
                                                        <c:when test="${not empty draft.budgets}">
                                                            <c:forEach var="b" items="${draft.budgets}">
                                                                <tr>
                                                                    <td><input type="text" name="itemName[]" class="form-control form-control-sm bg-light border-0 fin-item" value="${b.itemName}" required></td>
                                                                    <td><input type="number" name="quantity[]" min="1" class="form-control form-control-sm bg-light border-0 text-center fin-qty" value="${b.quantity}" oninput="calculateRowTotal(this)"></td>
                                                                    <td><input type="number" name="unitPrice[]" min="0" step="0.01" class="form-control form-control-sm bg-light border-0 text-center fin-price" value="${b.unitPrice}" oninput="calculateRowTotal(this)"></td>
                                                                    <td><input type="text" name="totalPrice[]" class="form-control form-control-sm border-0 text-end fw-bold fin-total" value="${b.totalPrice}" readonly></td>
                                                                    <td class="text-center"><button type="button" class="btn btn-sm text-danger" onclick="removeRow(this); calculateGrandTotal()"><i class="fas fa-trash"></i></button></td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <tr>
                                                                <td><input type="text" name="itemName[]" class="form-control form-control-sm bg-light border-0 fin-item" placeholder="Item" required></td>
                                                                <td><input type="number" name="quantity[]" min="1" class="form-control form-control-sm bg-light border-0 text-center fin-qty" value="1" oninput="calculateRowTotal(this)"></td>
                                                                <td><input type="number" name="unitPrice[]" min="0" step="0.01" class="form-control form-control-sm bg-light border-0 text-center fin-price" value="0.00" oninput="calculateRowTotal(this)"></td>
                                                                <td><input type="text" name="totalPrice[]" class="form-control form-control-sm border-0 text-end fw-bold fin-total" value="0.00" readonly></td>
                                                                <td class="text-center"><button type="button" class="btn btn-sm text-danger" onclick="removeRow(this); calculateGrandTotal()"><i class="fas fa-trash"></i></button></td>
                                                            </tr>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                                <tfoot class="border-top">
                                                    <tr>
                                                        <td colspan="3" class="text-end fw-bold pt-3">GRAND TOTAL (RM):</td>
                                                        <td class="text-end fw-bold pt-3 fs-5 text-primary" id="grand-total-display">0.00</td>
                                                        <td></td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                            <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addFinancialRow()"><i class="fas fa-plus me-1"></i> Add Item</button>
                                        </div>
                                    </div>
                                </div>
                                <input type="hidden" name="aiSummaryText" id="hiddenAiSummary" value=""><!-- comment -->

                                <div class="d-flex justify-content-end gap-3 mt-5 border-top pt-4">
                                    <button type="submit" name="actionType" value="draft" class="btn btn-outline-secondary fw-bold px-4 py-2 rounded-pill">
                                        <i class="fas fa-save me-1"></i> ${isEditMode ? 'Update Draft' : 'Save as Draft'}
                                    </button>
                                    <button type="submit" name="actionType" value="submit" class="btn btn-primary fw-bold px-5 py-2 rounded-pill shadow-sm">
                                        <i class="fas fa-paper-plane me-1"></i> Submit Proposal
                                    </button>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

                <%-- RIGHT SIDE: THE AI DRAWER WITH THE ID NEEDED FOR JAVASCRIPT --%>
                <div class="col-lg-4">
                    <div id="aiDrawerContainer">
                        <div class="offcanvas-lg offcanvas-end bg-transparent border-0 w-100" tabindex="-1" id="aiOffcanvas" aria-labelledby="aiOffcanvasLabel">
                            <div class="offcanvas-header bg-white shadow-sm d-lg-none rounded-bottom mb-3 mx-2 mt-2">
                                <h5 class="offcanvas-title fw-bold text-primary" id="aiOffcanvasLabel">
                                    <i class="fas fa-robot me-2"></i>AI Assessment Drawer
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" data-bs-target="#aiOffcanvas" aria-label="Close"></button>
                            </div>

                            <div class="offcanvas-body p-0 p-lg-0 px-2 px-lg-0">
                                <div class="w-100">
                                    <div class="card border-1 border-primary shadow rounded-4" style="background-color: #fcfdff;">
                                        <div class="card-body p-4">
                                            <div class="d-flex align-items-center mb-3 border-bottom pb-3">
                                                <div class="bg-primary text-white rounded-3 p-3 me-3 shadow-sm transition-all" id="ai-icon-container" style="transition: 0.3s ease;">
                                                    <i class="fas fa-microchip fa-2x"></i>
                                                </div>
                                                <div>
                                                    <h5 class="fw-bold mb-0 text-primary d-flex align-items-center">
                                                        Heuristic AI
                                                        <span class="badge bg-danger ms-2 shadow-sm" style="font-size: 0.6rem; animation: pulse 2s infinite;">LIVE</span>
                                                    </h5>
                                                    <small class="text-muted">Real-time WSM Engine</small>
                                                </div>
                                            </div>

                                            <div id="ai-realtime-result" class="mt-3">
                                                <!--                                                <div class="text-center p-4">
                                                                                                    <i class="fas fa-keyboard fa-3x text-light mb-3"></i>
                                                                                                    <p class='text-muted small mb-0'>Please fill in the <b>Date, Duration, Participants,</b> and <b>Budget</b> in the form to start the smart analysis.</p>
                                                                                                </div>-->
                                                <!-- Put this inside your card-body right above the ai-realtime-result container -->
                                                <button type="button" id="btnForceAI" class="btn btn-primary w-100 mb-3 rounded-pill fw-bold shadow-sm">
                                                    <i class="fas fa-wand-magic-sparkles me-2"></i> Run AI Assessment
                                                </button>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div> 
        </div>

        <button class="btn btn-primary shadow-lg d-lg-none fab-btn text-white" type="button" data-bs-toggle="offcanvas" data-bs-target="#aiOffcanvas" aria-controls="aiOffcanvas" id="fabAiBtn">
            <i class="fas fa-robot fa-2x"></i>
            <span class="position-absolute top-0 start-100 translate-middle p-2 bg-danger border border-light rounded-circle" style="animation: pulse 2s infinite;"></span>
        </button>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                // ==========================================
                                                // THE JAVASCRIPT "FOLLOWER" ENGINE
                                                // ==========================================
                                                $(window).on('scroll', function () {
                                                    if ($(window).width() > 991) {
                                                        var scrollPos = $(window).scrollTop();
                                                        var offsetTop = 100;
                                                        if (scrollPos > offsetTop) {
                                                            $('#aiDrawerContainer').css({'margin-top': (scrollPos - offsetTop) + 'px'});
                                                        } else {
                                                            $('#aiDrawerContainer').css({'margin-top': '0px'});
                                                        }
                                                    } else {
                                                        $('#aiDrawerContainer').css({'margin-top': '0px'});
                                                    }
                                                });

                                                // ==========================================
                                                // 1. DYNAMIC CALCULATIONS (DATES & PAX)
                                                // ==========================================
                                                function calculateDuration() {
                                                    const start = new Date(document.getElementById('startDate').value);
                                                    const end = new Date(document.getElementById('endDate').value);
                                                    if (start && end && !isNaN(start) && !isNaN(end)) {
                                                        const diffTime = end - start;
                                                        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
                                                        if (diffDays > 0) {
                                                            const durInput = document.getElementById('durationInput');
                                                            durInput.value = diffDays;
                                                            durInput.dispatchEvent(new Event('input'));
                                                        }
                                                    }
                                                }
                                                document.getElementById('startDate').addEventListener('change', calculateDuration);
                                                document.getElementById('endDate').addEventListener('change', calculateDuration);

                                                function calcParticipants() {
                                                    const u = parseInt(document.getElementById('partUmt').value) || 0;
                                                    const s = parseInt(document.getElementById('partStaff').value) || 0;
                                                    const p = parseInt(document.getElementById('partPublic').value) || 0;
                                                    const totalPart = document.getElementById('totalPart');
                                                    totalPart.value = u + s + p;
                                                    totalPart.dispatchEvent(new Event('input'));

                                                }
                                                document.getElementById('partUmt').addEventListener('input', calcParticipants);
                                                document.getElementById('partStaff').addEventListener('input', calcParticipants);
                                                document.getElementById('partPublic').addEventListener('input', calcParticipants);

                                                // ==========================================
                                                // 2. DYNAMIC SDG REASON BOXES
                                                // ==========================================
                                                function toggleSdgReason(cb) {
                                                    const container = document.getElementById('sdg-reasons-container');
                                                    const sdgId = cb.getAttribute('data-sdg');
                                                    const sdgTitle = cb.value;

                                                    if (cb.checked) {
                                                        const div = document.createElement('div');
                                                        div.className = 'mb-3 sdg-reason-block p-3 bg-primary bg-opacity-10 border border-primary border-opacity-25 rounded-3 fade-in-up';
                                                        div.id = 'reason-block-' + sdgId;
                                                        div.innerHTML = '<label class="form-label small fw-bold text-primary"><i class="fas fa-bullseye me-1"></i>' + sdgTitle + '</label>' +
                                                                '<textarea class="form-control bg-white border-0 shadow-sm sdg-reason-input" data-id="' + sdgId + '" data-title="' + sdgTitle + '" rows="2" placeholder="Explain how your event impacts ' + sdgTitle + '..." required></textarea>';
                                                        container.appendChild(div);
                                                    } else {
                                                        const div = document.getElementById('reason-block-' + sdgId);
                                                        if (div)
                                                            div.remove();
                                                    }
                                                }

                                                // ==========================================
                                                // 3. AI ASSESSMENT ENGINE (WITH GPT INTEGRATION)
                                                // ==========================================
                                                document.addEventListener("DOMContentLoaded", function () {
                                                    const titleInput = document.querySelector('input[name="title"]');
                                                    const dateInput = document.getElementById('startDate');
                                                    const durationInput = document.getElementById('durationInput');
                                                    const paxInput = document.getElementById('totalPart');
                                                    const budgetInput = document.getElementById('mainBudgetInput');
                                                    // Replace the old single sponsorInput line with these:
                                                    const yuranInput = document.querySelector('input[name="budgetYuran"]');
                                                    const ptjInput = document.querySelector('input[name="budgetPtj"]');
                                                    const luarInput = document.querySelector('input[name="budgetLuar"]');

                                                    const resultDiv = document.getElementById("ai-realtime-result");
                                                    const iconContainer = document.getElementById("ai-icon-container");
                                                    const fabBtn = document.getElementById("fabAiBtn");
                                                    let isRiskyProposal = false;

                                                    let aiDebounceTimer; // Global timer reference to manage rate limits

                                                    function triggerAI() {
                                                        // 1. Clear any pending API requests from the previous keystroke immediately
                                                        clearTimeout(aiDebounceTimer);

                                                        // 2. Fetch input element objects safely
                                                        const titleInput = document.querySelector('input[name="title"]');
                                                        const dateInput = document.getElementById('startDate');
                                                        const durationInput = document.getElementById('durationInput');
                                                        const paxInput = document.getElementById('totalPart');
                                                        const budgetInput = document.getElementById('mainBudgetInput');
                                                        const resultDiv = document.getElementById("ai-realtime-result");
                                                        const iconContainer = document.getElementById("ai-icon-container");
                                                        const fabBtn = document.getElementById("fabAiBtn");

                                                        // Fetch the new exhibition action button element
                                                        const forceAiBtn = document.getElementById('btnForceAI');

                                                        // 3. FIX BUG 1: Merge multi-source budget inputs into a dynamic text format
                                                        const yuranInput = document.querySelector('input[name="budgetYuran"]');
                                                        const ptjInput = document.querySelector('input[name="budgetPtj"]');
                                                        const luarInput = document.querySelector('input[name="budgetLuar"]');

                                                        let sponsorText = "";
                                                        if (parseFloat(yuranInput?.value) > 0)
                                                            sponsorText += "yuran ";
                                                        if (parseFloat(ptjInput?.value) > 0)
                                                            sponsorText += "sumbangan ptj ";
                                                        if (parseFloat(luarInput?.value) > 0)
                                                            sponsorText += "tajaan luar sponsor ";

                                                        // 4. Gather string values and sanitize URI characters
                                                        const title = titleInput ? encodeURIComponent(titleInput.value) : 'Untitled Program';
                                                        const date = dateInput ? dateInput.value : '';
                                                        const duration = durationInput ? durationInput.value : '';
                                                        const pax = paxInput ? paxInput.value : '0';
                                                        const budget = budgetInput ? budgetInput.value : '0.00';
                                                        const sponsor = encodeURIComponent(sponsorText.trim());

                                                        const isFundedChecked = document.querySelector('input[name="isClubFunded"]:checked');
                                                        const isClubFunded = isFundedChecked ? isFundedChecked.value : 'true';

                                                        // 5. FIX BUG 2: Sanitize values to prevent early loop freezing on initial 0 states
                                                        const parsedPax = parseInt(pax, 10) || 0;
                                                        const parsedBudget = parseFloat(budget) || 0;

                                                        if (date && duration && parsedPax >= 0 && parsedBudget > 0) {

                                                            // ==========================================
                                                            // 📍 LOCATION FOR DYNAMIC UI: START LOADING STATE
                                                            // ==========================================
                                                            if (forceAiBtn) {
                                                                forceAiBtn.disabled = true;
                                                                forceAiBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Processing...';
                                                            }

                                                            resultDiv.innerHTML = '<div class="d-flex align-items-center py-4">' +
                                                                    '<div class="spinner-border text-primary me-3" role="status"></div>' +
                                                                    '<div><span class="text-primary fw-bold d-block">AI is compiling insights...</span>' +
                                                                    '<small class="text-muted">Analyzing layout specifications...</small></div></div>';

                                                            iconContainer.className = "bg-warning text-dark rounded-3 p-3 me-3 shadow-sm";
                                                            if (fabBtn)
                                                                fabBtn.classList.add("bg-warning", "text-dark", "border-warning");

                                                            // 7. Controlled Request Queueing: Fire request
                                                            aiDebounceTimer = setTimeout(() => {
                                                                fetch('${pageContext.request.contextPath}/AIEngineAPI?title=' + title + '&date=' + date +
                                                                        '&duration=' + duration + '&pax=' + pax + '&budget=' + budget + '&budgetDetails=' + sponsor +
                                                                        '&isClubFunded=' + isClubFunded)
                                                                        .then(response => response.text())
                                                                        .then(data => {
                                                                            // Display processed output data
                                                                            resultDiv.innerHTML = data;

                                                                            // Track risk evaluation state for submission blocker system
                                                                            isRiskyProposal = data.includes("BERISIKO") || data.includes("TIDAK DIGALAKKAN") || data.includes("RISKY");

                                                                            // Reset loading container icon highlights back to active defaults
                                                                            iconContainer.className = "bg-primary text-white rounded-3 p-3 me-3 shadow-sm";
                                                                            if (fabBtn) {
                                                                                fabBtn.classList.remove("bg-warning", "text-dark", "border-warning");
                                                                                fabBtn.classList.add("bg-primary", "text-white");
                                                                            }

                                                                            // ==========================================
                                                                            // 📍 LOCATION FOR DYNAMIC UI: RESET SUCCESS STATE
                                                                            // ==========================================
                                                                            if (forceAiBtn) {
                                                                                forceAiBtn.disabled = false;
                                                                                forceAiBtn.innerHTML = '<i class="fas fa-wand-magic-sparkles me-2"></i> Run AI Assessment';
                                                                            }
                                                                        })
                                                                        .catch(error => {
                                                                            console.error("AI Thread error:", error);
                                                                            resultDiv.innerHTML = '<div class="alert alert-danger"><i class="fas fa-wifi me-2"></i>Network latency detected. Retrying...</div>';
                                                                            iconContainer.className = "bg-danger text-white rounded-3 p-3 me-3 shadow-sm";

                                                                            // ==========================================
                                                                            // 📍 LOCATION FOR DYNAMIC UI: RESET ERROR STATE
                                                                            // ==========================================
                                                                            if (forceAiBtn) {
                                                                                forceAiBtn.disabled = false;
                                                                                forceAiBtn.innerHTML = '<i class="fas fa-wand-magic-sparkles me-2"></i> Run AI Assessment';
                                                                            }
                                                                        });
                                                            }, 500); // 500ms slight buffer to ensure DOM finishes registering values
                                                        } else {
                                                            // Validation fallback warning inside the drawer if button clicked with an incomplete form
                                                            resultDiv.innerHTML = '<div class="alert alert-warning border-0 small shadow-sm">' +
                                                                    '<i class="fas fa-exclamation-circle me-2"></i><b>Missing Information:</b> Please fill out the <b>Start Date, End Date, Participants</b> and add items to the <b>Financial Table</b> before running the assessment.</div>';
                                                        }
                                                    }



//                                                    if (titleInput)
//                                                        titleInput.addEventListener("input", triggerAI);
//
//                                                    if (dateInput && durationInput && paxInput && budgetInput) {
//                                                        dateInput.addEventListener("change", triggerAI);
//                                                        durationInput.addEventListener("input", triggerAI);
//                                                        paxInput.addEventListener("input", triggerAI);
//                                                        budgetInput.addEventListener("change", triggerAI);
//
//                                                        if (sponsorInput)
//                                                            sponsorInput.addEventListener("input", triggerAI);
//
//                                                        document.querySelectorAll('.club-fund-radio').forEach(radio => {
//                                                            radio.addEventListener("change", triggerAI);
//                                                        });
//                                                    }
                                                    // THIS CLICK EVENT LISTENER FOR YOUR EXHIBITION BUTTON:
                                                    const forceAiBtn = document.getElementById('btnForceAI');
                                                    if (forceAiBtn) {
                                                        forceAiBtn.addEventListener('click', function () {
                                                            // Force an immediate execution bypassing any input debounce delays
                                                            triggerAI();
                                                        });
                                                    }


                                                    const submitBtn = document.querySelector('button[value="submit"]');
                                                    if (submitBtn) {
                                                        submitBtn.addEventListener('click', function (e) {
                                                            if (isRiskyProposal) {
                                                                if (!confirm("⚠️ SMART SYSTEM WARNING (AI):\n\nYour proposal is found to be HIGH RISK based on budget, logistics, or university calendar analysis.\n\nThe probability of this proposal being REJECTED by reviewers is very high.\n\nAre you sure you want to proceed with the submission?")) {
                                                                    e.preventDefault();
                                                                }
                                                            }
                                                        });
                                                    }
                                                });

                                                // ==========================================
                                                // 4. DYNAMIC TABLE BUILDER
                                                // ==========================================
                                                function generateTentativeDays(days) {
                                                    const container = document.getElementById('tentative-container');
                                                    if (isNaN(days) || days < 1)
                                                        return;
                                                    let html = '';
                                                    for (let i = 1; i <= days; i++) {
                                                        html += '<div class="mb-3 tentative-day-block" data-day="' + i + '">' +
                                                                '<h6 class="fw-bold text-primary border-bottom pb-1">DAY ' + i + '</h6>' +
                                                                '<table class="table table-sm table-borderless tentative-table"><tbody class="tentative-body">' +
                                                                '<tr><td width="25%"><input type="hidden" name="day[]" value="DAY ' + i + '"><input type="time" name="time[]" class="form-control form-control-sm bg-light border-0 ten-time"></td>' +
                                                                '<td width="65%"><input type="text" name="activity[]" class="form-control form-control-sm bg-light border-0 ten-act" placeholder="Activity"></td>' +
                                                                '<td width="10%" class="text-center"><button type="button" class="btn btn-sm text-danger" onclick="removeRow(this)"><i class="fas fa-times"></i></button></td></tr>' +
                                                                '</tbody></table><button type="button" class="btn btn-sm btn-link add-time-btn" onclick="addTentativeRow(this)"><i class="fas fa-plus"></i> Add Time Slot</button></div>';
                                                    }
                                                    container.innerHTML = html;
                                                }

                                                document.getElementById('durationInput').addEventListener('input', function () {
                                                    generateTentativeDays(parseInt(this.value));
                                                });

                                                function addTentativeRow(btn, time = '', act = '') {
                                                    const dayBlock = btn.closest('.tentative-day-block');
                                                    const dayNum = dayBlock ? dayBlock.getAttribute('data-day') : '';
                                                    const dayStr = dayNum ? 'DAY ' + dayNum : '';

                                                    const tbody = btn.previousElementSibling.querySelector('.tentative-body');
                                                    const tr = document.createElement('tr');
                                                    tr.innerHTML = '<td width="25%"><input type="hidden" name="day[]" value="' + dayStr + '"><input type="time" name="time[]" class="form-control form-control-sm bg-light border-0 ten-time" value="' + time + '"></td>' +
                                                            '<td width="65%"><input type="text" name="activity[]" class="form-control form-control-sm bg-light border-0 ten-act" placeholder="Activity" value="' + act + '"></td>' +
                                                            '<td width="10%" class="text-center"><button type="button" class="btn btn-sm text-danger" onclick="removeRow(this)"><i class="fas fa-times"></i></button></td>';
                                                    tbody.appendChild(tr);
                                                }

                                                function addCommitteeRow(matrik = '', nama = '', role = '') {
                                                    const tbody = document.getElementById('committee-body');
                                                    const tr = document.createElement('tr');
                                                    tr.innerHTML = '<td><input type="text" name="matricNo[]" class="form-control form-control-sm bg-light border-0 comm-matrik" placeholder="S12345" value="' + matrik + '"></td>' +
                                                            '<td><input type="text" name="commName[]" class="form-control form-control-sm bg-light border-0 comm-nama" placeholder="Member Name" value="' + nama + '"></td>' +
                                                            '<td><input type="text" name="role[]" class="form-control form-control-sm bg-light border-0 comm-role" placeholder="Role" value="' + role + '"></td>' +
                                                            '<td class="text-center"><button type="button" class="btn btn-sm text-danger" onclick="removeRow(this)"><i class="fas fa-trash"></i></button></td>';
                                                    tbody.appendChild(tr);
                                                }

                                                function addFinancialRow(item = '', qty = 1, price = 0.00, total = 0.00) {
                                                    const tbody = document.getElementById('financial-body');
                                                    const tr = document.createElement('tr');
                                                    tr.innerHTML = '<td><input type="text" name="itemName[]" class="form-control form-control-sm bg-light border-0 fin-item" placeholder="Item" value="' + item + '"></td>' +
                                                            '<td><input type="number" name="quantity[]" min="1" class="form-control form-control-sm bg-light border-0 text-center fin-qty" value="' + qty + '" oninput="calculateRowTotal(this)"></td>' +
                                                            '<td><input type="number" name="unitPrice[]" min="0" step="0.01" class="form-control form-control-sm bg-light border-0 text-center fin-price" value="' + parseFloat(price).toFixed(2) + '" oninput="calculateRowTotal(this)"></td>' +
                                                            '<td><input type="text" name="totalPrice[]" class="form-control form-control-sm border-0 text-end fw-bold fin-total" value="' + parseFloat(total).toFixed(2) + '" readonly></td>' +
                                                            '<td class="text-center"><button type="button" class="btn btn-sm text-danger" onclick="removeRow(this); calculateGrandTotal()"><i class="fas fa-trash"></i></button></td>';
                                                    tbody.appendChild(tr);
                                                }

                                                function removeRow(btn) {
                                                    btn.closest('tr').remove();
                                                    calculateGrandTotal();
                                                }

                                                function calculateRowTotal(input) {
                                                    const row = input.closest('tr');
                                                    const qty = parseFloat(row.querySelector('.fin-qty').value) || 0;
                                                    const price = parseFloat(row.querySelector('.fin-price').value) || 0;
                                                    row.querySelector('.fin-total').value = (qty * price).toFixed(2);
                                                    calculateGrandTotal();
                                                }

                                                function calculateGrandTotal() {
                                                    let grandTotal = 0;
                                                    document.querySelectorAll('.fin-total').forEach(input => grandTotal += parseFloat(input.value) || 0);
                                                    document.getElementById('grand-total-display').innerText = grandTotal.toFixed(2);
                                                    const mainBudgetInput = document.getElementById('mainBudgetInput');
                                                    if (mainBudgetInput) {
                                                        mainBudgetInput.value = grandTotal.toFixed(2);
                                                        mainBudgetInput.dispatchEvent(new Event('change'));
                                                    }
                                                }

                                                // ==========================================
                                                // 5. DATA COMPILER TO SEND TO DB
                                                // ==========================================
                                                document.getElementById('proposalForm').addEventListener('submit', function (event) {
                                                    let sdgImpacts = [];
                                                    let sdgReasons = [];
                                                    document.querySelectorAll('.sdg-checkbox:checked').forEach(cb => {
                                                        sdgImpacts.push(cb.value);
                                                        const sdgId = cb.getAttribute('data-sdg');
                                                        const reasonBox = document.querySelector('.sdg-reason-input[data-id="' + sdgId + '"]');
                                                        if (reasonBox) {
                                                            sdgReasons.push(cb.value + " ^ " + reasonBox.value.trim());
                                                        }
                                                    });
                                                    if (sdgImpacts.length === 0) {
                                                        alert("Please select at least one SDG for your event.");
                                                        event.preventDefault();
                                                        return false;
                                                    }
                                                    document.getElementById('hiddenSdgImpact').value = sdgImpacts.join(" | ");
                                                    document.getElementById('hiddenSdgReason').value = sdgReasons.join(" ||| ");
                                                });

                                                // ==========================================
                                                // 6. EDIT DRAFT AUTO-POPULATOR
                                                // ==========================================
                                                document.addEventListener("DOMContentLoaded", function () {
                                                    const hiddenTentative = document.getElementById('hiddenTentative').value;
                                                    const savedSdgImpact = document.getElementById('hiddenSdgImpact').value;
                                                    const savedSdgReason = document.getElementById('hiddenSdgReason').value;
                                                    const lineSplitRegex = /\\n|[\r\n]+/;
                                                    const durationVal = document.getElementById('durationInput').value;

                                                    if (durationVal > 0)
                                                        generateTentativeDays(parseInt(durationVal));

                                                    if (savedSdgImpact && savedSdgImpact.trim() !== "") {
                                                        const impacts = savedSdgImpact.split(" | ");
                                                        impacts.forEach(impact => {
                                                            const cb = document.querySelector('.sdg-checkbox[value="' + impact.trim() + '"]');
                                                            if (cb) {
                                                                cb.checked = true;
                                                                toggleSdgReason(cb);
                                                            }
                                                        });
                                                        if (savedSdgReason && savedSdgReason.trim() !== "") {
                                                            const reasons = savedSdgReason.split(" ||| ");
                                                            reasons.forEach(reasonCombo => {
                                                                const parts = reasonCombo.split(" ^ ");
                                                                if (parts.length >= 2) {
                                                                    const title = parts[0].trim();
                                                                    const text = parts.slice(1).join(" ^ ").trim();
                                                                    const textarea = document.querySelector('.sdg-reason-input[data-title="' + title + '"]');
                                                                    if (textarea)
                                                                        textarea.value = text;
                                                                }
                                                            });
                                                        }
                                                    }

                                                    if (hiddenTentative.includes("|")) {
                                                        const lines = hiddenTentative.split(lineSplitRegex);
                                                        document.querySelectorAll('.tentative-body').forEach(tbody => tbody.innerHTML = '');
                                                        lines.forEach(line => {
                                                            const cols = line.trim().split("|");
                                                            if (cols.length >= 3) {
                                                                const dayNum = parseInt(cols[0].replace(/\D/g, ""));
                                                                const dayBlock = document.querySelector('.tentative-day-block[data-day="' + dayNum + '"]');
                                                                if (dayBlock) {
                                                                    const btn = dayBlock.querySelector('button.add-time-btn');
                                                                    if (btn)
                                                                        addTentativeRow(btn, cols[1], cols[2]);
                                                                }
                                                            }
                                                        });
                                                    }

                                                    setTimeout(() => {
                                                        calculateGrandTotal();
                                                    }, 200);


                                                });
        </script>
    </body>
</html>