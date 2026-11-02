<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.StudentService"%>
<%@ page import="com.praksa.dto.*"%>
<%@ page import="java.util.List"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%
String token = (String) session.getAttribute("token");
if (token == null || token.isEmpty()) {
    response.sendRedirect("login.jsp");
    return;
}

String studentId = request.getParameter("studentId");
StudentService studentService = new StudentService();
StudentDTO student = studentService.getById(studentId, token);

EuropassJson europass = null;
if (student.getEuropassJson() != null && !student.getEuropassJson().isEmpty()) {
    ObjectMapper mapper = new ObjectMapper();
    europass = mapper.readValue(student.getEuropassJson(), EuropassJson.class);
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CV — <%= student.getFullName() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html, body { background-color: #eef2f5; }
        .navbar { background-color: #7DAACB !important; }
        .card { border: none; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .section-title { color: #7DAACB; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em; font-weight: 600; border-bottom: 2px solid #7DAACB; padding-bottom: 4px; margin-bottom: 16px; }
        .info-label { font-size: 0.75rem; color: #888; text-transform: uppercase; }
        .skill-badge { background: #e8f4fd; color: #1565c0; padding: 4px 12px; border-radius: 12px; font-size: 13px; display: inline-block; margin: 2px; }
        .level-badge { background: #e8f5e9; color: #2e7d32; padding: 2px 8px; border-radius: 8px; font-size: 11px; margin-left: 4px; }
        .interest-badge { background: #fff3e0; color: #e65100; padding: 4px 12px; border-radius: 12px; font-size: 13px; display: inline-block; margin: 2px; }
        .timeline-item { border-left: 3px solid #7DAACB; padding-left: 16px; margin-bottom: 20px; }
        .photo-circle { width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid #7DAACB; }
        .photo-placeholder { width: 100px; height: 100px; border-radius: 50%; background: #e0e0e0; display: flex; align-items: center; justify-content: center; font-size: 40px; color: #9e9e9e; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark">
    <div class="container">
        <a class="navbar-brand fw-semibold" href="dashboard.jsp">Upravljanje praksama</a>
        <div class="d-flex gap-2">
            <a href="download-cv.jsp?studentId=<%= studentId %>"
   				class="btn btn-light btn-sm"
   				download>
   				 <i class="bi bi-file-earmark-pdf me-1"></i> Preuzmi PDF
			</a>
            <a href="logout.jsp" class="btn btn-outline-light btn-sm">Odjava</a>
        </div>
    </div>
</nav>

<div class="container py-4">
    <div class="row g-4">

        <div class="col-12 col-md-4">

            <div class="card p-4 text-center mb-3">
                <% if (student.getPhotoPath() != null && !student.getPhotoPath().isEmpty()) { %>
                    <img src="http://localhost:8080/<%= student.getPhotoPath() %>"
                         alt="Foto" class="photo-circle mx-auto mb-3">
                <% } else { %>
                    <div class="photo-placeholder mx-auto mb-3">
                        <i class="bi bi-person"></i>
                    </div>
                <% } %>
                <h5 class="fw-semibold mb-1"><%= student.getFullName() %></h5>
                <p class="text-muted small mb-0"><%= student.getEmail() != null ? student.getEmail() : "" %></p>
            </div>

            <div class="card p-4 mb-3">
                <div class="section-title">Kontakt</div>
                <% if (student.getPhone() != null && !student.getPhone().isEmpty()) { %>
                <div class="mb-2">
                    <div class="info-label">Telefon</div>
                    <div><%= student.getPhone() %></div>
                </div>
                <% } %>
                <% if (student.getAddress() != null && !student.getAddress().isEmpty()) { %>
                <div class="mb-2">
                    <div class="info-label">Adresa</div>
                    <div><%= student.getAddress() %></div>
                </div>
                <% } %>
            </div>

            <% if (student.getSkills() != null && !student.getSkills().isEmpty()) { %>
            <div class="card p-4 mb-3">
                <div class="section-title">Vještine</div>
                <% for (SkillDTO skill : student.getSkills()) { %>
                    <div class="mb-1">
                        <span class="skill-badge"><%= skill.getName() %></span>
                        <span class="level-badge"><%= skill.getLevel() %></span>
                    </div>
                <% } %>
            </div>
            <% } %>

            <% if (student.getInterests() != null && !student.getInterests().isEmpty()) { %>
            <div class="card p-4">
                <div class="section-title">Interesovanja</div>
                <% for (InterestDTO interest : student.getInterests()) { %>
                    <span class="interest-badge"><%= interest.getName() %></span>
                <% } %>
            </div>
            <% } %>

        </div>

        <div class="col-12 col-md-8">

            <% if (student.getSummary() != null && !student.getSummary().isEmpty()) { %>
            <div class="card p-4 mb-3">
                <div class="section-title">O meni</div>
                <p class="mb-0"><%= student.getSummary() %></p>
            </div>
            <% } %>

            <% if (europass != null && europass.getEducation() != null && !europass.getEducation().isEmpty()) { %>
            <div class="card p-4 mb-3">
                <div class="section-title">Obrazovanje</div>
                <% for (EducationDTO edu : europass.getEducation()) { %>
                <div class="timeline-item">
                    <div class="fw-semibold"><%= edu.getInstitution() %></div>
                    <div class="text-muted small"><%= edu.getDegree() %> — <%= edu.getField() %></div>
                    <div class="text-muted small">
                        <%= edu.getStartDate() != null ? edu.getStartDate() : "" %>
                        —
                        <%= edu.getEndDate() != null && !edu.getEndDate().isEmpty() ? edu.getEndDate() : "danas" %>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>

            <% if (europass != null && europass.getExperience() != null && !europass.getExperience().isEmpty()) { %>
            <div class="card p-4 mb-3">
                <div class="section-title">Radno iskustvo</div>
                <% for (ExperienceDTO exp : europass.getExperience()) { %>
                <div class="timeline-item">
                    <div class="fw-semibold"><%= exp.getPosition() %></div>
                    <div class="text-muted small"><%= exp.getCompany() %></div>
                    <div class="text-muted small">
                        <%= exp.getStartDate() != null ? exp.getStartDate() : "" %>
                        —
                        <%= exp.getEndDate() != null && !exp.getEndDate().isEmpty() ? exp.getEndDate() : "danas" %>
                    </div>
                    <% if (exp.getDescription() != null && !exp.getDescription().isEmpty()) { %>
                    <p class="mt-1 mb-0 small"><%= exp.getDescription() %></p>
                    <% } %>
                </div>
                <% } %>
            </div>
            <% } %>

        </div>
    </div>
    <a href="applications.jsp" class="btn btn-secondary btn-sm mt-3">Nazad</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>