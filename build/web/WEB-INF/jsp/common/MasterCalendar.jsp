<%-- 
    Document   : MasterCalendar
    Created on : 20 Jan 2026, 8:46:07 am
    Author     : User
--%>
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
            /* (Keep your existing styles EXACTLY as they were) */
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
            .dot.Exam {
                background-color: #dc3545;
            }
            .dot.Holiday {
                background-color: #198754;
            }
            .dot.Official {
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
            .event-card.Exam {
                border-left-color: #dc3545;
            }
            .event-card.Holiday {
                border-left-color: #198754;
            }
            .event-card.Official {
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

            /* New Styles for Actions */
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
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <div>
                        <h3 class="fw-bold text-dark mb-0">Master Calendar</h3>
                        <p class="text-muted small mb-0">Manage university schedule and holidays</p>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <form action="${pageContext.request.contextPath}/mpp/calendar" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="sync">
                        <button type="submit" class="btn btn-outline-success rounded-pill px-4 shadow-sm" title="Fetch Malaysia Holidays">
                            <i class="fas fa-sync-alt me-2"></i> Sync Public Holidays
                        </button>
                    </form>

                    <button class="btn btn-primary rounded-pill px-4 shadow-sm" onclick="prepareAdd()">
                        <i class="fas fa-plus me-2"></i> Add Event
                    </button>
                </div>
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

        <div class="modal fade" id="eventModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content border-0 shadow">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold" id="modalTitle"><i class="fas fa-calendar-plus me-2"></i>Add New Event</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/mpp/calendar" method="post" id="eventForm">
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
                                    <option value="Convocation">Convocation</option>
                                    <option value="UMT Official">UMT Official</option>
                                    <option value="Ramadan">Ramadan</option>
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

        <form action="${pageContext.request.contextPath}/mpp/calendar" method="post" id="deleteForm">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="eventId" id="deleteId">
        </form>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                // 1. Get Events from Servlet
                                const eventsData = ${eventsJson};

                                let currentDate = new Date();
                                const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                                const dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
                                const modal = new bootstrap.Modal(document.getElementById('eventModal'));

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
                                        // Filter events that SPAN this day
                                        const dayEvents = eventsData.filter(e => currentDayStr >= e.start && currentDayStr <= e.end);

                                        let dotsHtml = "";
                                        if (dayEvents.length > 0) {
                                            dotsHtml = `<div class="event-dots">`;
                                            dayEvents.forEach(e => {
                                                let dotClass = e.type === "Public Holiday" ? "Holiday" : (e.type === "UMT Official" ? "Official" : e.type);
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

                                    // Filter Side Panel
                                    const dayEvents = eventsData.filter(e => dateStr >= e.start && dateStr <= e.end);
                                    const listContainer = document.getElementById("dayEventsList");

                                    if (dayEvents.length === 0) {
                                        listContainer.innerHTML = `
                        <div class="empty-state">
                            <i class="fas fa-calendar-check"></i>
                            <p>No events scheduled.</p>
                            <button class="btn btn-sm btn-outline-primary rounded-pill mt-2" onclick="prepareAdd('\${dateStr}')">Add Event Here</button>
                        </div>`;
                                    } else {
                                        listContainer.innerHTML = "";
                                        dayEvents.forEach(e => {
                                            let typeClass = e.type === "Public Holiday" ? "Holiday" : (e.type === "UMT Official" ? "Official" : e.type);

                                            // ESCAPE QUOTES FOR JS FUNCTION CALLS
                                            let safeTitle = e.title.replace(/'/g, "\\'");
                                            let safeDesc = e.desc.replace(/'/g, "\\'");

                                            listContainer.innerHTML += `
                            <div class="event-card \${typeClass}">
                                <div class="event-actions">
                                    <button class="action-btn" onclick="prepareEdit('\${e.id}', '\${safeTitle}', '\${e.start}', '\${e.end}', '\${e.type}', '\${safeDesc}')" title="Edit">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                    <button class="action-btn delete" onclick="deleteEvent('\${e.id}')" title="Delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span class="event-badge text-\${typeClass === 'Exam' ? 'danger' : (typeClass === 'Holiday' ? 'success' : 'primary')}">\${e.type}</span>
                                </div>
                                <h5 class="fw-bold mt-1 mb-1">\${e.title}</h5>
                                <small class="text-muted d-block mb-1"><i class="far fa-clock me-1"></i> \${e.start} to \${e.end}</small>
                                <p class="text-muted small mb-0">\${e.desc}</p>
                            </div>
                        `;
                                        });
                                    }
                                }

                                // --- ADD / EDIT / DELETE LOGIC ---

                                function prepareAdd(dateStr) {
                                    document.getElementById("formAction").value = "add";
                                    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-calendar-plus me-2"></i>Add New Event';
                                    document.getElementById("submitBtn").innerText = "Save Event";
                                    document.getElementById("eventForm").reset(); // Clear old data

                                    if (dateStr) {
                                        document.getElementById("eStart").value = dateStr;
                                        document.getElementById("eEnd").value = dateStr;
                                    }
                                    modal.show();
                                }

                                function prepareEdit(id, title, start, end, type, desc) {
                                    document.getElementById("formAction").value = "update";
                                    document.getElementById("eventId").value = id;
                                    document.getElementById("modalTitle").innerHTML = '<i class="fas fa-edit me-2"></i>Edit Event';
                                    document.getElementById("submitBtn").innerText = "Update Event";

                                    // Fill Form
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