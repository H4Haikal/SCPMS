<%-- 
    Document   : MasterReports
    Purpose    : HEPA Executive Analytics Dashboard with Dynamic Filtering
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Master Analytics | UMT ClubSphere</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.bootstrap5.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            .kpi-card {
                transition: transform 0.2s;
                border: none;
                border-radius: 16px;
            }
            .kpi-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.08) !important;
            }
            .icon-circle {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }
            /* Override DataTables button margin */
            .dt-buttons .btn {
                margin-right: 0.5rem;
                border-radius: 8px;
                font-weight: 600;
                padding: 0.5rem 1.25rem;
                transition: all 0.2s;
            }
            .dt-buttons .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
            }
            .table-striped tbody tr:nth-of-type(odd) {
                background-color: #f8f9fa;
            }
            .chart-container {
                position: relative;
                height: 280px;
                width: 100%;
            }
            .filter-bar {
                background: #fff;
                border-radius: 50px;
                padding: 10px 20px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            }
        </style>
    </head>
    <body class="bg-light">

        <%@ include file="/WEB-INF/jsp/include/sidebar.jsp" %>

        <div class="main-content">
            <div class="container-fluid py-4 px-lg-4">

                <%-- Header --%>
                <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom border-2">
                    <div class="d-flex align-items-center">
                        <%-- The Sandwich Bar Toggle --%>
                        <button class="btn btn-light text-primary me-3 d-lg-none shadow-sm" id="sidebarToggle">
                            <i class="fas fa-bars fa-lg"></i>
                        </button>
                        <div>
                            <h3 class="fw-bold mb-0 text-primary"><i class="fas fa-chart-pie me-2"></i>Executive Analytics Hub</h3>
                            <p class="text-muted mb-0 mt-1">Real-time club performance and financial distribution.</p>
                        </div>
                    </div>
                    <div class="mt-3 mt-md-0">
                        <button class="btn btn-outline-primary rounded-pill fw-bold shadow-sm" onclick="window.print()">
                            <i class="fas fa-print me-2"></i>Print Dashboard
                        </button>
                    </div>
                </div>

                <%-- DYNAMIC GLOBAL FILTERS (For the Charts) --%>
                <div class="filter-bar mb-4 d-flex flex-wrap align-items-center gap-3 border">
                    <div class="fw-bold text-muted"><i class="fas fa-filter me-2"></i>Global Chart Filter:</div>

                    <select id="filterCategory" class="form-select border-0 bg-light rounded-pill w-auto fw-bold text-dark">
                        <option value="all">All Categories</option>
                        <option value="Academic">Academic</option>
                        <option value="Non-Academic">Non-Academic</option>
                    </select>

                    <select id="filterCluster" class="form-select border-0 bg-light rounded-pill w-auto fw-bold text-dark">
                        <option value="all">All Clusters</option>
                        <option value="Kelab Akademik">Kelab Akademik</option>
                        <option value="Kelab Keusahawanan">Kelab Keusahawanan</option>
                        <option value="Kelab Anak Negeri">Kelab Anak Negeri</option>
                        <option value="Kelab Sukan">Kelab Sukan</option>
                        <option value="Kelab Kebudayaan">Kelab Kebudayaan</option>
                        <option value="Kelab Eksekutif">Kelab Eksekutif</option>
                        <option value="Kelab Badan Beruniform">Kelab Badan Beruniform</option>
                        <option value="Kelab Sosial">Kelab Sosial</option>
                        <option value="Kelab Kerohanian">Kelab Kerohanian</option>
                    </select>
                </div>

                <%-- 1. KPI HERO CARDS --%>
                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-md-6">
                        <div class="card kpi-card shadow-sm bg-white h-100 p-3">
                            <div class="d-flex align-items-center">
                                <div class="icon-circle bg-primary bg-opacity-10 text-primary"><i class="fas fa-file-signature"></i></div>
                                <div class="ms-3">
                                    <h6 class="text-muted mb-0 fw-bold text-uppercase" style="font-size: 0.8rem;">Total Proposals</h6>
                                    <h3 class="fw-bold mb-0 text-dark" id="kpiTotal">0</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card kpi-card shadow-sm bg-white h-100 p-3 border-start border-4 border-success">
                            <div class="d-flex align-items-center">
                                <div class="icon-circle bg-success bg-opacity-10 text-success"><i class="fas fa-money-check-alt"></i></div>
                                <div class="ms-3">
                                    <h6 class="text-muted mb-0 fw-bold text-uppercase" style="font-size: 0.8rem;">Approved Budget</h6>
                                    <h3 class="fw-bold mb-0 text-dark" id="kpiBudget">RM 0</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card kpi-card shadow-sm bg-white h-100 p-3">
                            <div class="d-flex align-items-center">
                                <div class="icon-circle bg-warning bg-opacity-10 text-warning"><i class="fas fa-chart-line"></i></div>
                                <div class="ms-3">
                                    <h6 class="text-muted mb-0 fw-bold text-uppercase" style="font-size: 0.8rem;">Approval Rate</h6>
                                    <h3 class="fw-bold mb-0 text-dark" id="kpiRate">0%</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card kpi-card shadow-sm bg-white h-100 p-3 border-start border-4 border-info">
                            <div class="d-flex align-items-center">
                                <div class="icon-circle bg-info bg-opacity-10 text-info"><i class="fas fa-trophy"></i></div>
                                <div class="ms-3 w-100 overflow-hidden">
                                    <h6 class="text-muted mb-0 fw-bold text-uppercase" style="font-size: 0.8rem;">Top Active Club</h6>
                                    <h5 class="fw-bold mb-0 text-dark text-truncate" id="kpiTopClub">-</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 2. VISUAL CHARTS ROW --%>
                <div class="row g-4 mb-5">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-header bg-white border-0 pt-4 pb-0">
                                <h5 class="fw-bold text-dark"><i class="fas fa-medal text-warning me-2"></i>Top 5 Clubs by Activity</h5>
                                <p class="text-muted small">Clubs with the most proposals submitted in the selected filter.</p>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="topClubsChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-header bg-white border-0 pt-4 pb-0">
                                <h5 class="fw-bold text-dark"><i class="fas fa-chart-pie text-info me-2"></i>Status Pipeline</h5>
                                <p class="text-muted small">Distribution of outcomes.</p>
                            </div>
                            <div class="card-body d-flex justify-content-center align-items-center">
                                <div class="chart-container" style="width: 85%;">
                                    <canvas id="statusChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 3. THE MASTER DATA TABLE WITH CUSTOM CONTROLS --%>
                <div class="card border-0 shadow-sm rounded-4 mb-5 overflow-hidden">

                    <%-- Custom Table Controls Header --%>
                    <div class="card-header bg-dark text-white py-3 d-flex flex-wrap justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0"><i class="fas fa-database me-2"></i>Master Database Directory</h5>

                        <div class="d-flex gap-2 mt-3 mt-md-0">
                            <!--                            <select id="tableSortControl" class="form-select form-select-sm bg-dark text-white border-secondary rounded-pill fw-medium" style="width: auto;">
                                                            <option value="dateDesc">📅 Sort: Latest to Oldest</option>
                                                            <option value="dateAsc">📅 Sort: Oldest to Latest</option>
                                                            <option value="budgetDesc">💰 Sort: Highest Budget</option>
                                                        </select>-->

                            <select id="tableStatusControl" class="form-select form-select-sm bg-dark text-white border-secondary rounded-pill fw-medium" style="width: auto;">
                                <option value="">Filter: All Statuses</option>
                                <option value="Approved">Filter: Approved Only</option>
                                <option value="Pending">Filter: Pending Only</option>
                                <option value="Rejected">Filter: Rejected Only</option>
                            </select>
                        </div>
                    </div>

                    <div class="card-body p-4">
                        <div class="table-responsive">
                            <table id="reportTable" class="table table-striped table-hover align-middle w-100">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Club Name</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Category & Cluster</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Program Title</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Budget (RM)</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Submission Date</th>
                                        <th class="text-secondary fw-bold small text-uppercase border-0">Final Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${allProposals}">
                                        <tr>
                                            <td><span class="fw-bold text-dark">${p.clubName}</span></td>
                                            <td>
                                                <span class="badge ${p.category == 'Academic' ? 'bg-primary' : 'bg-secondary'} rounded-pill shadow-sm mb-1 d-inline-block">
                                                    ${p.category}
                                                </span><br>
                                                <small class="text-muted fw-bold">${p.cluster}</small>
                                            </td>
                                            <td class="text-dark fw-medium">${p.title}</td>
                                            <td class="fw-bold text-success"><fmt:formatNumber value="${p.budget}" pattern="#,##0.00" /></td>
                                            <td>
                                                <span class="d-none"><fmt:formatDate value="${p.proposedDate}" pattern="yyyyMMdd" /></span>
                                                <div class="text-muted fw-bold"><fmt:formatDate value="${p.proposedDate}" pattern="dd MMM yyyy" /></div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.status == 'Approved'}"><span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-2 rounded-pill"><i class="fas fa-check-circle me-1"></i> Approved</span></c:when>
                                                    <c:when test="${p.status == 'Rejected'}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-3 py-2 rounded-pill"><i class="fas fa-times-circle me-1"></i> Rejected</span></c:when>
                                                    <c:otherwise><span class="badge bg-warning bg-opacity-10 text-dark border border-warning px-3 py-2 rounded-pill"><i class="fas fa-spinner fa-spin me-1"></i> ${p.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%-- External Libraries --%>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
                            // --- SIDEBAR SANDWICH TOGGLE ---
                            $('#sidebarToggle').on('click', function () {
                                $('.sidebar').toggleClass('active show');
                            });
                            $(document).ready(function () {

                                // --- 1. EXTRACT DATA FROM JSTL ONCE ---
                                const rawData = [];

            <%-- Define our quotes as variables to prevent JSP EL syntax errors --%>
            <c:set var="dq" value='"' />
            <c:set var="slashDq" value='\\"' />

            <c:forEach var="p" items="${allProposals}">
                                rawData.push({
                                    club: "${fn:replace(p.clubName, dq, slashDq)}",
                                    category: "${p.category}",
                                    cluster: "${p.cluster}",
                                    budget: parseFloat(${p.budget}) || 0,
                                    status: "${p.status}"
                                });
            </c:forEach>

                                // Global variables to hold chart instances
                                let statusChartInstance = null;
                                let topClubsChartInstance = null;

                                // --- 2. DYNAMIC RENDERING FUNCTION ---
                                function renderAnalyticsDashboard() {
                                    const filterCat = $('#filterCategory').val();
                                    const filterCluster = $('#filterCluster').val();

                                    const filteredData = rawData.filter(item => {
                                        let matchCat = (filterCat === 'all') ? true : (item.category === filterCat);

                                        let matchCluster = true;
                                        if (filterCluster !== 'all') {
                                            let rawDataCluster = item.cluster ? item.cluster.toLowerCase() : "";
                                            let rawSearchCluster = filterCluster.toLowerCase();

                                            let cleanData = rawDataCluster.replace("kelab", "").trim();
                                            let cleanSearch = rawSearchCluster.replace("kelab", "").trim();

                                            if (cleanData === "") {
                                                matchCluster = false;
                                            } else {
                                                matchCluster = cleanData.includes(cleanSearch) || cleanSearch.includes(cleanData);
                                            }
                                        }
                                        return matchCat && matchCluster;
                                    });

                                    // Variables for computation
                                    let totalProposals = filteredData.length;
                                    let approvedBudget = 0;
                                    let approvedCount = 0;
                                    let rejectedCount = 0;
                                    let pendingCount = 0;
                                    let clubCounts = {};

                                    // Crunch the filtered data
                                    filteredData.forEach(item => {
                                        if (item.status === 'Approved') {
                                            approvedCount++;
                                            approvedBudget += item.budget;
                                        } else if (item.status === 'Rejected') {
                                            rejectedCount++;
                                        } else {
                                            pendingCount++;
                                        }
                                        // Club activity
                                        clubCounts[item.club] = (clubCounts[item.club] || 0) + 1;
                                    });

                                    // Update KPI Cards
                                    let approvalRate = totalProposals > 0 ? Math.round((approvedCount / totalProposals) * 100) : 0;
                                    let topClub = "No Data";
                                    let maxEvents = 0;

                                    for (const [club, count] of Object.entries(clubCounts)) {
                                        if (count > maxEvents) {
                                            maxEvents = count;
                                            topClub = club;
                                        }
                                    }

                                    // Animate text changes
                                    $('#kpiTotal').fadeOut(150, function () {
                                        $(this).text(totalProposals).fadeIn(150);
                                    });
                                    $('#kpiBudget').fadeOut(150, function () {
                                        $(this).text("RM " + approvedBudget.toLocaleString('en-MY', {minimumFractionDigits: 2})).fadeIn(150);
                                    });
                                    $('#kpiRate').fadeOut(150, function () {
                                        $(this).text(approvalRate + "%").fadeIn(150);
                                    });
                                    $('#kpiTopClub').fadeOut(150, function () {
                                        $(this).text(topClub).fadeIn(150);
                                    });

                                    // --- DRAW STATUS DOUGHNUT CHART ---
                                    if (statusChartInstance)
                                        statusChartInstance.destroy();
                                    const ctxStatus = document.getElementById('statusChart').getContext('2d');

                                    if (totalProposals === 0) {
                                        statusChartInstance = new Chart(ctxStatus, {
                                            type: 'doughnut',
                                            data: {labels: ['No Data'], datasets: [{data: [1], backgroundColor: ['#e9ecef']}]},
                                            options: {plugins: {tooltip: {enabled: false}}, cutout: '70%'}
                                        });
                                    } else {
                                        statusChartInstance = new Chart(ctxStatus, {
                                            type: 'doughnut',
                                            data: {
                                                labels: ['Approved', 'Pending', 'Rejected'],
                                                datasets: [{
                                                        data: [approvedCount, pendingCount, rejectedCount],
                                                        backgroundColor: ['#198754', '#ffc107', '#dc3545'],
                                                        borderWidth: 0, hoverOffset: 4
                                                    }]
                                            },
                                            options: {responsive: true, maintainAspectRatio: false, plugins: {legend: {position: 'bottom'}}, cutout: '70%'}
                                        });
                                    }

                                    // --- DRAW TOP CLUBS BAR CHART ---
                                    if (topClubsChartInstance)
                                        topClubsChartInstance.destroy();
                                    const ctxClubs = document.getElementById('topClubsChart').getContext('2d');

                                    const sortedClubs = Object.entries(clubCounts).sort((a, b) => b[1] - a[1]).slice(0, 5);
                                    const clubNames = sortedClubs.map(item => item[0].length > 20 ? item[0].substring(0, 20) + '...' : item[0]);
                                    const clubScores = sortedClubs.map(item => item[1]);

                                    topClubsChartInstance = new Chart(ctxClubs, {
                                        type: 'bar',
                                        data: {
                                            labels: clubNames.length > 0 ? clubNames : ['No Data'],
                                            datasets: [{
                                                    label: 'Proposals Submitted',
                                                    data: clubScores.length > 0 ? clubScores : [0],
                                                    backgroundColor: '#0d6efd', borderRadius: 6
                                                }]
                                        },
                                        options: {
                                            responsive: true, maintainAspectRatio: false, plugins: {legend: {display: false}},
                                            scales: {
                                                y: {beginAtZero: true, ticks: {stepSize: 1, precision: 0}},
                                                x: {grid: {display: false}}
                                            }
                                        }
                                    });
                                }

                                // --- 3. INITIALIZE CHARTS ---
                                renderAnalyticsDashboard();

                                $('#filterCategory, #filterCluster').on('change', function () {
                                    renderAnalyticsDashboard();
                                });

                                // --- 4. INITIALIZE DATA TABLES WITH NEW BUTTONS ---
                                const reportTable = $('#reportTable').DataTable({
                                    dom: '<"row mb-4 align-items-center"<"col-md-7"B><"col-md-5 text-md-end"f>>rt<"row mt-4"<"col-md-6 text-muted small"i><"col-md-6"p>>',
                                    buttons: [
                                        {
                                            extend: 'excelHtml5',
                                            text: '<i class="fas fa-file-excel me-1"></i> Excel',
                                            className: 'btn btn-success text-white shadow-sm',
                                            title: 'UMT_ClubSphere_Master_Report'
                                        },
                                        {
                                            extend: 'pdfHtml5',
                                            text: '<i class="fas fa-file-pdf me-1"></i> PDF',
                                            className: 'btn btn-danger text-white shadow-sm',
                                            title: 'UMT_ClubSphere_Master_Report',
                                            orientation: 'landscape',
                                            pageSize: 'A4'
                                        },
                                        {
                                            extend: 'print',
                                            text: '<i class="fas fa-print me-1"></i> Print',
                                            className: 'btn btn-primary text-white shadow-sm'
                                        }
                                    ],
                                    "pageLength": 10,
                                    "order": [[4, "desc"]], // Default sort: Date (Newest)
                                    "language": {"search": "", "searchPlaceholder": "Search anywhere..."}
                                });

                                // --- 5. CUSTOM TABLE CONTROLS (Sorting & Status) ---
                                $('#tableSortControl').on('change', function () {
                                    let sortType = $(this).val();
                                    if (sortType === 'dateDesc')
                                        reportTable.order([4, 'desc']).draw();
                                    if (sortType === 'dateAsc')
                                        reportTable.order([4, 'asc']).draw();
                                    if (sortType === 'budgetDesc')
                                        reportTable.order([3, 'desc']).draw();
                                });

                                $('#tableStatusControl').on('change', function () {
                                    let status = $(this).val();
                                    // Column Index 5 is the 'Final Status' column
                                    reportTable.column(5).search(status).draw();
                                });

                                // --- 6. SIDEBAR SANDWICH TOGGLE ---
                                $('#sidebarToggle').on('click', function () {
                                    $('.sidebar').toggleClass('active show');
                                });
                            });
        </script>
    </body>
</html>