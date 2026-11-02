<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.WorkLogService"%>
<%@ page import="com.praksa.service.InternshipService"%>
<%@ page import="com.praksa.service.ApplicationService"%>
<%@ page import="com.praksa.service.DiaryService"%>
<%@ page import="com.praksa.dto.WorkLogDTO"%>
<%@ page import="com.praksa.dto.InternshipDTO"%>
<%@ page import="com.praksa.dto.ApplicationDTO"%>
<%@ page import="com.praksa.dto.InternshipDiaryDTO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.time.LocalDate"%>
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

    private String escapeFeedback(String feedback) {
        if (feedback == null) return "";
        return feedback.replace("\\", "\\\\")
                       .replace("'", "\\'")
                       .replace("\n", "\\n")
                       .replace("\r", "");
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
List<InternshipDTO> allInternships = internshipService.getByCompany(companyId, token);

List<InternshipDTO> internships = new ArrayList<>();
LocalDate today = LocalDate.now();
LocalDate oneYearAgo = today.minusMonths(12);

if (allInternships != null) {
    for (InternshipDTO i : allInternships) {
        if (i.getStartDate() != null) {
            LocalDate start = LocalDate.parse(i.getStartDate());
            if (start.isBefore(today) && start.isAfter(oneYearAgo)) {
                internships.add(i);
            }
        }
    }
}

String selectedInternshipId = request.getParameter("internshipId");
List<ApplicationDTO> acceptedStudents = null;
String selectedStudentId = request.getParameter("studentId");
List<WorkLogDTO> workLogs = null;
InternshipDiaryDTO diary = null;
boolean feedbackAllowed = false;
boolean canMarkFeedbackDone = false;

if (selectedInternshipId != null && !selectedInternshipId.isEmpty()) {
    ApplicationService applicationService = new ApplicationService();
    List<ApplicationDTO> allApps = applicationService.getByInternship(selectedInternshipId, token);
    acceptedStudents = new ArrayList<>();
    for (ApplicationDTO app : allApps) {
        if ("ACCEPTED".equals(app.getApplicationStatus())) {
            acceptedStudents.add(app);
        }
    }
}

if (selectedStudentId != null && !selectedStudentId.isEmpty()) {
    WorkLogService workLogService = new WorkLogService();
    List<WorkLogDTO> allLogs = workLogService.getByStudent(selectedStudentId, token);
    workLogs = new ArrayList<>();
    for (WorkLogDTO log : allLogs) {
        if (selectedInternshipId.equals(log.getInternshipId())) {
            workLogs.add(log);
        }
    }
    workLogs.sort((a, b) -> a.getWeekStartDate().compareTo(b.getWeekStartDate()));

    try {
        DiaryService diaryService = new DiaryService();
        diary = diaryService.getByStudentAndInternship(selectedStudentId, selectedInternshipId, token);
        feedbackAllowed = "IN_PROGRESS".equals(diary.getStatus());
        canMarkFeedbackDone = "IN_PROGRESS".equals(diary.getStatus());
    } catch (Exception e) {
        diary = null;
    }
}

String notification = (String) session.getAttribute("notification");
session.removeAttribute("notification");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dnevnici rada</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html, body { background-color: #eef2f5; }
        .navbar { background-color: #7DAACB !important; }
        .card { border: none; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .btn-primary { background-color: #7DAACB; border-color: #7DAACB; }
        .btn-primary:hover { background-color: #5a8aad; border-color: #5a8aad; }
        .worklog-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            border-radius: 14px 14px 0 0;
            padding: 0.75rem 1rem;
        }
        .worklog-header.filled { border-left: 4px solid #4caf50; border-radius: 14px 14px 0 0; }
        .worklog-header.empty { border-left: 4px solid #ff9800; border-radius: 14px 14px 0 0; }
        .section-label {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #7DAACB;
            font-weight: 600;
        }
        .week-number { font-size: 0.75rem; color: #888; margin-left: 8px; }
        .diary-status-bar {
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }
        .diary-status-bar.in-progress { background-color: #e3f2fd; border-left: 4px solid #1976d2; }
        .diary-status-bar.feedback-done { background-color: #e8f5e9; border-left: 4px solid #388e3c; }
        .diary-status-bar.submitted { background-color: #fff3e0; border-left: 4px solid #f57c00; }
        .diary-status-bar.evaluated { background-color: #f3e5f5; border-left: 4px solid #7b1fa2; }
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
        <h5 class="fw-semibold text-secondary">Dnevnici rada</h5>
    </div>

    <% if (internships.isEmpty()) { %>
        <div class="alert alert-info">
            <i class="bi bi-info-circle me-2"></i>
            Nema aktivnih praksi za pregled dnevnika u posljednjih 12 mjeseci.
        </div>
    <% } else { %>

    <div class="card p-3 mb-3">
        <form method="get">
            <div class="input-group">
                <select name="internshipId" class="form-select">
                    <option value="">-- Odaberi praksu --</option>
                    <% for (InternshipDTO i : internships) {
                        boolean isFinished = i.getEndDate() != null && LocalDate.parse(i.getEndDate()).isBefore(today);
                        String label = i.getTitle() + (isFinished ? " (Završena)" : " (U toku)");
                    %>
                    <option value="<%= i.getId() %>"
                        <%= i.getId().equals(selectedInternshipId) ? "selected" : "" %>>
                        <%= label %>
                    </option>
                    <% } %>
                </select>
                <button type="submit" class="btn btn-primary">Prikaži studente</button>
            </div>
        </form>
    </div>

    <% if (acceptedStudents != null && !acceptedStudents.isEmpty()) { %>
    <div class="card p-3 mb-3">
        <form method="get">
            <input type="hidden" name="internshipId" value="<%= selectedInternshipId %>">
            <div class="input-group">
                <select name="studentId" class="form-select">
                    <option value="">-- Odaberi studenta --</option>
                    <% for (ApplicationDTO app : acceptedStudents) { %>
                    <option value="<%= app.getStudentId() %>"
                        <%= app.getStudentId().equals(selectedStudentId) ? "selected" : "" %>>
                        <%= app.getStudentName() %>
                    </option>
                    <% } %>
                </select>
                <button type="submit" class="btn btn-primary">Prikaži dnevnik</button>
            </div>
        </form>
    </div>
    <% } else if (acceptedStudents != null && acceptedStudents.isEmpty()) { %>
        <div class="alert alert-info">Nema prihvaćenih studenata za ovu praksu.</div>
    <% } %>

    <% if (diary != null) {
        String statusClass = diary.getStatus().toLowerCase().replace("_", "-");
        String statusLabel = "";
        String statusIcon = "";
        switch (diary.getStatus()) {
            case "IN_PROGRESS":
                statusLabel = "Dnevnik u toku, student još unosi aktivnosti";
                statusIcon = "bi-pencil";
                break;
            case "FEEDBACK_DONE":
                statusLabel = "Komentari završeni, čeka se predaja studenta";
                statusIcon = "bi-check-circle";
                break;
            case "SUBMITTED":
                statusLabel = "Dnevnik predan, čeka se ocjena fakulteta";
                statusIcon = "bi-hourglass-split";
                break;
            case "EVALUATED":
                statusLabel = "Dnevnik ocijenjen";
                statusIcon = "bi-award";
                break;
        }
    %>
    <div class="diary-status-bar <%= statusClass %>">
        <div>
            <i class="bi <%= statusIcon %> me-2"></i>
            <strong><%= statusLabel %></strong>
        </div>
        <% if (canMarkFeedbackDone) { %>
        <a href="mark-feedback-done.jsp?diaryId=<%= diary.getId() %>&internshipId=<%= selectedInternshipId %>&studentId=<%= selectedStudentId %>"
           class="btn btn-success btn-sm"
           onclick="return confirm('Da li ste sigurni da ste završili sa komentarima? Nakon ovoga nećete moći mijenjati feedback.')">
            <i class="bi bi-check-lg me-1"></i>Završi sa komentarima
        </a>
        <% } %>
    </div>
    <% } %>

    <% if (workLogs != null) {
        if (!workLogs.isEmpty()) {
            int weekNum = 1;
            for (WorkLogDTO log : workLogs) {
                boolean isFilled = log.getActivities() != null && !log.getActivities().isEmpty();
                boolean hasFeedback = log.getSupervisorFeedback() != null && !log.getSupervisorFeedback().isEmpty();
    %>
    <div class="card mb-3">
        <div class="worklog-header d-flex justify-content-between align-items-center <%= isFilled ? "filled" : "empty" %>">
            <div>
                <strong class="text-secondary">Sedmica <%= weekNum %></strong>
                <span class="week-number"><%= formatDate(log.getWeekStartDate()) %></span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <% if (!isFilled) { %>
                    <span class="badge bg-warning text-dark">
                        <i class="bi bi-exclamation-triangle me-1"></i>Nije popunjeno
                    </span>
                <% } else if (log.getHours() != null) { %>
                    <span class="badge bg-primary"><%= log.getHours() %> sati</span>
                <% } %>
            </div>
        </div>
        <div class="card-body p-3">

            <% if (isFilled) { %>
                <div class="section-label mb-1">Aktivnosti</div>
                <p class="mb-3"><%= log.getActivities() %></p>
            <% } else { %>
                <p class="text-muted fst-italic small mb-3">
                    <i class="bi bi-clock me-1"></i>Student još nije popunio ovu sedmicu.
                </p>
            <% } %>

            <div class="section-label mb-1">Povratna informacija mentora</div>
            <% if (hasFeedback) { %>
                <p class="text-secondary mb-2"><%= log.getSupervisorFeedback() %></p>
            <% } else { %>
                <p class="text-muted fst-italic small mb-2">Još nije unesena povratna informacija.</p>
            <% } %>

            <% if (isFilled && feedbackAllowed) { %>
            <button class="btn btn-outline-primary btn-sm mt-1"
                    id="edit-btn-<%= log.getId() %>"
                    onclick="editFeedback('<%= log.getId() %>', '<%= escapeFeedback(log.getSupervisorFeedback()) %>')">
                <i class="bi bi-pencil me-1"></i>
                <%= hasFeedback ? "Uredi komentar" : "Dodaj komentar" %>
            </button>

            <form method="post" action="add-feedback.jsp"
                  id="feedback-form-<%= log.getId() %>"
                  style="display:none; margin-top: 12px;">
                <input type="hidden" name="workLogId" value="<%= log.getId() %>">
                <input type="hidden" name="internshipId" value="<%= selectedInternshipId %>">
                <input type="hidden" name="studentId" value="<%= selectedStudentId %>">
                <div class="input-group">
                    <textarea name="feedback" class="form-control" rows="2"
                              id="feedback-textarea-<%= log.getId() %>"
                              placeholder="Unesite komentar za ovu sedmicu..."></textarea>
                </div>
                <div class="d-flex gap-2 mt-2">
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-check-lg me-1"></i>Sačuvaj
                    </button>
                    <button type="button" class="btn btn-secondary btn-sm"
                            onclick="cancelFeedback('<%= log.getId() %>')">
                        Odustani
                    </button>
                </div>
            </form>
            <% } else if (isFilled && !feedbackAllowed && diary != null) { %>
                <span class="text-muted small fst-italic">
                    <i class="bi bi-lock me-1"></i>
                    <% if ("FEEDBACK_DONE".equals(diary.getStatus())) { %>
                        Komentari su zaključani.
                    <% } else if ("SUBMITTED".equals(diary.getStatus()) || "EVALUATED".equals(diary.getStatus())) { %>
                        Dnevnik je predan, komentari se ne mogu mijenjati.
                    <% } %>
                </span>
            <% } %>

        </div>
    </div>
    <%
            weekNum++;
            }
        } else { %>
    <div class="alert alert-info">Student još nije popunio nijednu sedmicu dnevnika rada.</div>
    <% } } %>

    <% } %>

    <a href="dashboard.jsp" class="btn btn-secondary btn-sm mt-2">Nazad</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editFeedback(logId, existingFeedback) {
        document.getElementById('feedback-form-' + logId).style.display = 'block';
        document.getElementById('edit-btn-' + logId).style.display = 'none';
        var textarea = document.getElementById('feedback-textarea-' + logId);
        textarea.value = existingFeedback.replace(/\\n/g, '\n');
        textarea.focus();
    }

    function cancelFeedback(logId) {
        document.getElementById('feedback-form-' + logId).style.display = 'none';
        document.getElementById('edit-btn-' + logId).style.display = 'inline-block';
    }
</script>
</body>
</html>