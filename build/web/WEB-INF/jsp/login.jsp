<%-- 
    Document   : login.jsp
    Purpose    : Secure Landing & Login Page for SCPMS
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login | UMT Proposal Management System</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            :root {
                --umt-purple: #4b0082;
                --umt-blue: #000080;
                --umt-gold: #FFD700;
            }

            body {
                height: 100vh;
                margin: 0;
                overflow: hidden;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8f9fa;
            }

            .main-container {
                height: 100vh;
                width: 100%;
            }

            /* --- LEFT SIDE: CAROUSEL & PARTICLES --- */
            .info-side {
                background: linear-gradient(135deg, var(--umt-purple), var(--umt-blue));
                color: white;
                display: flex;
                flex-direction: column;
                justify-content: center;
                padding: 50px;
                position: relative;
                overflow: hidden;
            }

            /* Decorative Circle Backgrounds */
            .info-side::before {
                content: "";
                position: absolute;
                top: -10%;
                right: -10%;
                width: 400px;
                height: 400px;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 50%;
            }
            .info-side::after {
                content: "";
                position: absolute;
                bottom: -5%;
                left: -5%;
                width: 250px;
                height: 250px;
                background: rgba(255, 255, 255, 0.08);
                border-radius: 50%;
            }

            .carousel-item {
                height: 400px;
            }

            .carousel-content {
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                height: 100%;
                text-align: center;
                z-index: 2; /* Keeps content above particles */
                position: relative;
            }

            .carousel-icon {
                font-size: 4.5rem;
                margin-bottom: 1.5rem;
                background: rgba(255,255,255,0.1);
                width: 130px;
                height: 130px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
                backdrop-filter: blur(8px);
                border: 1px solid rgba(255,255,255,0.2);
            }

            .carousel-indicators [data-bs-target] {
                background-color: var(--umt-gold);
                height: 5px;
                border-radius: 5px;
                width: 40px;
                z-index: 3;
            }

            /* --- RIGHT SIDE: LOGIN FORM --- */
            .login-side {
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
            }

            .login-card {
                width: 100%;
                max-width: 420px;
                padding: 40px 30px;
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.08);
                animation: fadeInUp 0.8s ease-out;
            }

            .form-control {
                padding: 12px 15px;
                border-radius: 10px;
                background-color: #f8f9fa;
                border: 2px solid #eee;
            }
            .form-control:focus {
                border-color: var(--umt-purple);
                background-color: #fff;
                box-shadow: none;
            }

            .input-group-text {
                border-radius: 10px 0 0 10px;
                border: 2px solid #eee;
                background-color: #f8f9fa;
            }

            /* Password Eye Icon Specific styling */
            #togglePassword {
                border-radius: 0 10px 10px 0;
                transition: 0.2s;
            }
            #togglePassword:hover {
                background-color: #e9ecef !important;
            }

            .btn-login {
                background: var(--umt-purple);
                color: white;
                padding: 12px;
                border-radius: 50px;
                font-weight: bold;
                letter-spacing: 1px;
                transition: 0.3s;
            }
            .btn-login:hover {
                background: var(--umt-blue);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0,0,128,0.25);
            }

            .hover-link {
                transition: 0.2s;
            }
            .hover-link:hover {
                color: var(--umt-purple) !important;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Mobile Responsive Adjustments */
            @media (max-width: 768px) {
                .info-side {
                    display: none;
                }
                .login-side {
                    width: 100%;
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>

        <div class="container-fluid main-container">
            <div class="row h-100">

                <%-- LEFT SIDE: THE FYP SYSTEM PITCH & PARTICLES --%>
                <div class="col-lg-7 info-side">

                    <%-- Interactive Particle Engine Canvas --%>
                    <div id="particles-js" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0; z-index: 1;"></div>

                    <div id="introCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="4000">

                        <div class="carousel-indicators">
                            <button type="button" data-bs-target="#introCarousel" data-bs-slide-to="0" class="active"></button>
                            <button type="button" data-bs-target="#introCarousel" data-bs-slide-to="1"></button>
                            <button type="button" data-bs-target="#introCarousel" data-bs-slide-to="2"></button>
                        </div>

                        <div class="carousel-inner">
                            <%-- SLIDE 1: Smart Drafting --%>
                            <div class="carousel-item active">
                                <div class="carousel-content">
                                    <div class="carousel-icon text-warning">
                                        <i class="fas fa-laptop-code"></i>
                                    </div>
                                    <h2 class="fw-bold mb-3 display-6">Smart Proposal Drafting</h2>
                                    <p class="lead opacity-75 px-5">Draft your event proposals with built-in AI risk assessments, automated financial calculations, and SDG alignment tools.</p>
                                </div>
                            </div>

                            <%-- SLIDE 2: Multi-Tier Approval --%>
                            <div class="carousel-item">
                                <div class="carousel-content">
                                    <div class="carousel-icon text-info">
                                        <i class="fas fa-project-diagram"></i>
                                    </div>
                                    <h2 class="fw-bold mb-3 display-6">Multi-Tier Approval Workflow</h2>
                                    <p class="lead opacity-75 px-5">A seamless, paperless routing engine connecting Club Advisors, MPP, Faculty Deans, and HEPA Executives for swift endorsements.</p>
                                </div>
                            </div>

                            <%-- SLIDE 3: Smart Diff & Tracking --%>
                            <div class="carousel-item">
                                <div class="carousel-content">
                                    <div class="carousel-icon text-success">
                                        <i class="fas fa-microscope"></i>
                                    </div>
                                    <h2 class="fw-bold mb-3 display-6">Smart Diff Audit Trail</h2>
                                    <p class="lead opacity-75 px-5">Track your application status in real-time with full transparency. Instantly see line-by-line budget modifications made by reviewers.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="text-center mt-5 opacity-50 small" style="z-index: 2; position: relative;">
                        &copy; 2026 Universiti Malaysia Terengganu • Student Club Proposal Management System (SCPMS)
                    </div>
                </div>

                <%-- RIGHT SIDE: SECURE LOGIN --%>
                <div class="col-lg-5 login-side">
                    <div class="login-card">
                        <div class="text-center mb-4">
                            <img src="${pageContext.request.contextPath}/images/Logo_Rasmi_UMT.png" alt="UMT Logo" width="90" class="mb-3">
                            <h4 class="fw-bold mb-1" style="color: var(--umt-purple);">SCPMS Portal</h4>
                            <p class="text-muted small fw-bold">Student Club Proposal Management System</p>
                        </div>

                        <%-- Error Message --%>
                        <c:if test="${not empty errorMessage and fn:trim(errorMessage) != ''}">
                            <div class="alert alert-danger d-flex align-items-center mb-4 shadow-sm border-0 small rounded-3" role="alert">
                                <i class="fas fa-exclamation-circle me-2 fs-5"></i>
                                <div>${errorMessage}</div>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-bold small text-muted ms-1">Email Address</label>
                                <div class="input-group shadow-sm">
                                    <span class="input-group-text"><i class="fas fa-envelope text-muted"></i></span>
                                    <input type="email" class="form-control border-start-0 ps-0" name="email" placeholder="user@ocean.umt.edu.my" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold small text-muted ms-1">Password</label>
                                <div class="input-group shadow-sm">
                                    <span class="input-group-text"><i class="fas fa-lock text-muted"></i></span>
                                    <input type="password" class="form-control border-start-0 border-end-0 ps-0" id="loginPassword" name="password" placeholder="••••••••" required>
                                    <span class="input-group-text bg-white" id="togglePassword" style="cursor: pointer;">
                                        <i class="fas fa-eye text-muted" id="eyeIcon"></i>
                                    </span>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-login w-100 mb-4 shadow">
                                Secure Sign In <i class="fas fa-sign-in-alt ms-2"></i>
                            </button>
                        </form>

                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none small text-muted hover-link fw-bold">
                                <i class="fas fa-key me-1"></i> Forgot your password?
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Scripts --%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>

        <script>
            // --- 1. PASSWORD REVEAL TOGGLE ---
            document.addEventListener("DOMContentLoaded", function () {
                const togglePassword = document.querySelector('#togglePassword');
                const password = document.querySelector('#loginPassword');
                const icon = document.querySelector('#eyeIcon');

                togglePassword.addEventListener('click', function (e) {
                    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                    password.setAttribute('type', type);

                    icon.classList.toggle('fa-eye');
                    icon.classList.toggle('fa-eye-slash');
                });
            });

            // --- 2. INTERACTIVE PARTICLE NETWORK ---
            if (window.innerWidth > 768) {
                particlesJS("particles-js", {
                    "particles": {
                        "number": {"value": 70, "density": {"enable": true, "value_area": 800}},
                        "color": {"value": "#ffffff"},
                        "shape": {"type": "circle"},
                        "opacity": {"value": 0.3, "random": true},
                        "size": {"value": 3, "random": true},
                        "line_linked": {
                            "enable": true,
                            "distance": 150,
                            "color": "#ffffff",
                            "opacity": 0.25,
                            "width": 1
                        },
                        "move": {
                            "enable": true,
                            "speed": 2,
                            "direction": "none",
                            "random": true,
                            "straight": false,
                            "out_mode": "out",
                            "bounce": false
                        }
                    },
                    "interactivity": {
                        "detect_on": "canvas",
                        "events": {
                            "onhover": {"enable": true, "mode": "grab"},
                            "onclick": {"enable": true, "mode": "push"},
                            "resize": true
                        },
                        "modes": {
                            "grab": {"distance": 180, "line_linked": {"opacity": 0.6}},
                            "push": {"particles_nb": 4}
                        }
                    },
                    "retina_detect": true
                });
            }
        </script>
    </body>
</html>