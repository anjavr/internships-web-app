<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.ApplicationService"%>
<%@ page import="com.praksa.service.InternshipService"%>
<%@ page import="com.praksa.dto.ApplicationDTO"%>
<%@ page import="com.praksa.dto.InternshipDTO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.time.LocalDate"%>
<%
String token = (String) session.getAttribute("token");
String companyId = (String) session.getAttribute("companyId");
if (token == null || token.isEmpty()) {
    response.sendRedirect("login.jsp");
    return;
}

InternshipService internshipService = new InternshipService();
List<InternshipDTO> allInternships = internshipService.getByCompany(companyId, token);

List<InternshipDTO> internships = new ArrayList<>();
LocalDate today = LocalDate.now();
if (allInternships != null) {
    for (InternshipDTO i : allInternships) {
        if (i.getStartDate() != null && !LocalDate.parse(i.getStartDate()).isBefore(today)) {
            internships.add(i);
        }
    }
}

String selectedInternshipId = request.getParameter("internshipId");
List<ApplicationDTO> applications = null;
InternshipDTO selectedInternship = null;
boolean decisionAllowed = false;

if (selectedInternshipId != null && !selectedInternshipId.isEmpty()) {
    ApplicationService applicationService = new ApplicationService();
    applications = applicationService.getByInternship(selectedInternshipId, token);

    for (InternshipDTO i : internships) {
        if (i.getId().equals(selectedInternshipId)) {
            selectedInternship = i;
            break;
        }
    }

    if (selectedInternship != null && selectedInternship.getApplicationDeadline() != null) {
        decisionAllowed = LocalDate.parse(selectedInternship.getApplicationDeadline()).isBefore(today);
    }
}

String notification = (String) session.getAttribute("notification");
session.removeAttribute("notification");
%>
<%!
    private String formatDate(String date) {
        if (date == null || date.isEmpty()) return "-";
        try {
            return java.time.LocalDate.parse(date)
                .format(java.time.format.DateTimeFormatter.ofPattern("dd.MM.yyyy"));
        } catch (Exception e) {
            return date;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prijave studenata</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
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
        <h5 class="fw-semibold text-secondary">Prijave studenata</h5>
    </div>

    <div class="card p-3 mb-3">
        <form method="get">
            <div class="input-group">
                <select name="internshipId" class="form-select">
                    <option value="">Odaberi praksu</option>
                    <% for (InternshipDTO i : internships) { %>
                    <option value="<%= i.getId() %>"
                        <%= i.getId().equals(selectedInternshipId) ? "selected" : "" %>>
                        <%= i.getTitle() %>
                    </option>
                    <% } %>
                </select>
                <button type="submit" class="btn btn-primary">Prikaži</button>
            </div>
        </form>
    </div>

    <% if (applications != null) { %>

    <% if (!decisionAllowed && selectedInternship != null) { %>
        <div class="alert alert-info">
            <i class="bi bi-info-circle me-2"></i>
            Rok za prijavu još nije istekao (<strong><%= formatDate(selectedInternship.getApplicationDeadline()) %></strong>).
            Prihvatanje i odbijanje prijava biće omogućeno nakon isteka roka.
        </div>
    <% } %>

    <div class="card p-3">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>Student</th>
                        <th>Status</th>
                        <th>CV</th>
                        <th>Akcije</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (!applications.isEmpty()) {
                        for (ApplicationDTO app : applications) {
                            String status = app.getApplicationStatus() != null ? app.getApplicationStatus() : "";
                            String badgeClass = "bg-secondary";
                            String statusLabel = status;
                            if ("ACCEPTED".equals(status)) { badgeClass = "bg-success"; statusLabel = "Prihvaćen"; }
                            else if ("REJECTED".equals(status)) { badgeClass = "bg-danger"; statusLabel = "Odbijen"; }
                            else if ("APPLIED".equals(status)) { badgeClass = "bg-warning text-dark"; statusLabel = "Na čekanju"; }
                            else if ("WITHDRAWN".equals(status)) { badgeClass = "bg-secondary"; statusLabel = "Povučen"; }
                    %>
                    <tr>
                        <td class="align-middle"><%= app.getStudentName() %></td>
                        <td class="align-middle">
                            <span class="badge <%= badgeClass %>"><%= statusLabel %></span>
                        </td>
                        <td class="align-middle">
                            <a href="student-cv.jsp?studentId=<%= app.getStudentId() %>"
                               class="btn btn-outline-primary btn-sm">Pregledaj CV</a>
                        </td>
                        <td class="align-middle">
                            <% if ("APPLIED".equals(status)) { %>
                                <% if (decisionAllowed) { %>
                                    <button type="button" class="btn btn-success btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#acceptModal"
                                            data-id="<%= app.getId() %>"
                                            data-name="<%= app.getStudentName() %>"
                                            data-internship="<%= selectedInternshipId %>">
                                        Prihvati
                                    </button>
                                    <button type="button" class="btn btn-danger btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#rejectModal"
                                            data-id="<%= app.getId() %>"
                                            data-name="<%= app.getStudentName() %>"
                                            data-internship="<%= selectedInternshipId %>">
                                        Odbij
                                    </button>
                                <% } else { %>
                                    <span class="text-muted small fst-italic">Čeka se istek roka</span>
                                <% } %>
                            <% } else { %>
                                <span class="text-muted small">Odluka donesena</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    } else { %>
                    <tr>
                        <td colspan="4" class="text-center text-muted py-3">Nema prijava za ovu praksu</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

    <a href="dashboard.jsp" class="btn btn-secondary btn-sm mt-3">Nazad</a>
</div>

<div class="modal fade" id="acceptModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 14px; border: none;">
            <div class="modal-header" style="background-color: #198754; color: white; border-radius: 14px 14px 0 0;">
                <h5 class="modal-title">
                    <i class="bi bi-check-circle me-2"></i>Potvrda prihvatanja
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p id="acceptMessage" class="mb-0"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Odustani</button>
                <a id="acceptBtn" href="#" class="btn btn-success btn-sm">Prihvati</a>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 14px; border: none;">
            <div class="modal-header" style="background-color: #dc3545; color: white; border-radius: 14px 14px 0 0;">
                <h5 class="modal-title">
                    <i class="bi bi-x-circle me-2"></i>Potvrda odbijanja
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p id="rejectMessage" class="mb-0"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Odustani</button>
                <a id="rejectBtn" href="#" class="btn btn-danger btn-sm">Odbij</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('acceptModal').addEventListener('show.bs.modal', function(event) {
        var btn = event.relatedTarget;
        var id = btn.getAttribute('data-id');
        var name = btn.getAttribute('data-name');
        var internshipId = btn.getAttribute('data-internship');
        document.getElementById('acceptMessage').textContent =
            'Da li ste sigurni da želite prihvatiti prijavu studenta ' + name + '?';
        document.getElementById('acceptBtn').href =
            'accept-application.jsp?id=' + id + '&internshipId=' + internshipId;
    });

    document.getElementById('rejectModal').addEventListener('show.bs.modal', function(event) {
        var btn = event.relatedTarget;
        var id = btn.getAttribute('data-id');
        var name = btn.getAttribute('data-name');
        var internshipId = btn.getAttribute('data-internship');
        document.getElementById('rejectMessage').textContent =
            'Da li ste sigurni da želite odbiti prijavu studenta ' + name + '?';
        document.getElementById('rejectBtn').href =
            'reject-application.jsp?id=' + id + '&internshipId=' + internshipId;
    });
</script>
</body>
</html>