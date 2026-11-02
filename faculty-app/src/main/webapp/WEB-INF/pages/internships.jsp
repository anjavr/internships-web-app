<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="com.praksa.dto.InternshipDTO"%>
<%@ page import="com.praksa.beans.InternshipBean"%>
<jsp:useBean class="com.praksa.beans.InternshipBean" id="internshipBean" scope="session"/>
<%!
    private String formatDate(java.time.LocalDate date) {
        if (date == null) return "-";
        return date.format(java.time.format.DateTimeFormatter.ofPattern("dd.MM.yyyy"));
    }

    private String formatWorkType(String workType) {
        if (workType == null) return "-";
        switch (workType) {
            case "REMOTE": return "Rad od kuće";
            case "ON_SITE": return "Na licu mjesta";
            case "HYBRID": return "Hibridni";
            default: return workType;
        }
    }

    private String getInternshipStatus(InternshipDTO i) {
        try {
            java.time.LocalDate now = java.time.LocalDate.now();
            java.time.LocalDate start = i.getStartDate();
            java.time.LocalDate end = i.getEndDate();
            if (start != null && now.isBefore(start)) return "upcoming";
            if (end != null && now.isAfter(end)) return "finished";
            return "active";
        } catch (Exception e) {
            return "active";
        }
    }

    private boolean isIstorija(InternshipDTO i) {
        return "finished".equals(getInternshipStatus(i));
    }
%>
<%
if (session.getAttribute("token") == null) {
    response.sendRedirect("MainController");
    return;
}

List<InternshipDTO> allInternships = internshipBean.getInternships();
System.out.println("ALL INTERNSHIPS: " + (allInternships != null ? allInternships.size() : "NULL"));

List<InternshipDTO> aktuelne = new ArrayList<>();
List<InternshipDTO> istorija = new ArrayList<>();

if (allInternships != null) {
    for (InternshipDTO i : allInternships) {
        if (isIstorija(i)) {
            istorija.add(i);
        } else {
            aktuelne.add(i);
        }
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prakse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body { background-color: #eef2f5; }
        .navbar { background-color: #7DAACB !important; }
        .card { border: none; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .table thead { background-color: #7DAACB; color: white; }
        .btn-primary { background-color: #7DAACB; border-color: #7DAACB; }
        .btn-primary:hover { background-color: #5a8aad; border-color: #5a8aad; }
        .nav-tabs .nav-link.active { border-bottom: 3px solid #7DAACB; color: #7DAACB; font-weight: 600; }
        .nav-tabs .nav-link { color: #666; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark">
    <div class="container">
        <a class="navbar-brand fw-semibold" href="MainController?action=welcome">Upravljanje praksama</a>
        <a href="MainController?action=logout" class="btn btn-outline-light btn-sm">Odjava</a>
    </div>
</nav>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-semibold text-secondary">Pregled praksi</h5>
    </div>

    <% if (session.getAttribute("notification") != null) { %>
        <div class="alert alert-info alert-dismissible fade show">
            <%= session.getAttribute("notification") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("notification"); %>
    <% } %>

    <ul class="nav nav-tabs mb-3" id="prakseTabs">
        <li class="nav-item">
            <a class="nav-link active" id="tab-aktuelne" href="#" onclick="switchTab('aktuelne'); return false;">
                Aktuelne
                <span class="badge bg-success ms-1"><%= aktuelne.size() %></span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-istorija" href="#" onclick="switchTab('istorija'); return false;">
                Istorija
                <span class="badge bg-secondary ms-1"><%= istorija.size() %></span>
            </a>
        </li>
    </ul>

    <div id="panel-aktuelne">
        <div class="card p-3">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Kompanija</th>
                            <th>Naziv</th>
                            <th>Lokacija</th>
                            <th>Tip rada</th>
                            <th>Period</th>
                            <th>Mjesta</th>
                            <th>Status</th>
                            <th>Akcije</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (!aktuelne.isEmpty()) {
                            for (InternshipDTO i : aktuelne) {
                                String status = getInternshipStatus(i);
                        %>
                        <tr>
                            <td><%= i.getCompanyName() != null ? i.getCompanyName() : "-" %></td>
                            <td><%= i.getTitle() %></td>
                            <td><%= i.getLocation() != null ? i.getLocation() : "-" %></td>
                            <td><%= formatWorkType(i.getWorkType()) %></td>
                            <td><%= formatDate(i.getStartDate()) %> – <%= formatDate(i.getEndDate()) %></td>
                            <td><%= i.getTakenPositions() %> / <%= i.getPositions() %></td>
                            <td>
                                <% if ("upcoming".equals(status)) { %>
                                    <span class="badge bg-primary">Nadolazeća</span>
                                <% } else { %>
                                    <span class="badge bg-success">Aktivna</span>
                                <% } %>
                            </td>
                            <td>
                                <a href="MainController?action=internship&id=<%= i.getId() %>"
                                   class="btn btn-primary btn-sm">Detalji</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-3">Nema aktuelnih praksi</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="panel-istorija" style="display:none;">
        <div class="card p-3">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Kompanija</th>
                            <th>Naziv</th>
                            <th>Lokacija</th>
                            <th>Tip rada</th>
                            <th>Period</th>
                            <th>Mjesta</th>
                            <th>Status</th>
                            <th>Akcije</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (!istorija.isEmpty()) {
                            for (InternshipDTO i : istorija) {
                        %>
                        <tr>
                            <td><%= i.getCompanyName() != null ? i.getCompanyName() : "-" %></td>
                            <td><%= i.getTitle() %></td>
                            <td><%= i.getLocation() != null ? i.getLocation() : "-" %></td>
                            <td><%= formatWorkType(i.getWorkType()) %></td>
                            <td><%= formatDate(i.getStartDate()) %> – <%= formatDate(i.getEndDate()) %></td>
                            <td><%= i.getTakenPositions() %> / <%= i.getPositions() %></td>
                            <td><span class="badge bg-danger">Završena</span></td>
                            <td>
                                <a href="MainController?action=internship&id=<%= i.getId() %>"
                                   class="btn btn-primary btn-sm">Detalji</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="8" class="text-center text-muted py-3">Nema podataka</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <a href="MainController?action=welcome" class="btn btn-secondary btn-sm mt-3">Nazad</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function switchTab(tab) {
        document.getElementById('panel-aktuelne').style.display = tab === 'aktuelne' ? 'block' : 'none';
        document.getElementById('panel-istorija').style.display = tab === 'istorija' ? 'block' : 'none';
        document.getElementById('tab-aktuelne').classList.toggle('active', tab === 'aktuelne');
        document.getElementById('tab-istorija').classList.toggle('active', tab === 'istorija');
    }
</script>
</body>
</html>