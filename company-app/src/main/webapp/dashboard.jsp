<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String token = (String) session.getAttribute("token");
if (token == null || token.isEmpty()) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Kompanija</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            background-color: #eef2f5;
        }
        .navbar { background-color: #7DAACB !important; }
        .dashboard-wrapper {
            min-height: calc(100vh - 56px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .dashboard-card {
            border: none;
            border-radius: 14px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            background-color: #ffffff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            min-height: 150px;
        }
        .dashboard-card:hover {
            box-shadow: 0 8px 20px rgba(125, 170, 203, 0.35);
        }
        .card-title-text {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.2rem;
        }
        .card-desc {
            color: #888;
            font-size: 0.95rem;
            margin-bottom: 0;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark">
    <div class="container">
        <span class="navbar-brand fw-semibold">Upravljanje praksama</span>
        <a href="logout.jsp" class="btn btn-outline-light btn-sm">Odjava</a>
    </div>
</nav>

<div class="dashboard-wrapper">
    <div class="container">
        <div class="row g-3 justify-content-center" style="max-width: 700px; margin: 0 auto;">

            <div class="col-12 col-sm-6">
                <a href="internships.jsp" class="text-decoration-none">
                    <div class="card dashboard-card text-center p-5 h-100">
                        <div class="card-title-text">Prakse</div>
                        <p class="card-desc">Upravljanje praksama</p>
                    </div>
                </a>
            </div>

            <div class="col-12 col-sm-6">
                <a href="applications.jsp" class="text-decoration-none">
                    <div class="card dashboard-card text-center p-5 h-100">
                        <div class="card-title-text">Prijave studenata</div>
                        <p class="card-desc">Pregled i odlučivanje</p>
                    </div>
                </a>
            </div>

            <div class="col-12 col-sm-6">
                <a href="worklogs.jsp" class="text-decoration-none">
                    <div class="card dashboard-card text-center p-5 h-100">
                        <div class="card-title-text">Dnevnici rada</div>
                        <p class="card-desc">Pregled i komentarisanje</p>
                    </div>
                </a>
            </div>

            <div class="col-12 col-sm-6">
                <a href="change-password.jsp" class="text-decoration-none">
                    <div class="card dashboard-card text-center p-5 h-100">
                        <div class="card-title-text">Promjena lozinke</div>
                        <p class="card-desc">Sigurnost naloga</p>
                    </div>
                </a>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>