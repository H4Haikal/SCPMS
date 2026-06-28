<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <title>UMT ClubSphere - Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            /* Top Header Styling */
            .top-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding: 1rem 0;
            }
            .stat-card {
                background: white;
                border-radius: 15px;
                padding: 1.5rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                transition: transform 0.2s;
                height: 100%;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
            .stat-card .icon {
                font-size: 2rem;
                margin-bottom: 1rem;
            }
            .welcome-card {
                background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
                color: white;
                border-radius: 15px;
                padding: 2rem;
                margin-bottom: 2rem;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">

            <div class="top-header">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>

                    <i class="fas fa-tachometer-alt fa-2x text-primary me-4 d-none d-lg-block"></i>
                    <h3 class="fw-bold mb-0">Dashboard Overview</h3>
                </div>

                <%-- Panggil Standard Topbar UI --%>
                <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
            </div>

            <div class="welcome-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h2>Welcome back, ${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'User'}!</h2>
                        <p class="lead mb-0 opacity-75">
                            UMT ClubSphere • Student Club Management System<br>
                            <span class="fs-6"><i class="far fa-clock me-1"></i> <fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, dd MMMM yyyy" /></span>
                        </p>
                    </div>
                    <div class="col-md-4 text-md-end d-none d-md-block"> 
                        <div class="bg-white text-primary rounded-circle d-inline-flex align-items-center justify-content-center shadow-sm"
                             style="width: 100px; height: 100px; font-size: 3rem;">
                            <i class="fas fa-user-tie"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-lg-3 col-md-6">
                    <div class="stat-card border-start border-4 border-primary">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="text-muted small fw-bold text-uppercase mb-1">Active Clubs</div>
                                <h3 class="fw-bold mb-0 text-dark">${activeClubs}</h3>
                            </div>
                            <div class="icon text-primary bg-primary bg-opacity-10 rounded p-2" style="font-size: 1.2rem;">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="stat-card border-start border-4 border-success">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="text-muted small fw-bold text-uppercase mb-1">Total Members</div>
                                <h3 class="fw-bold mb-0 text-dark">${totalMembers}</h3>
                            </div>
                            <div class="icon text-success bg-success bg-opacity-10 rounded p-2" style="font-size: 1.2rem;">
                                <i class="fas fa-id-card"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="stat-card border-start border-4 border-warning">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="text-muted small fw-bold text-uppercase mb-1">Events This Week</div>
                                <h3 class="fw-bold mb-0 text-dark">${eventsThisWeek}</h3>
                            </div>
                            <div class="icon text-warning bg-warning bg-opacity-10 rounded p-2" style="font-size: 1.2rem;">
                                <i class="far fa-calendar-alt"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="stat-card border-start border-4 border-danger">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="text-muted small fw-bold text-uppercase mb-1">Total Events 2025</div>
                                <h3 class="fw-bold mb-0 text-dark">${totalEvents2025}</h3>
                            </div>
                            <div class="icon text-danger bg-danger bg-opacity-10 rounded p-2" style="font-size: 1.2rem;">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8 mb-4">
                    <h4 class="fw-bold mb-4">Recent Activities</h4>
                    <div class="card border-0 shadow-sm p-3 rounded-4">
                        <c:choose>
                            <c:when test="${not empty recentActivities}">
                                <c:forEach var="activity" items="${recentActivities}">
                                    <div class="activity-item border-bottom py-2 mb-2">
                                        <div class="d-flex w-100 justify-content-between">
                                            <div>
                                                <strong class="text-primary">${activity.action}</strong><br>
                                                <span class="text-secondary small">${activity.description}</span><br>
                                                <span class="text-muted" style="font-size: 0.75rem;">
                                                    <i class="fas fa-user-tag me-1"></i> ${activity.userId}
                                                </span>
                                            </div>
                                            <small class="text-muted text-end" style="min-width: 120px;">
                                                ${activity.timestamp}
                                            </small>
                                        </div>
                                    </div>
                                </c:forEach>
                                <div class="text-center mt-2">
                                    <a href="${pageContext.request.contextPath}/mpp/audit" class="text-decoration-none small fw-bold">View Full History &rarr;</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4 text-muted">
                                    <i class="fas fa-history fa-2x mb-2 opacity-25"></i><br>
                                    No recent activities recorded.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                    <h4 class="fw-bold mb-4">Upcoming Events</h4>
                    <div class="event-box">
                        <c:choose>
                            <c:when test="${not empty upcomingEvents}">
                                <c:forEach var="event" items="${upcomingEvents}">
                                    <div class="event-card">
                                        <h6 class="fw-bold">${event.title}</h6>
                                        <small class="text-muted">${event.clubName}</small>
                                        <div class="mt-2">
                                            <i class="far fa-calendar me-2"></i>
                                            <fmt:formatDate value="${event.date}" pattern="dd MMMM yyyy" />
                                        </div>
                                        <div class="mt-1">
                                            <i class="fas fa-map-marker-alt me-2"></i>
                                            ${event.venue != null ? event.venue : 'Venue TBC'}
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted p-4 text-center">
                                    No upcoming events scheduled.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>