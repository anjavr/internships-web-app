<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.InternshipService"%>
<%@ page import="com.praksa.dto.InternshipDTO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%!
    private String formatDate(String date) {
        if (date == null || date.isEmpty()) return "-";
        try {
            return LocalDate.parse(date).format(DateTimeFormatter.ofPattern("dd.MM.yyyy"));
        } catch (Exception e) {
            return date;
        }
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

    private String getStatus(String startDate, String endDate) {
        if (startDate == null || endDate == null) return "upcoming";
        try {
            LocalDate now = LocalDate.now();
            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);
            if (now.isBefore(start)) return "upcoming";
            if (now.isAfter(end)) return "finished";
            return "active";
        } catch (Exception e) {
            return "upcoming";
        }
    }
%>
<%
String token = (String) session.getAttribute("token");
String companyId = (String) session.getAttribute("companyId");
if (token == null || token.isEmpty()) {
    response.sendRedirect("login.jsp");
    return;
}

InternshipService internshipService = new InternshipService();
List<InternshipDTO> internships = internshipService.getByCompany(companyId, token);
if (internships != null) {
    internships.sort((a, b) -> {
        if (a.getStartDate() == null) return 1;
        if (b.getStartDate() == null) return -1;
        return LocalDate.parse(b.getStartDate()).compareTo(LocalDate.parse(a.getStartDate()));
    });
}

String notification = (String) session.getAttribute("notification");
session.removeAttribute("notification");
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
        .btn-primary { background-color: #7DAACB; border-color: #7DAACB; }
        .btn-primary:hover { background-color: #5a8aad; border-color: #5a8aad; }
        .internship-card { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .internship-card:hover { transform: translateY(-3px); box-shadow: 0 6px 16px rgba(125, 170, 203, 0.3) !important; }
        .info-label { font-size: 0.75rem; color: #888; text-transform: uppercase; letter-spacing: 0.04em; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark">
    <div class="container">
        <a class="navbar-brand fw-semibold" href="dashboard.jsp">Upravljanje praksama</a>
        <a href="logout.jsp" class="btn btn-outline-light btn-sm">Odjava</a>
    </div>
</nav>

<div class="container mt-4">

    <% if (notification != null) { %>
        <div class="alert alert-info alert-dismissible fade show">
            <%= notification %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-semibold text-secondary">Upravljanje praksama</h5>
        <a href="internship-form.jsp" class="btn btn-success btn-sm">+ Nova praksa</a>
    </div>

    <div class="row g-3">
        <% if (internships != null && !internships.isEmpty()) {
            for (InternshipDTO i : internships) {
                String status = getStatus(i.getStartDate(), i.getEndDate());
        %>
        <div class="col-12 col-sm-6 col-lg-4">
            <div class="card internship-card h-100">
                <div class="card-body d-flex flex-column p-3">

                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <h6 class="fw-semibold mb-0"><%= i.getTitle() %></h6>
                        <% if ("finished".equals(status)) { %>
                            <span class="badge bg-danger ms-2">Završena</span>
                        <% } else if ("active".equals(status)) { %>
                            <span class="badge bg-success ms-2">Aktivna</span>
                        <% } else { %>
                            <span class="badge bg-primary ms-2">Nadolazeća</span>
                        <% } %>
                    </div>

                    <p class="text-muted small mb-3">
                        <%= i.getShortDesc() != null ? i.getShortDesc() : "" %>
                    </p>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <div class="info-label">Tehnologije</div>
                            <div class="small"><%= i.getTechnologies() != null ? i.getTechnologies() : "-" %></div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">Tip rada</div>
                            <div class="small"><%= formatWorkType(i.getWorkType()) %></div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">Početak</div>
                            <div class="small"><%= formatDate(i.getStartDate()) %></div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">Kraj</div>
                            <div class="small"><%= formatDate(i.getEndDate()) %></div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">Lokacija</div>
                            <div class="small"><%= i.getLocation() != null ? i.getLocation() : "-" %></div>
                        </div>
                        <div class="col-6">
                            <div class="info-label">Mjesta</div>
                            <div class="small"><%= i.getTakenPositions() %> / <%= i.getPositions() %></div>
                        </div>
                        <div class="col-12">
                            <div class="info-label">Rok prijave</div>
                            <%
    String deadlineClass = "text-danger";
    if (i.getApplicationDeadline() != null && !i.getApplicationDeadline().isEmpty()) {
        try {
            if (!LocalDate.parse(i.getApplicationDeadline()).isBefore(LocalDate.now())) {
                deadlineClass = "text-success";
            }
        } catch (Exception e) {}
    }
%>
<div class="small <%= deadlineClass %>">
    <%= formatDate(i.getApplicationDeadline()) %>
</div>
                        </div>
                    </div>

                    <div class="mt-auto d-flex gap-2">
                        <% if (!"finished".equals(status)) { %>
                            <a href="internship-form.jsp?id=<%= i.getId() %>"
                               class="btn btn-warning btn-sm">Uredi</a>
                            <button type="button" class="btn btn-danger btn-sm"
                                    data-bs-toggle="modal"
                                    data-bs-target="#deleteModal"
                                    data-id="<%= i.getId() %>"
                                    data-name="<%= i.getTitle() %>">
                                Obriši
                            </button>
                        <% } else { %>
                            <a href="internship-form.jsp?id=<%= i.getId() %>"
                               class="btn btn-secondary btn-sm">Detalji</a>
                            <button type="button" class="btn btn-danger btn-sm"
                                    data-bs-toggle="modal"
                                    data-bs-target="#deleteModal"
                                    data-id="<%= i.getId() %>"
                                    data-name="<%= i.getTitle() %>">
                                Obriši
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        <%
            }
        } else { %>
        <div class="col-12">
            <div class="alert alert-info">Nema praksi.</div>
        </div>
        <% } %>
    </div>

    <a href="dashboard.jsp" class="btn btn-secondary btn-sm mt-3">Nazad</a>
</div>

<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 14px; border: none;">
            <div class="modal-header" style="background-color: #dc3545; color: white; border-radius: 14px 14px 0 0;">
                <h5 class="modal-title">Potvrda brisanja</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p id="deleteMessage" class="mb-0"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Odustani</button>
                <a id="deleteBtn" href="#" class="btn btn-danger btn-sm">Obriši</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('deleteModal').addEventListener('show.bs.modal', function(event) {
        var button = event.relatedTarget;
        var id = button.getAttribute('data-id');
        var name = button.getAttribute('data-name');
        document.getElementById('deleteMessage').textContent =
            'Da li ste sigurni da želite obrisati praksu "' + name + '"?';
        document.getElementById('deleteBtn').href = 'delete-internship.jsp?id=' + id;
    });
</script>
</body>
</html>