<%-- 
    Document   : sidebar.jsp
    Purpose    : Standardized sidebar with Dynamic User Info, Logout & Separated AGM Module
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="sidebar d-flex flex-column h-100" id="sidebar">

    <div class="sidebar-header text-center py-4 border-bottom border-light border-opacity-25 flex-shrink-0">
        <img src="${pageContext.request.contextPath}/images/Logo_Rasmi_UMT.png" 
             alt="UMT Logo" class="img-fluid mb-3" style="max-height: 90px; filter: drop-shadow(0 0 8px white);">
        <h4 class="text-white fw-bold mb-0">ClubSphere</h4>
        <small class="text-white opacity-75">Student Club Management System</small>
    </div>

    <div class="flex-grow-1 overflow-auto px-3">
        <nav class="nav flex-column mt-4">
            <%
                String currentPath = request.getRequestURI();
                String dashboardLink = request.getContextPath() + "/dashboard";

                String currentRole = (String) session.getAttribute("role");
                if (currentRole == null && session.getAttribute("user") != null) {
                    model.User u = (model.User) session.getAttribute("user");
                    currentRole = u.getRole();
                }

                if ("CHC".equals(currentRole)) {
                    dashboardLink = request.getContextPath() + "/ClubDashboardServlet";
                } else if ("Advisor".equals(currentRole)) {
                    dashboardLink = request.getContextPath() + "/advisor/dashboard";
                } else if ("HEPA".equals(currentRole)) {
                    dashboardLink = request.getContextPath() + "/hepa/dashboard";
                } else if ("Faculty".equals(currentRole)) {
                    dashboardLink = request.getContextPath() + "/faculty/dashboard";
                }
            %>

            <%-- DASHBOARD UTAMA --%>
            <a class="nav-link <%= currentPath.endsWith("/") || currentPath.contains("Dashboard") || currentPath.contains("dashboard") ? "active" : ""%>" 
               href="<%= dashboardLink%>">
                <i class="fas fa-home me-3"></i> Dashboard
            </a>

            <c:choose>
                <%-- MPP MENU ITEMS --%>
                <c:when test="${sessionScope.role == 'MPP' || sessionScope.user.role == 'MPP'}">
                    <a class="nav-link <%= currentPath.contains("/mpp/club") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/mpp/club">
                        <i class="fas fa-users-cog me-3"></i> Manage Clubs
                    </a>
                    <a class="nav-link <%= currentPath.contains("/mpp/proposals") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/mpp/proposals">
                        <i class="fas fa-file-alt me-3"></i> Review Proposals
                    </a>
                    <a class="nav-link <%= currentPath.contains("/mpp/agm") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/mpp/agm">
                        <i class="fas fa-tasks me-3"></i> Semakan AGM
                    </a>
                    <a class="nav-link <%= currentPath.contains("/common/calendar") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/common/calendar">
                        <i class="fas fa-calendar-day me-3"></i> Master Calendar
                    </a>
                    <a class="nav-link" href="#">
                        <i class="fas fa-chart-bar me-3"></i> Reports & Analytics
                    </a>
                    <a class="nav-link <%= currentPath.contains("/mpp/audit") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/mpp/audit">
                        <i class="fas fa-history me-3"></i> Audit Trail
                    </a>
                </c:when>

                <%-- ADVISOR MENU ITEMS --%>
                <c:when test="${sessionScope.role == 'Advisor' || sessionScope.user.role == 'Advisor'}">
                    <a class="nav-link <%= currentPath.contains("/advisor/pending") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/advisor/pending">
                        <i class="fas fa-clipboard-list me-3"></i> Pending Proposals
                    </a>
                    <a class="nav-link <%= currentPath.contains("/advisor/directory") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/advisor/directory">
                        <i class="fas fa-address-book me-3"></i> Club Directory
                    </a>
                    <a class="nav-link <%= currentPath.contains("/advisor/documentation") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/advisor/documentation">
                        <i class="fas fa-book me-3"></i> Documentations & Guidelines
                    </a>
                    <a class="nav-link <%= currentPath.contains("/common/calendar") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/common/calendar">
                        <i class="fas fa-calendar-day me-3"></i> Master Calendar
                    </a>
                </c:when>

                <%-- HEPA MENU ITEMS --%>
                <c:when test="${sessionScope.role == 'HEPA' || sessionScope.user.role == 'HEPA'}">
                    <a class="nav-link <%= currentPath.contains("/hepa/club") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/hepa/club">
                        <i class="fas fa-heartbeat me-3"></i> Club Health
                    </a>
                    <a class="nav-link <%= currentPath.contains("/hepa/mpp") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/hepa/mpp">
                        <i class="fas fa-user-tie me-3"></i> Manage MPP
                    </a>
                    <a class="nav-link <%= currentPath.contains("/hepa/endorse") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/hepa/endorse">
                        <i class="fas fa-stamp me-3"></i> Endorsements
                    </a>
                    <a class="nav-link <%= currentPath.contains("/hepa/agm") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/hepa/agm">
                        <i class="fas fa-clipboard-check me-3"></i> Manage AGM
                    </a>

                    <%-- NEW: HEPA DOCUMENT MANAGER --%>
                    <a class="nav-link <%= currentPath.contains("/hepa/documents") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/hepa/documents">
                        <i class="fas fa-file-upload me-3"></i> Manage Documents
                    </a>

                    <a class="nav-link <%= currentPath.contains("/hepa/reports") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/hepa/reports">
                        <i class="fas fa-chart-line me-3"></i> Master Reports
                    </a>
                    <a class="nav-link <%= currentPath.contains("/common/calendar") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/common/calendar">
                        <i class="fas fa-calendar-day me-3"></i> Master Calendar
                    </a>

                    <a class="nav-link <%= currentPath.contains("/hepa/audit") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/hepa/audit">
                        <i class="fas fa-fingerprint me-3"></i> Forensic Audit Trail
                    </a>
                </c:when>

                <%-- CHC MENU ITEMS --%>
                <c:when test="${sessionScope.role == 'CHC' || sessionScope.user.role == 'CHC'}">
                    <a class="nav-link <%= currentPath.contains("/chc/profile") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/chc/profile">
                        <i class="fas fa-id-badge me-3"></i> My Club Profile
                    </a>
                    <a class="nav-link <%= currentPath.contains("/chc/members") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/chc/members">
                        <i class="fas fa-users me-3"></i> Manage Members
                    </a>
                    <a class="nav-link <%= currentPath.contains("SubmitProposal") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/SubmitProposalServlet">
                        <i class="fas fa-lightbulb me-3"></i> Create Proposal
                    </a>
                    <a class="nav-link <%= currentPath.contains("/chc/events") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/chc/events">
                        <i class="fas fa-calendar-alt me-3"></i> My Events
                    </a>
                    <a class="nav-link <%= currentPath.contains("/common/agm") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/common/agm">
                        <i class="fas fa-file-signature me-3"></i> AGM Report
                    </a>

                    <%-- NEW: CHC GUIDELINES LINK --%>
                    <a class="nav-link <%= currentPath.contains("/chc/documentation") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/chc/documentation">
                        <i class="fas fa-book-open me-3"></i> Guidelines & Docs
                    </a>

                    <a class="nav-link <%= currentPath.contains("/common/calendar") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/common/calendar">
                        <i class="fas fa-calendar-day me-3"></i> Master Calendar
                    </a>
                </c:when>  

                <%-- FACULTY MENU ITEMS --%>
                <c:when test="${sessionScope.role == 'Faculty' || sessionScope.user.role == 'Faculty'}">
                    <a class="nav-link <%= currentPath.contains("/faculty/proposals") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/faculty/proposals">
                        <i class="fas fa-folder-open me-3"></i> All Proposals
                    </a>
                    <a class="nav-link <%= currentPath.contains("/common/calendar") ? "active" : ""%>" 
                       href="${pageContext.request.contextPath}/common/calendar">
                        <i class="fas fa-calendar-day me-3"></i> Master Calendar
                    </a>
                </c:when>
            </c:choose>

            <hr class="my-4 border-light opacity-25">

            <a class="nav-link <%= currentPath.contains("UserSettings") ? "active" : ""%>" 
               href="${pageContext.request.contextPath}/user/settings">
                <i class="fas fa-cog me-3"></i> Settings
            </a>

            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt me-3"></i> Logout
            </a>
        </nav>
    </div>

    <div class="sidebar-footer text-center py-3 small text-white opacity-75 border-top border-light border-opacity-25 flex-shrink-0">
        <strong>${sessionScope.user.userId}</strong><br>
        ${sessionScope.user.fullName}<br>
        &copy; 2026 UMT ClubSphere
    </div>
</div>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.getElementById('sidebarToggle');
        const overlay = document.getElementById('sidebarOverlay');

        if (toggleBtn) {
            toggleBtn.addEventListener('click', function () {
                sidebar.classList.toggle('active');
                if (overlay)
                    overlay.classList.toggle('active');
            });
        }
        if (overlay) {
            overlay.addEventListener('click', function () {
                sidebar.classList.remove('active');
                overlay.classList.remove('active');
            });
        }
    });
</script>