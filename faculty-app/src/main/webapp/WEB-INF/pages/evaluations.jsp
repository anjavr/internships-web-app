<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.praksa.dto.ApplicationDTO"%>
<%@ page import="com.praksa.dto.InternshipDiaryDTO"%>
<%@ page import="com.praksa.beans.EvaluationBean"%>
<%@ page import="com.praksa.service.DiaryService"%>

<jsp:useBean class="com.praksa.beans.EvaluationBean" id="evaluationBean" scope="session"/>

<% if (session.getAttribute("token") == null) {
    response.sendRedirect("MainController");
    return;
}

String token = (String) session.getAttribute("token");
List<ApplicationDTO> allApplications = evaluationBean.getApplications();

List<ApplicationDTO> submittedApplications = new ArrayList<>();
DiaryService diaryService = new DiaryService();

if (allApplications != null) {
    for (ApplicationDTO app : allApplications) {
        try {
            InternshipDiaryDTO diary = diaryService.getByStudentAndInternship(
                app.getStudentId(), app.getInternshipId(), token);
            if ("SUBMITTED".equals(diary.getStatus())) {
                submittedApplications.add(app);
            }
        } catch (Exception e) {
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Praćenje rada studenata</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body { background-color: #eef2f5; }
        .navbar { background-color: #7DAACB !important; }
        .card { border: none; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .table thead { background-color: #7DAACB; color: white; }
        .btn-primary { background-color: #7DAACB; border-color: #7DAACB; }
        .btn-primary:hover { background-color: #5a8aad; border-color: #5a8aad; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark">
    <div class="container">
        <a class="navbar-brand fw-semibold" href="MainController?action=welcome">
            Upravljanje praksama
        </a>
        <a href="MainController?action=logout" class="btn btn-outline-light btn-sm">Odjava</a>
    </div>
</nav>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-semibold text-secondary">Praćenje rada studenata</h5>
    </div>

    <% if (session.getAttribute("notification") != null) { %>
        <div class="alert alert-success alert-dismissible fade show">
            <%= session.getAttribute("notification") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("notification"); %>
    <% } %>

    <div class="card p-3">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>Student</th>
                        <th>Praksa</th>
                        <th>Status dnevnika</th>
                        <th>Akcije</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (!submittedApplications.isEmpty()) {
                        for (ApplicationDTO app : submittedApplications) { %>
                    <tr>
                        <td><%= app.getStudentName() %></td>
                        <td><%= app.getInternshipTitle() %></td>
                        <td>
                            <span class="badge bg-warning text-dark">
                                <i class="bi bi-hourglass-split me-1"></i>Čeka ocjenu
                            </span>
                        </td>
                        <td>
                            <a href="MainController?action=evaluation&studentId=<%= app.getStudentId() %>&internshipId=<%= app.getInternshipId() %>"
                               class="btn btn-primary btn-sm">
                                Ocijeni
                            </a>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="4" class="text-center text-muted py-3">
                            Nema predanih dnevnika koji čekaju ocjenu
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <a href="MainController?action=welcome" class="btn btn-secondary btn-sm mt-3">Nazad</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>