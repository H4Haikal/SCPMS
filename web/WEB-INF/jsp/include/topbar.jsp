<%--
Document    : topbar.jsp
Location    : /WEB-INF/jsp/include/topbar.jsp
Purpose     : Standardized Notification Bell & User Profile Header (User-Specific Read Status)
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="d-flex align-items-center justify-content-between w-100 px-3 py-2 bg-white border-bottom">
    <!-- Left Empty Spacer / Branding Area if needed -->
    <div></div>

    <!-- Right Side Header Components Controls -->
    <div class="d-flex align-items-center">

        <!-- Notification Dropdown Module Group -->
        <div class="dropdown me-3">
            <button class="btn btn-white shadow-sm rounded-circle p-2 position-relative border"
                    type="button" id="notificationDropdown" data-bs-toggle="dropdown" aria-expanded="false" 
                    style="width: 45px; height: 45px;">
                <i class="far fa-bell text-primary fs-5"></i>

                <%-- Dynamic Counter Notification Pill Badge Component --%>
                <c:if test="${not empty notificationCount and notificationCount > 0}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-white" 
                          style="font-size: 0.65rem;">
                        ${notificationCount}
                    </span>
                </c:if>
            </button>

            <%-- Dropdown Context Content Wrapper Panel Menu --%>
            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-4 mt-2 py-0 overflow-hidden" 
                aria-labelledby="notificationDropdown" style="width: 320px;">

                <%-- Dropdown Panel Header Element Header Row Actions --%>
                <li class="p-3 border-bottom bg-primary text-white d-flex justify-content-between align-items-center">
                    <h6 class="mb-0 fw-bold">Notifications</h6>
                    <c:if test="${not empty notifications}">
                        <a href="${pageContext.request.contextPath}/notifications?action=markAllRead"
                           class="text-white small text-decoration-none hover-opacity fw-semibold">Mark all read</a>
                    </c:if>
                </li>

                <%-- Scrollable Content Field Container List Wrapper --%>
                <li style="max-height: 300px; overflow-y: auto; list-style-type: none;" class="m-0 p-0">
                    <c:forEach var="n" items="${notifications}">
                        <%-- Every list object parsed through the query context is dynamically marked unread via background styling highlights --%>
                        <a class="dropdown-item p-3 border-bottom d-flex align-items-start text-wrap bg-light"
                           href="${pageContext.request.contextPath}/notifications?action=read&id=${n.notificationId}&redirect=${n.actionLink}">

                            <div class="bg-white text-primary rounded-circle p-2 me-3 border shadow-sm flex-shrink-0">
                                <i class="fas fa-info-circle"></i>
                            </div>

                            <div class="flex-grow-1">
                                <div class="fw-bold small text-dark">${n.title}</div>
                                <div class="text-muted small mt-1">${n.message}</div>
                                <div class="text-muted mt-2" style="font-size: 0.7rem;">
                                    <i class="far fa-clock me-1"></i> 
                                    <fmt:formatDate value="${n.createdAt}" pattern="dd MMM, hh:mm a" />
                                </div>
                            </div>
                        </a>
                    </c:forEach>

                    <%-- Fallback Context Content Segment when List Array is Void Empty --%>
                    <c:if test="${empty notifications}">
                        <div class="p-4 text-center text-muted small">
                            <i class="fas fa-bell-slash fa-2x mb-2 opacity-25 text-primary"></i><br>
                            <span>No new notifications.</span>
                        </div>
                    </c:if>
                </li>
            </ul>
        </div>


        <div class="bg-white border rounded-pill px-3 py-2 shadow-sm d-flex align-items-center">
            <i class="fas fa-user-circle text-primary me-2 fa-lg"></i>
            <strong class="text-dark small">${sessionScope.user.fullName}</strong>
        </div>

    </div>
</div>
