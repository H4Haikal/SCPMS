<%-- 
    Document   : forgotPassword
    Created on : 19 Jan 2026, 9:00:47 pm
    Author     : User
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Forgot Password - ClubSphere</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background: #f4f7f6;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .auth-card {
                width: 100%;
                max-width: 400px;
                padding: 2rem;
                border-radius: 15px;
                border: none;
            }
        </style>
    </head>
    <body>
        <div class="card auth-card shadow-lg">
            <div class="text-center mb-4">
                <h3 class="fw-bold text-primary">Reset Password</h3>
                <p class="text-muted small">Follow the steps to recover your account</p>
            </div>

            <c:if test="${not empty error}"><div class="alert alert-danger small">${error}</div></c:if>

            <c:choose>
                <%-- STEP 1: Enter Email --%>
                <c:when test="${empty step}">
                    <form action="ForgotPasswordServlet" method="post">
                        <input type="hidden" name="action" value="requestOTP">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Enter Registered Email</label>
                            <input type="email" name="email" class="form-control rounded-pill" required placeholder="name@ocean.umt.edu.my">
                        </div>
                        <button type="submit" class="btn btn-primary w-100 rounded-pill">Send OTP</button>
                    </form>
                </c:when>

                <%-- STEP 2: Enter OTP --%>
                <c:when test="${step == 'verify'}">
                    <form action="ForgotPasswordServlet" method="post">
                        <input type="hidden" name="action" value="verifyOTP">
                        <input type="hidden" name="email" value="${email}">
                        <p class="small text-center">OTP sent to <b>${email}</b></p>
                        <div class="mb-3">
                            <input type="text" name="otp" class="form-control text-center fs-4 fw-bold" maxlength="6" placeholder="000000" required>
                        </div>
                        <button type="submit" class="btn btn-success w-100 rounded-pill">Verify Code</button>
                    </form>
                </c:when>

                <%-- STEP 3: New Password --%>
                <c:when test="${step == 'reset'}">
                    <form action="ForgotPasswordServlet" method="post">
                        <input type="hidden" name="action" value="resetPassword">
                        <input type="hidden" name="email" value="${email}">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">New Password</label>
                            <input type="password" name="password" class="form-control rounded-pill" required minlength="8">
                        </div>
                        <button type="submit" class="btn btn-primary w-100 rounded-pill">Reset Password</button>
                    </form>
                </c:when>
            </c:choose>

            <div class="text-center mt-4">
                <a href="LoginServlet" class="text-decoration-none small text-muted"><i class="fas fa-arrow-left"></i> Back to Login</a>
            </div>
        </div>
    </body>
</html>