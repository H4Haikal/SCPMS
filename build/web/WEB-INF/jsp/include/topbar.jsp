<%-- 
    Document   : topbar.jsp
    Location   : /WEB-INF/jsp/include/topbar.jsp
    Purpose    : Standardized Notification Bell & User Profile Header
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="d-flex align-items-center">
    <div class="dropdown me-3">
        <button class="btn btn-white shadow-sm rounded-circle p-2 position-relative border" type="button" data-bs-toggle="dropdown" style="width: 45px; height: 45px;">
            <i class="far fa-bell text-primary fs-5"></i>
            <c:if test="${not empty notificationCount and notificationCount > 0}">
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-white" style="font-size: 0.65rem;">
                    ${notificationCount}
                </span>
            </c:if>
        </button>

        <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-4 mt-2 py-0 overflow-hidden" style="width: 320px;">
            <li class="p-3 border-bottom bg-primary text-white d-flex justify-content-between align-items-center">
                <h6 class="mb-0 fw-bold">Notifications</h6>
                <a href="${pageContext.request.contextPath}/notifications?action=markAllRead" class="text-white small text-decoration-none hover-opacity">Mark all read</a>
            </li>
            <div style="max-height: 300px; overflow-y: auto;">
                <c:forEach var="n" items="${notifications}">
                    <li>
                        <a class="dropdown-item p-3 border-bottom d-flex align-items-start text-wrap ${n.isRead == 0 ? 'bg-light' : ''}" 
                           href="${pageContext.request.contextPath}/notifications?action=read&id=${n.notificationId}&redirect=${n.actionLink}">
                            <div class="bg-white text-primary rounded-circle p-2 me-3 border shadow-sm">
                                <i class="fas fa-info-circle"></i>
                            </div>
                            <div>
                                <div class="fw-bold small text-dark">${n.title}</div>
                                <div class="text-muted small">${n.message}</div>
                                <div class="text-muted mt-1" style="font-size: 0.7rem;">
                                    <i class="far fa-clock me-1"></i> <fmt:formatDate value="${n.createdAt}" pattern="dd MMM, hh:mm a" />
                                </div>
                            </div>
                        </a>
                    </li>
                </c:forEach>
                <c:if test="${empty notifications}">
                    <li class="p-4 text-center text-muted small">
                        <i class="fas fa-bell-slash fa-2x mb-2 opacity-25"></i><br>
                        No new notifications.
                    </li>
                </c:if>
            </div>
        </ul>
    </div>

    <div class="bg-white border rounded-pill px-3 py-2 shadow-sm d-flex align-items-center">
        <i class="fas fa-user-circle text-primary me-2 fa-lg"></i> 
        <strong class="text-dark small">${sessionScope.user.fullName}</strong>
    </div>
</div>