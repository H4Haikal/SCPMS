<%-- 
    Document   : ClubMembers.jsp
    Created on : 19 Jan 2026
    Author     : Haikal Danial
    Purpose    : Manage Club Members with Access Control
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Roster | SCPMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

            .avatar-circle {
                width: 45px;
                height: 45px;
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 16px;
                letter-spacing: 1px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }

            .member-row {
                transition: all 0.2s ease;
                border-bottom: 1px solid #f8f9fa;
            }
            .member-row:hover {
                background-color: #f8fafc;
                transform: translateX(4px);
            }
            .member-row:last-child {
                border-bottom: none;
            }

            .search-box {
                position: relative;
            }
            .search-box i {
                position: absolute;
                left: 18px;
                top: 50%;
                transform: translateY(-50%);
                color: #94a3b8;
            }
            .search-box input {
                padding-left: 45px;
                border-radius: 50px;
                background: #f1f5f9;
                border: none;
                padding-top: 12px;
                padding-bottom: 12px;
            }
            .search-box input:focus {
                background: #fff;
                box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
                border-color: #4b0082;
            }

            /* --- ROLE BADGES --- */
            .role-badge {
                font-weight: 600;
                padding: 6px 12px;
                border-radius: 50px;
                letter-spacing: 0.5px;
                font-size: 0.75rem;
                text-transform: uppercase;
            }
            .role-pres {
                background: #f5f3ff;
                color: #7c3aed;
                border: 1px solid #ddd6fe;
            }
            .role-vp {
                background: #eff6ff;
                color: #2563eb;
                border: 1px solid #bfdbfe;
            }
            .role-secr {
                background: #f0fdfa;
                color: #0d9488;
                border: 1px solid #ccfbf1;
            }
            .role-treas {
                background: #fffbeb;
                color: #d97706;
                border: 1px solid #fef3c7;
            }
            .role-comm {
                background: #f0fdf4;
                color: #16a34a;
                border: 1px solid #bbf7d0;
            }
            .role-mem {
                background: #f8fafc;
                color: #64748b;
                border: 1px solid #e2e8f0;
            }

            .filter-pill {
                border-radius: 50px;
                padding: 8px 20px;
                font-weight: 600;
                color: #64748b;
                background: white;
                border: 1px solid #e2e8f0;
                transition: 0.2s;
                cursor: pointer;
            }
            .filter-pill:hover, .filter-pill.active {
                background: #4b0082;
                color: white;
                border-color: #4b0082;
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <%-- TOP HEADER --%>
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle"><i class="fas fa-bars fa-lg"></i></button>
                    <div>
                        <h3 class="fw-bold text-dark mb-0">Club Roster</h3>
                        <p class="text-muted small mb-0"><i class="fas fa-users me-1"></i> ${clubName} Organization Structure</p>
                    </div>
                </div>
                <div>
                    <button type="button" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#addMemberModal">
                        <i class="fas fa-user-plus me-2"></i> Add Member
                    </button>
                </div>
            </div>

            <%-- ALERTS --%>
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible shadow-sm rounded-4 border-0 mb-4"><i class="fas fa-check-circle me-2"></i> ${message}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                </c:if>
                <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible shadow-sm rounded-4 border-0 mb-4"><i class="fas fa-exclamation-triangle me-2"></i> ${error}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
                </c:if>

            <%-- BENTO ROSTER CONTAINER --%>
            <div class="bento-card">
                <div class="p-4 border-bottom bg-white d-flex flex-wrap justify-content-between align-items-center gap-3">

                    <%-- FILTERS --%>
                    <div class="d-flex gap-2">
                        <div class="filter-pill active" onclick="filterRole('All', this)">All (${fn:length(members)})</div>
                        <div class="filter-pill" onclick="filterRole('Core', this)">Core Board</div>
                        <div class="filter-pill" onclick="filterRole('Committee', this)">Committee</div>
                        <div class="filter-pill" onclick="filterRole('Member', this)">General Members</div>
                    </div>

                    <%-- SEARCH --%>
                    <div class="search-box" style="width: 300px;">
                        <i class="fas fa-search"></i>
                        <input type="text" id="memberSearch" class="form-control" placeholder="Search roster..." onkeyup="searchTable()">
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table align-middle mb-0" id="membersTable">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4 py-3 text-muted small text-uppercase border-0">Identity</th>
                                <th class="text-muted small text-uppercase border-0">Role</th>
                                <th class="text-muted small text-uppercase border-0">Contact</th>
                                <th class="text-muted small text-uppercase border-0">Joined</th>
                                <th class="text-end pe-4 text-muted small text-uppercase border-0">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${members}">
                                <tr class="member-row" data-role="${m.position}">
                                    <td class="ps-4 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-circle text-white me-3" data-name="${m.fullName}"></div>
                                            <div>
                                                <div class="fw-bold text-dark">${m.fullName}</div>
                                                <div class="small text-muted"><i class="fas fa-id-card me-1 opacity-50"></i>${m.userId}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${m.position == 'Pres'}"><span class="role-badge role-pres">President</span></c:when>
                                            <c:when test="${m.position == 'Vice Pres'}"><span class="role-badge role-vp">Vice President</span></c:when>
                                            <c:when test="${m.position == 'Secr'}"><span class="role-badge role-secr">Secretary</span></c:when>
                                            <c:when test="${m.position == 'Treas'}"><span class="role-badge role-treas">Treasurer</span></c:when>
                                            <c:when test="${m.position == 'Committee'}"><span class="role-badge role-comm">Committee</span></c:when>
                                            <c:otherwise><span class="role-badge role-mem">Member</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="mailto:${m.email}" class="btn btn-sm btn-light text-secondary rounded-circle" title="Email"><i class="fas fa-envelope"></i></a>
                                                <c:if test="${not empty m.phone}">
                                                <a href="https://wa.me/6${m.phone}" target="_blank" class="btn btn-sm btn-light text-success rounded-circle" title="WhatsApp"><i class="fab fa-whatsapp"></i></a>
                                                </c:if>
                                        </div>
                                    </td>
                                    <td><span class="text-muted small fw-bold">${m.joinedDate}</span></td>
                                    <td class="text-end pe-4">
                                        <div class="d-flex justify-content-end gap-2">
                                            <button type="button" class="btn btn-sm btn-light text-primary rounded-circle" 
                                                    onclick="openEditModal('${m.userId}', '${m.fullName}', '${m.phone}', '${m.position}', '${m.email}')">
                                                <i class="fas fa-pen"></i>
                                            </button>
                                            <form action="${pageContext.request.contextPath}/chc/members" method="post" onsubmit="return confirm('Remove ${m.fullName} from the roster?');">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="userId" value="${m.userId}">
                                                <button type="submit" class="btn btn-sm btn-light text-danger rounded-circle"><i class="fas fa-trash-alt"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div> 

        <%-- ADD MEMBER MODAL --%>
        <div class="modal fade" id="addMemberModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-white border-bottom-0 pt-4 pb-0 px-4">
                        <h4 class="modal-title fw-bold text-dark"><i class="fas fa-user-plus text-primary me-2"></i> Add to Roster</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/chc/members" method="post">
                        <div class="modal-body p-4">
                            <input type="hidden" name="action" value="add">

                            <div class="mb-3">
                                <label class="form-label fw-bold small text-muted text-uppercase">Student ID</label>
                                <input type="text" name="userId" class="form-control bg-light" placeholder="e.g. S54321" required>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold small text-muted text-uppercase">Full Name</label>
                                <input type="text" name="fullName" class="form-control bg-light" placeholder="Legal Name" required>
                            </div>

                            <div class="p-3 bg-light rounded-4 mb-3 border">
                                <label class="form-label fw-bold small text-dark text-uppercase mb-2">System Role</label>
                                <select name="position" id="addRoleSelect" class="form-select shadow-sm border-0" onchange="toggleEmailField()">
                                    <option value="Member" selected>General Member</option>
                                    <option value="Committee">Committee Member</option>
                                    <option value="Secr">Secretary</option>
                                    <option value="Treas">Treasurer</option>
                                    <option value="Vice Pres">Vice President</option>
                                </select>

                                <%-- DYNAMIC ACCESS ALERTS --%>
                                <div id="rosterOnlyAlert" class="mt-3 text-muted small fw-bold">
                                    <i class="fas fa-info-circle text-secondary me-1"></i> Roster only. No system account will be generated.
                                </div>
                                <div id="systemAccessAlert" class="mt-3 text-primary small fw-bold" style="display: none;">
                                    <i class="fas fa-shield-alt me-1"></i> Core Board detected. System login will be generated.
                                </div>
                            </div>

                            <div class="mb-2" id="addEmailDiv" style="display:none;">
                                <label class="form-label fw-bold small text-muted text-uppercase">Login Email Address</label>
                                <input type="email" name="email" id="addEmailInput" class="form-control" placeholder="user@ocean.umt.edu.my">
                            </div>
                        </div>
                        <div class="modal-footer bg-white border-0 px-4 pb-4 pt-0 d-flex justify-content-between">
                            <button type="button" class="btn btn-light rounded-pill px-4 fw-bold text-muted" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">Save to Roster</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%-- EDIT MEMBER MODAL (Kept logic intact, updated styling) --%>
        <div class="modal fade" id="editMemberModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header bg-white border-bottom-0 pt-4 pb-0 px-4">
                        <h4 class="modal-title fw-bold text-dark"><i class="fas fa-pen text-primary me-2"></i> Update Details</h4>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/chc/members" method="post">
                        <div class="modal-body p-4">
                            <input type="hidden" name="action" value="edit">
                            <div class="mb-3">
                                <label class="form-label text-muted small fw-bold text-uppercase">Student ID</label>
                                <input type="text" name="userId" id="editUserId" class="form-control bg-light" readonly>
                            </div>
                            <div class="row g-3 mb-3">
                                <div class="col-md-7">
                                    <label class="form-label fw-bold small text-muted text-uppercase">Full Name</label>
                                    <input type="text" name="fullName" id="editFullName" class="form-control" required>
                                </div>
                                <div class="col-md-5">
                                    <label class="form-label fw-bold small text-muted text-uppercase">Phone</label>
                                    <input type="text" name="phone" id="editPhone" class="form-control">
                                </div>
                            </div>

                            <div class="p-3 bg-light rounded-4 mb-3 border">
                                <label class="form-label fw-bold small text-dark text-uppercase">Position / Role</label>
                                <c:choose>
                                    <c:when test="${sessionScope.userPosition == 'Pres'}">
                                        <input type="hidden" name="position" id="editPositionHidden">
                                        <select id="editPosition" class="form-select border-0 shadow-sm" onchange="document.getElementById('editPositionHidden').value = this.value;">
                                            <option value="Pres">President</option>
                                            <option value="Member">Member</option>
                                            <option value="Committee">Committee Member</option>
                                            <option value="Secr">Secretary</option>
                                            <option value="Treas">Treasurer</option>
                                            <option value="Vice Pres">Vice President</option>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="text" id="editPositionDisplay" class="form-control border-0" readonly>
                                        <input type="hidden" name="position" id="editPosition"> 
                                        <div class="form-text text-danger small mt-2"><i class="fas fa-lock me-1"></i> Role modifications restricted to President.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="mb-2" id="editEmailDiv">
                                <label class="form-label fw-bold small text-muted text-uppercase">Personal Email</label>
                                <input type="email" name="email" id="editEmailInput" class="form-control">
                                <div id="emailLockMessage" class="form-text text-danger small mt-2" style="display:none;"><i class="fas fa-lock me-1"></i> You can only edit your own system email.</div>
                            </div>
                        </div>
                        <div class="modal-footer bg-white border-0 px-4 pb-4 pt-0 d-flex justify-content-between">
                            <button type="button" class="btn btn-light rounded-pill px-4 fw-bold text-muted" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                            document.addEventListener("DOMContentLoaded", function () {
                                                // Generate Aesthetic Avatars
                                                const avatars = document.querySelectorAll('.avatar-circle');
                                                const colors = ['#6366f1', '#10b981', '#f59e0b', '#ec4899', '#8b5cf6', '#0ea5e9'];
                                                avatars.forEach((avatar) => {
                                                    const name = avatar.getAttribute('data-name') || "User";
                                                    const initials = name.match(/(\b\S)?/g).join("").match(/(^\S|\S$)?/g).join("").toUpperCase();

                                                    // Simple hash to consistently assign colors based on name
                                                    let hash = 0;
                                                    for (let i = 0; i < name.length; i++) {
                                                        hash = name.charCodeAt(i) + ((hash << 5) - hash);
                                                    }
                                                    const colorIndex = Math.abs(hash) % colors.length;

                                                    avatar.style.backgroundColor = colors[colorIndex];
                                                    avatar.innerText = initials.substring(0, 2);
                                                });
                                            });

                                            // Filter Pills Logic
                                            function filterRole(roleType, element) {
                                                // Update active pill styling
                                                document.querySelectorAll('.filter-pill').forEach(pill => pill.classList.remove('active'));
                                                element.classList.add('active');

                                                // Filter rows
                                                const rows = document.querySelectorAll('.member-row');
                                                rows.forEach(row => {
                                                    const pos = row.getAttribute('data-role');
                                                    if (roleType === 'All') {
                                                        row.style.display = '';
                                                    } else if (roleType === 'Core' && ['Pres', 'Vice Pres', 'Secr', 'Treas'].includes(pos)) {
                                                        row.style.display = '';
                                                    } else if (roleType === 'Committee' && pos === 'Committee') {
                                                        row.style.display = '';
                                                    } else if (roleType === 'Member' && pos === 'Member') {
                                                        row.style.display = '';
                                                    } else {
                                                        row.style.display = 'none';
                                                    }
                                                });
                                            }

                                            // Real-time Search
                                            function searchTable() {
                                                const input = document.getElementById("memberSearch").value.toUpperCase();
                                                const rows = document.querySelectorAll('.member-row');

                                                // Reset pills to All when searching manually
                                                document.querySelectorAll('.filter-pill').forEach(pill => pill.classList.remove('active'));
                                                document.querySelector('.filter-pill').classList.add('active');

                                                rows.forEach(row => {
                                                    const text = row.innerText.toUpperCase();
                                                    row.style.display = text.includes(input) ? '' : 'none';
                                                });
                                            }

                                            // Dynamic Form Toggle for Accounts vs Roster
                                            function toggleEmailField() {
                                                const role = document.getElementById("addRoleSelect").value;
                                                const emailDiv = document.getElementById("addEmailDiv");
                                                const emailInput = document.getElementById("addEmailInput");
                                                const rosterAlert = document.getElementById("rosterOnlyAlert");
                                                const systemAlert = document.getElementById("systemAccessAlert");

                                                if (['Secr', 'Treas', 'Vice Pres'].includes(role)) {
                                                    emailDiv.style.display = "block";
                                                    emailInput.required = true;
                                                    rosterAlert.style.display = "none";
                                                    systemAlert.style.display = "block";
                                                } else {
                                                    emailDiv.style.display = "none";
                                                    emailInput.required = false;
                                                    emailInput.value = "";
                                                    rosterAlert.style.display = "block";
                                                    systemAlert.style.display = "none";
                                                }
                                            }

                                            // Edit Modal Pre-fill Logic
                                            function openEditModal(id, name, phone, position, email) {
                                                document.getElementById('editUserId').value = id;
                                                document.getElementById('editFullName').value = name;
                                                document.getElementById('editPhone').value = phone || '';
                                                document.getElementById('editEmailInput').value = email || '';

                                                const currentUserId = '${sessionScope.user.userId}';
                                                const posSelect = document.getElementById('editPosition');
                                                const posDisplay = document.getElementById('editPositionDisplay');
                                                const posHidden = document.getElementById('editPositionHidden');

                                                if (posSelect) {
                                                    if (id === currentUserId) {
                                                        posSelect.value = position;
                                                        posSelect.disabled = true;
                                                        if (posHidden)
                                                            posHidden.value = position;
                                                    } else {
                                                        posSelect.value = position;
                                                        posSelect.disabled = false;
                                                        if (posHidden)
                                                            posHidden.value = position;
                                                    }
                                                } else if (posDisplay) {
                                                    document.getElementById('editPosition').value = position;
                                                    const map = {'Pres': 'President', 'Secr': 'Secretary', 'Treas': 'Treasurer', 'Vice Pres': 'Vice President', 'Member': 'Member', 'Committee': 'Committee Member'};
                                                    posDisplay.value = map[position] || position;
                                                }

                                                const emailInput = document.getElementById('editEmailInput');
                                                const lockMsg = document.getElementById('emailLockMessage');

                                                if (id === currentUserId) {
                                                    emailInput.readOnly = false;
                                                    emailInput.classList.remove('bg-light');
                                                    if (lockMsg)
                                                        lockMsg.style.display = 'none';
                                                } else {
                                                    emailInput.readOnly = true;
                                                    emailInput.classList.add('bg-light');
                                                    if (lockMsg)
                                                        lockMsg.style.display = 'block';
                                                }

                                                new bootstrap.Modal(document.getElementById('editMemberModal')).show();
                                            }
        </script>
    </body>
</html>