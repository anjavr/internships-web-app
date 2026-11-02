<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.dto.InternshipDTO"%>
<%@ page import="com.praksa.beans.InternshipBean"%>
<%@ page import="java.time.LocalDate"%>
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
            if (end != null && now.isAfter(end)) return "finished";
            if (start != null && now.isBefore(start)) return "upcoming";
            return "ongoing";
        } catch (Exception e) {
            return "ongoing";
        }
    }
%>
<%
if (session.getAttribute("token") == null) {
    response.sendRedirect("MainController");
    return;
}

InternshipDTO internship = internshipBean.getInternship();
if (internship == null) {
    response.sendRedirect("MainController?action=internships");
    return;
}

String status = getInternshipStatus(internship);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= internship.getTitle() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body { background-color: #eef2f5; }
        .navbar { background-color: #7DAACB !important; }
        .card { border: none; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .info-label { font-size: 0.78rem; color: #888; text-transform: uppercase; letter-spacing: 0.05em; }
        .info-value { font-weight: 600; color: #2c3e50; font-size: 0.95rem; }
        .section-title { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em; color: #7DAACB; font-weight: 600; }
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
    <div class="row justify-content-center">
        <div class="col-12 col-md-9">

            <div class="card">
                <div class="card-body p-4">

                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <h5 class="fw-semibold mb-1"><%= internship.getTitle() %></h5>
                            <span class="text-muted"><%= internship.getCompanyName() != null ? internship.getCompanyName() : "" %></span>
                        </div>
                        <% if ("upcoming".equals(status)) { %>
                            <span class="badge bg-primary">Nadolazeća</span>
                        <% } else if ("ongoing".equals(status)) { %>
                            <span class="badge bg-success">U toku</span>
                        <% } else { %>
                            <span class="badge bg-danger">Završena</span>
                        <% } %>
                    </div>

                    <hr>

                    <div class="row g-3 mb-3">
                        <div class="col-6 col-md-3">
                            <div class="info-label">Lokacija</div>
                            <div class="info-value"><%= internship.getLocation() != null ? internship.getLocation() : "-" %></div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="info-label">Tip rada</div>
                            <div class="info-value"><%= formatWorkType(internship.getWorkType()) %></div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="info-label">Početak</div>
                            <div class="info-value"><%= formatDate(internship.getStartDate()) %></div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="info-label">Kraj</div>
                            <div class="info-value"><%= formatDate(internship.getEndDate()) %></div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="info-label">Slobodna mjesta</div>
                            <div class="info-value"><%= internship.getTakenPositions() %> / <%= internship.getPositions() %></div>
                        </div>
                        <% if (internship.getRequiredYear() != null) { %>
                        <div class="col-6 col-md-3">
                            <div class="info-label">Godina studija</div>
                            <div class="info-value"><%= internship.getRequiredYear() %></div>
                        </div>
                        <% } %>
                    </div>

                    <hr>

                    <% if (internship.getShortDesc() != null && !internship.getShortDesc().isEmpty()) { %>
                    <div class="mb-3">
                        <div class="section-title mb-2">Kratki opis</div>
                        <p class="mb-0 text-secondary"><%= internship.getShortDesc() %></p>
                    </div>
                    <% } %>

                    <% if (internship.getTechnologies() != null && !internship.getTechnologies().isEmpty()) { %>
                    <div class="mb-3">
                        <div class="section-title mb-2">Tehnologije</div>
                        <p class="mb-0 text-secondary"><%= internship.getTechnologies() %></p>
                    </div>
                    <% } %>

                    <hr>

                    <a href="MainController?action=internships" class="btn btn-secondary btn-sm">Nazad</a>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>