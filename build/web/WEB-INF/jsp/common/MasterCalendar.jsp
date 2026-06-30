<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Master Calendar - UMT ClubSphere</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            .calendar-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                overflow: hidden;
            }
            .calendar-header {
                background: #f8f9fa;
                padding: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #eee;
            }
            .month-year-label {
                font-size: 1.5rem;
                font-weight: 800;
                color: #4b0082;
            }
            .nav-btn {
                background: none;
                border: none;
                color: #4b0082;
                font-size: 1.2rem;
                cursor: pointer;
                transition: 0.2s;
            }
            .nav-btn:hover {
                transform: scale(1.2);
                color: #6a1b9a;
            }
            .calendar-grid {
                padding: 20px;
            }
            .weekdays {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                text-align: center;
                font-weight: bold;
                color: #999;
                margin-bottom: 10px;
                font-size: 0.9rem;
            }
            .days {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                gap: 10px;
            }
            .day {
                height: 50px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                border-radius: 12px;
                font-weight: 600;
                position: relative;
                transition: all 0.2s;
            }
            .day:hover:not(.empty) {
                background-color: #f3e5f5;
                color: #4b0082;
            }
            .day.selected {
                background-color: #4b0082 !important;
                color: white !important;
                box-shadow: 0 5px 15px rgba(75, 0, 130, 0.3);
            }
            .day.today {
                border: 2px solid #4b0082;
                color: #4b0082;
            }
            .day.empty {
                cursor: default;
            }
            .event-dots {
                display: flex;
                gap: 3px;
                margin-top: 2px;
            }
            .dot {
                width: 6px;
                height: 6px;
                border-radius: 50%;
            }

            /* Enhanced Dot Colors */
            .dot.Exam {
                background-color: #dc3545;
            }
            .dot.Holiday {
                background-color: #198754;
            }
            .dot.Official {
                background-color: #0dcaf0;
            }
            .dot.Urgent {
                background-color: #fd7e14;
            }
            .dot.Approved {
                background-color: #198754;
            }
            .dot.Pitching {
                background-color: #0d6efd;
            }
            .dot.Other {
                background-color: #6c757d;
            }

            .event-panel {
                background: #fdfdfd;
                border-left: 1px solid #eee;
                padding: 25px;
                height: 100%;
                min-height: 500px;
            }
            .selected-date-header {
                font-size: 1.8rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 5px;
            }
            .selected-day-name {
                font-size: 1.1rem;
                color: #777;
                margin-bottom: 25px;
            }
            .event-card {
                border-left: 5px solid #ddd;
                background: white;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.03);
                margin-bottom: 15px;
                transition: 0.3s;
                position: relative;
            }
            .event-card:hover {
                transform: translateX(5px);
            }

            /* Enhanced Card Border Colors */
            .event-card.Exam {
                border-left-color: #dc3545;
            }
            .event-card.Holiday {
                border-left-color: #198754;
            }
            .event-card.Official {
                border-left-color: #0dcaf0;
            }
            .event-card.Urgent {
                border-left-color: #fd7e14;
                background-color: #fff3cd;
            }
            .event-card.Approved {
                border-left-color: #198754;
            }
            .event-card.Pitching {
                border-left-color: #0d6efd;
            }

            .event-badge {
                font-size: 0.75rem;
                text-transform: uppercase;
                font-weight: bold;
                letter-spacing: 0.5px;
            }
            .empty-state {
                text-align: center;
                color: #aaa;
                margin-top: 50px;
            }
            .empty-state i {
                font-size: 3rem;
                margin-bottom: 10px;
                opacity: 0.5;
            }
            .event-actions {
                position: absolute;
                top: 15px;
                right: 15px;
                opacity: 0;
                transition: 0.2s;
            }
            .event-card:hover .event-actions {
                opacity: 1;
            }
            .action-btn {
                background: none;
                border: none;
                font-size: 0.9rem;
                color: #aaa;
                margin-left: 5px;
                cursor: pointer;
            }
            .action-btn:hover {
                color: #333;
            }
            .action-btn.delete:hover {
                color: #dc3545;
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">

            <%-- ALERT NOTIFICATION SECTION --%>
            <div id="alert-container">
                <c:if test="${not empty param.msg}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <c:choose>
                            <c:when test="${param.msg == 'success'}">Event saved successfully!</c:when>
                            <c:when test="${param.msg == 'synced'}">Holiday sync completed!</c:when>
                            <c:when test="${param.msg == 'deleted'}">Event deleted successfully.</c:when>
                            <c:otherwise>Operation successful.</c:otherwise>
                        </c:choose>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
            </div>
            <%-- END ALERT SECTION --%>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <div>
                        <h3 class="fw-bold text-dark mb-0">Master Calendar</h3>
                        <p class="text-muted small mb-0">Unified view of university schedule, holidays, and club events</p>
                    </div>
                </div>

                <%-- ONLY HEPA AND MPP CAN ADD EVENTS OR SYNC --%>
                <c:if test="${sessionScope.user.role == 'MPP' || sessionScope.user.role == 'HEPA'}">
                    <div class="d-flex gap-2">
                        <form action="${pageContext.request.contextPath}/common/calendar" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="sync">
                            <button type="submit" class="btn btn-outline-success rounded-pill px-4 shadow-sm" title="Fetch Malaysia Holidays">
                                <i class="fas fa-sync-alt me-2"></i> Sync Holidays
                            </button>
                        </form>

                        <button class="btn btn-primary rounded-pill px-4 shadow-sm" onclick="prepareAdd()">
                            <i class="fas fa-plus me-2"></i> Add Event
                        </button>
                    </div>
                </c:if>
            </div>

            <div class="calendar-container">
                <div class="row g-0">
                    <div class="col-lg-8 border-end">
                        <div class="calendar-header">
                            <button class="nav-btn" onclick="changeMonth(-1)"><i class="fas fa-chevron-left"></i></button>
                            <div class="month-year-label" id="monthYearLabel">January 2026</div>
                            <button class="nav-btn" onclick="changeMonth(1)"><i class="fas fa-chevron-right"></i></button>
                        </div>
                        <div class="calendar-grid">
                            <div class="weekdays">
                                <div>SUN</div><div>MON</div><div>TUE</div><div>WED</div><div>THU</div><div>FRI</div><div>SAT</div>
                            </div>
                            <div class="days" id="calendarDays"></div>
                        </div>
                        <div class="p-3 border-top d-flex flex-wrap gap-3 small fw-bold text-muted justify-content-center">
                            <div><span class="dot Exam d-inline-block me-1"></span> Exam/Due</div>
                            <div><span class="dot Approved d-inline-block me-1"></span> Approved Events</div>
                            <div><span class="dot Pitching d-inline-block me-1"></span> Pitching Sessions</div>
                            <div><span class="dot Urgent d-inline-block me-1"></span> Urgent Memos</div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="event-panel">
                            <h2 class="selected-date-header" id="displayDateNum">--</h2>
                            <div class="selected-day-name" id="displayDayName">Select a date</div>
                            <div id="dayEventsList">
                                <div class="empty-state">
                                    <i class="fas fa-calendar-day"></i>
                                    <p>No events scheduled.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- ADD EVENT MODAL (Only available to MPP/HEPA) --%>
        <c:if test="${sessionScope.user.role == 'MPP' || sessionScope.user.role == 'HEPA'}">
            <div class="modal fade" id="eventModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content border-0 shadow">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title fw-bold" id="modalTitle"><i class="fas fa-calendar-plus me-2"></i>Add New Event</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/common/calendar" method="post" id="eventForm">
                            <div class="modal-body p-4">
                                <input type="hidden" name="action" id="formAction" value="add">
                                <input type="hidden" name="eventId" id="eventId">

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Event Title</label>
                                    <input type="text" name="title" id="eTitle" class="form-control" required>
                                </div>
                                <div class="row g-3 mb-3">
                                    <div class="col-6">
                                        <label class="form-label fw-bold">Start Date</label>
                                        <input type="date" name="startDate" id="eStart" class="form-control" required>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label fw-bold">End Date</label>
                                        <input type="date" name="endDate" id="eEnd" class="form-control" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Category</label>
                                    <select name="type" id="eType" class="form-select">
                                        <option value="Exam">Exam</option>
                                        <option value="Public Holiday">Public Holiday</option>
                                        <option value="UMT Official">UMT Official</option>
                                        <option value="Urgent" class="fw-bold text-danger">⚠️ Urgent System Memo</option>
                                        <option value="Others">Others</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Description</label>
                                    <textarea name="description" id="eDesc" class="form-control" rows="3"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-link text-muted text-decoration-none" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary px-4 rounded-pill" id="submitBtn">Save Event</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/common/calendar" method="post" id="deleteForm">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="eventId" id="deleteId">
            </form>
        </c:if>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                // 1. Get Combined Events from Servlet
                                const eventsData = ${eventsJson != null ? eventsJson : '[]'};
                                const userRole = "${sessionScope.user.role}";

                                // Fixed safety check for club ID mapping
                                const userClubId = parseInt("${not empty sessionScope.clubId ? sessionScope.clubId : '0'}");

                                let currentDate = new Date();
                                const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                                const dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

                                let modal;
                                if (document.getElementById('eventModal')) {
                                    modal = new bootstrap.Modal(document.getElementById('eventModal'));
                                }

                                // --- RENDER LOGIC ---
                                function renderCalendar() {
                                    const year = currentDate.getFullYear();
                                    const month = currentDate.getMonth();
                                    document.getElementById("monthYearLabel").innerText = monthNames[month] + " " + year;

                                    const firstDayIndex = new Date(year, month, 1).getDay();
                                    const lastDate = new Date(year, month + 1, 0).getDate();
                                    const daysContainer = document.getElementById("calendarDays");
                                    daysContainer.innerHTML = "";

                                    for (let x = 0; x < firstDayIndex; x++) {
                                        daysContainer.innerHTML += `<div class="day empty"></div>`;
                                    }

                                    for (let i = 1; i <= lastDate; i++) {
                                        const currentDayStr = `\${year}-\${String(month + 1).padStart(2, '0')}-\${String(i).padStart(2, '0')}`;
                                        const dayEvents = eventsData.filter(e => currentDayStr >= e.start && currentDayStr <= e.end);

                                        let dotsHtml = "";
                                        if (dayEvents.length > 0) {
                                            dotsHtml = `<div class="event-dots">`;
                                            dayEvents.forEach(e => {
                                                let dotClass = "Other";
                                                if (e.type === "Public Holiday")
                                                    dotClass = "Holiday";
                                                else if (e.type === "UMT Official")
                                                    dotClass = "Official";
                                                else if (e.type === "Urgent")
                                                    dotClass = "Urgent";
                                                else if (e.type === "Approved")
                                                    dotClass = "Approved";
                                                else if (e.type === "Pitching")
                                                    dotClass = "Pitching";
                                                else if (e.type === "Exam")
                                                    dotClass = "Exam";

                                                dotsHtml += `<div class="dot \${dotClass}"></div>`;
                                            });
                                            dotsHtml += `</div>`;
                                        }

                                        const isToday = new Date().toDateString() === new Date(year, month, i).toDateString() ? "today" : "";
                                        daysContainer.innerHTML += `
                        <div class="day \${isToday}" onclick="selectDate('\${currentDayStr}', this)">
                            \${i} \${dotsHtml}
                        </div>`;
                                    }
                                }

                                function selectDate(dateStr, element) {
                                    document.querySelectorAll('.day').forEach(d => d.classList.remove('selected'));
                                    if (element)
                                        element.classList.add('selected');

                                    const dateObj = new Date(dateStr);
                                    document.getElementById("displayDateNum").innerText = dateObj.getDate();
                                    document.getElementById("displayDayName").innerText = dayNames[dateObj.getDay()] + ", " + monthNames[dateObj.getMonth()] + " " + dateObj.getFullYear();

                                    const dayEvents = eventsData.filter(e => dateStr >= e.start && dateStr <= e.end);
                                    const listContainer = document.getElementById("dayEventsList");

                                    if (dayEvents.length === 0) {
                                        let btnHtml = (userRole === 'MPP' || userRole === 'HEPA')
                                                ? `<button class="btn btn-sm btn-outline-primary rounded-pill mt-2" onclick="prepareAdd('\${dateStr}')">Add Event Here</button>`
                                                : ``;
                                        listContainer.innerHTML = `
                        <div class="empty-state">
                            <i class="fas fa-calendar-check"></i>
                            <p>No events scheduled.</p>
                            \${btnHtml}
                        </div>`;
                                    } else {
                                        listContainer.innerHTML = "";
                                        dayEvents.forEach(e => {
                                            let typeClass = "Other";
                                            if (e.type === "Public Holiday")
                                                typeClass = "Holiday";
                                            else if (e.type === "UMT Official")
                                                typeClass = "Official";
                                            else if (e.type === "Urgent")
                                                typeClass = "Urgent";
                                            else if (e.type === "Approved")
                                                typeClass = "Approved";
                                            else if (e.type === "Pitching")
                                                typeClass = "Pitching";
                                            else if (e.type === "Exam")
                                                typeClass = "Exam";

                                            let safeTitle = e.title ? e.title.replace(/'/g, "\\'") : "";
                                            let safeDesc = e.desc ? e.desc.replace(/'/g, "\\'") : "";
                                            let rawId = e.id.toString().substring(2); // Remove the M_ prefix for editing

                                            // 1. Actions (Admin only)
                                            let actionsHtml = "";
                                            if (e.editable && (userRole === 'MPP' || userRole === 'HEPA')) {
                                                actionsHtml = `
                                <div class="event-actions">
                                    <button class="action-btn" onclick="prepareEdit('\${rawId}', '\${safeTitle}', '\${e.start}', '\${e.end}', '\${e.type}', '\${safeDesc}')" title="Edit">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                    <button class="action-btn delete" onclick="deleteEvent('\${rawId}')" title="Delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            `;
                                            }

                                            // 2. Club Name Display (Requirement #1 & #2)
                                            let clubBadgeHtml = "";
                                            if (e.clubName) {
                                                clubBadgeHtml = `<div class="text-primary fw-bold small mb-2"><i class="fas fa-users me-1"></i> \${e.clubName}</div>`;
                                            }

                                            // 3. Smart Date Display (Requirement #1: Hide end date if same as start)
                                            let dateDisplayHtml = "";
                                            if (e.start === e.end || !e.end) {
                                                dateDisplayHtml = `<i class="far fa-clock me-1"></i> \${e.start}`;
                                            } else {
                                                dateDisplayHtml = `<i class="far fa-clock me-1"></i> \${e.start} to \${e.end}`;
                                            }

                                            // 4. Secure Google Meet Button (Requirement #2)
                                            let meetBtnHtml = "";
                                            if (e.url) {
                                                if (userRole === 'MPP' || userRole === 'HEPA' || userClubId === e.clubId) {
                                                    meetBtnHtml = `<a href="\${e.url}" target="_blank" class="btn btn-sm btn-primary w-100 rounded-pill mt-2"><i class="fas fa-video me-2"></i>Join Google Meet</a>`;
                                                } else {
                                                    meetBtnHtml = `<div class="alert alert-secondary py-2 px-3 mt-2 small mb-0 text-center border-0">
                                                 <i class="fas fa-lock me-1"></i> Pitching for \${e.clubName || 'Another Club'}
                                               </div>`;
                                                }
                                            }

                                            listContainer.innerHTML += `
                            <div class="event-card \${typeClass}">
                                \${actionsHtml}
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="event-badge text-\${typeClass === 'Exam' || typeClass === 'Urgent' ? 'danger' : (typeClass === 'Holiday' || typeClass === 'Approved' ? 'success' : 'primary')}">\${e.type}</span>
                                </div>
                                <h5 class="fw-bold mt-1 mb-1">\${e.title}</h5>
                                \${clubBadgeHtml}
                                <small class="text-muted d-block mb-1">\${dateDisplayHtml}</small>
                                <p class="text-muted small mb-0">\${safeDesc}</p>
                                \${meetBtnHtml}
                            </div>
                        `;
                                        });
                                    }
                                }

                                // --- ADD / EDIT / DELETE LOGIC (Only runs if user is Admin) ---
                                function prepareAdd(dateStr) {
                                    if (!modal)
                                        return;
                                    document.getElementById("formAction").value = "add";
                                    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-calendar-plus me-2"></i>Add New Event';
                                    document.getElementById("submitBtn").innerText = "Save Event";
                                    document.getElementById("eventForm").reset();
                                    if (dateStr) {
                                        document.getElementById("eStart").value = dateStr;
                                        document.getElementById("eEnd").value = dateStr;
                                    }
                                    modal.show();
                                }

                                function prepareEdit(id, title, start, end, type, desc) {
                                    if (!modal)
                                        return;
                                    document.getElementById("formAction").value = "update";
                                    document.getElementById("eventId").value = id;
                                    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-edit me-2"></i>Edit Event';
                                    document.getElementById("submitBtn").innerText = "Update Event";
                                    document.getElementById("eTitle").value = title;
                                    document.getElementById("eStart").value = start;
                                    document.getElementById("eEnd").value = end;
                                    document.getElementById("eType").value = type;
                                    document.getElementById("eDesc").value = desc;
                                    modal.show();
                                }

                                function deleteEvent(id) {
                                    if (confirm("Are you sure you want to delete this event? This action cannot be undone.")) {
                                        document.getElementById("deleteId").value = id;
                                        document.getElementById("deleteForm").submit();
                                    }
                                }

                                function changeMonth(direction) {
                                    currentDate.setMonth(currentDate.getMonth() + direction);
                                    renderCalendar();
                                }

                                // Initial Load
                                renderCalendar();
                                setTimeout(() => {
                                    const todayStr = new Date().toISOString().split('T')[0];
                                    const todayEl = document.querySelector('.day.today');
                                    if (todayEl)
                                        selectDate(todayStr, todayEl);
                                }, 100);
        </script>
    </body>
</html>