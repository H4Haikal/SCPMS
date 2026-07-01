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
            body {
                background-color: #f8f9fa;
            }

            /* Top Header */
            .top-header {
                margin-bottom: 2rem;
                padding: 1rem 0;
            }

            /* Stat Cards */
            .stat-card {
                background: white;
                border-radius: 1rem;
                padding: 1.5rem;
                transition: all 0.3s ease;
                height: 100%;
                border: none;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.04);
            }
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.08);
            }
            .icon-box {
                width: 48px;
                height: 48px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 12px;
                font-size: 1.25rem;
            }

            /* Welcome Card */
            .welcome-card {
                background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
                color: white;
                border-radius: 1rem;
                padding: 2.5rem 2rem;
                margin-bottom: 2rem;
                box-shadow: 0 4px 15px rgba(13, 110, 253, 0.2);
                position: relative;
                overflow: hidden;
            }
            .welcome-card::after {
                content: '';
                position: absolute;
                top: -50%;
                right: -10%;
                width: 300px;
                height: 300px;
                background: rgba(255,255,255,0.1);
                border-radius: 50%;
            }

            /* Timeline for Recent Activities */
            .timeline {
                border-left: 2px solid #e9ecef;
                padding-left: 1.5rem;
                margin-left: 0.5rem;
                margin-top: 1rem;
            }
            .timeline-item {
                position: relative;
                padding-bottom: 1.5rem;
            }
            .timeline-item:last-child {
                padding-bottom: 0;
            }
            .timeline-item::before {
                content: '';
                position: absolute;
                left: -1.85rem;
                top: 0.25rem;
                width: 14px;
                height: 14px;
                background: #0d6efd;
                border: 3px solid white;
                border-radius: 50%;
                box-shadow: 0 0 0 2px #e9ecef;
            }

            /* Event Date Badge */
            .date-badge {
                min-width: 65px;
                text-align: center;
                background: #f1f5f9;
                border-radius: 0.75rem;
                padding: 0.5rem;
            }
        </style>
    </head>
    <body>

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="top-header d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center">
                    <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                        <i class="fas fa-bars fa-lg"></i>
                    </button>
                    <i class="fas fa-layer-group fa-2x text-primary me-3 d-none d-lg-block"></i>
                    <h3 class="fw-bold mb-0 text-dark">Dashboard Overview</h3>
                </div>
                <%@ include file="/WEB-INF/jsp/include/topbar.jsp" %>
            </div>

            <div class="welcome-card">
                <div class="row align-items-center position-relative" style="z-index: 1;">
                    <div class="col-md-8">
                        <h2 class="fw-bold mb-2">Welcome back, ${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'User'}!</h2>
                        <p class="lead mb-0 opacity-75" style="font-size: 1.1rem;">
                            UMT ClubSphere • Student Club Management System
                        </p>
                        <div class="mt-3 bg-white bg-opacity-10 d-inline-block rounded-pill px-3 py-2 border border-light border-opacity-25">
                            <i class="far fa-calendar-alt me-2"></i> 
                            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, dd MMMM yyyy" />
                        </div>
                    </div>
                    <div class="col-md-4 text-md-end d-none d-md-block"> 
                        <img src="${pageContext.request.contextPath}/img/dashboard-illustration.svg" alt="" style="max-height: 120px; opacity: 0.9;" onerror="this.style.display='none'">
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card border-bottom border-4 border-primary">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-muted small fw-bold text-uppercase mb-1">Active Clubs</p>
                                <h3 class="fw-bold mb-0 text-dark">${activeClubs}</h3>
                            </div>
                            <div class="icon-box text-primary bg-primary bg-opacity-10">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="stat-card border-bottom border-4 border-success">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-muted small fw-bold text-uppercase mb-1">Total Members</p>
                                <h3 class="fw-bold mb-0 text-dark">${totalMembers}</h3>
                            </div>
                            <div class="icon-box text-success bg-success bg-opacity-10">
                                <i class="fas fa-id-card"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="stat-card border-bottom border-4 border-warning">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-muted small fw-bold text-uppercase mb-1">Events This Week</p>
                                <h3 class="fw-bold mb-0 text-dark">${eventsThisWeek}</h3>
                            </div>
                            <div class="icon-box text-warning bg-warning bg-opacity-10">
                                <i class="far fa-calendar-check"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6">
                    <div class="stat-card border-bottom border-4 border-danger">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <p class="text-muted small fw-bold text-uppercase mb-1">Total Events ${currentYear}</p>
                                <h3 class="fw-bold mb-0 text-dark">${totalEventsThisYear != null ? totalEventsThisYear : '0'}</h3>
                            </div>
                            <div class="icon-box text-danger bg-danger bg-opacity-10">
                                <i class="fas fa-chart-line"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-7 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold mb-0">Recent Activities</h5>
                        <a href="${pageContext.request.contextPath}/mpp/audit" class="btn btn-sm btn-light border-0 text-primary fw-bold shadow-sm">View All</a>
                    </div>

                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-body p-4">
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <div class="timeline">
                                        <c:forEach var="activity" items="${recentActivities}">
                                            <div class="timeline-item">
                                                <div class="d-flex justify-content-between mb-1">
                                                    <strong class="text-dark">${activity.action}</strong>
                                                    <small class="text-muted">${activity.timestamp}</small>
                                                </div>
                                                <p class="text-secondary mb-1 small">${activity.description}</p>
                                                <small class="text-primary fw-semibold">
                                                    <i class="fas fa-user-circle me-1"></i> ${activity.userId}
                                                </small>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5 text-muted">
                                        <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 60px; height: 60px;">
                                            <i class="fas fa-history fs-4 text-secondary opacity-50"></i>
                                        </div>
                                        <p class="mb-0">No recent activities recorded.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5 mb-4">
                    <h5 class="fw-bold mb-4">Upcoming Events</h5>

                    <div class="card border-0 bg-transparent">
                        <c:choose>
                            <c:when test="${not empty upcomingEvents}">
                                <c:forEach var="event" items="${upcomingEvents}">
                                    <div class="card border-0 shadow-sm rounded-4 mb-3 transition-hover">
                                        <div class="card-body p-3 d-flex align-items-center">
                                            <div class="date-badge me-3">
                                                <span class="d-block fw-bolder fs-5 text-primary"><fmt:formatDate value="${event.date}" pattern="dd" /></span>
                                                <span class="d-block small fw-bold text-muted text-uppercase"><fmt:formatDate value="${event.date}" pattern="MMM" /></span>
                                            </div>

                                            <div>
                                                <h6 class="fw-bold mb-1 text-dark">${event.title}</h6>
                                                <p class="text-secondary small mb-1">
                                                    <i class="fas fa-users text-muted me-1"></i> ${event.clubName}
                                                </p>
                                                <p class="text-muted small mb-0">
                                                    <i class="fas fa-map-marker-alt text-danger opacity-75 me-1"></i> 
                                                    ${event.venue != null ? event.venue : 'Venue TBC'}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="card border-0 shadow-sm rounded-4">
                                    <div class="card-body text-center py-5 text-muted">
                                        <i class="far fa-calendar-times fs-2 mb-3 opacity-25"></i>
                                        <p class="mb-0">No upcoming events scheduled.</p>
                                    </div>
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