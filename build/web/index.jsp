<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // =========================================================
    // THE ROUTER: DECIDES WHERE THE USER SHOULD GO
    // =========================================================

    // 1. Get the current session (do not create a new one if it doesn't exist)
    HttpSession currentSession = request.getSession(false);

    // 2. CHECK: Is the user logged in?
    if (currentSession != null && currentSession.getAttribute("user") != null) {

        // 3. User is logged in! Where do they belong?
        String role = (String) currentSession.getAttribute("role");

        if ("MPP".equals(role)) {
            response.sendRedirect("MPPDashboardServlet");
        } else if ("CHC".equals(role)) {
            response.sendRedirect("ClubDashboardServlet");
        } else {
            // Fallback for unknown roles (e.g., normal members)
            // You can change this to a MemberDashboardServlet later
            response.sendRedirect("LoginServlet");
        }

    } else {
        // 4. Not logged in? Go to Login.
        response.sendRedirect("LoginServlet");
    }
%>