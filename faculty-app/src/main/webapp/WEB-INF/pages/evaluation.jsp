<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.praksa.dto.ApplicationDTO"%>
<%@ page import="com.praksa.dto.WorkLogDTO"%>
<%@ page import="com.praksa.dto.EvaluationDTO"%>
<%@ page import="com.praksa.beans.EvaluationBean"%>
<%@ page import="java.time.LocalDate"%>

<jsp:useBean class="com.praksa.beans.EvaluationBean" id="evaluationBean"
	scope="session" />

<%
if (session.getAttribute("token") == null) {
	response.sendRedirect("MainController");
	return;
}
ApplicationDTO app = evaluationBean.getSelectedApplication();
List<WorkLogDTO> workLogs = evaluationBean.getWorkLogs();
EvaluationDTO evaluation = evaluationBean.getEvaluation();
%>
<%!private String formatDate(String date) {
		if (date == null || date.isEmpty())
			return "-";
		try {
			return java.time.LocalDate.parse(date).format(java.time.format.DateTimeFormatter.ofPattern("dd.MM.yyyy"));
		} catch (Exception e) {
			return date;
		}
	}%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ocjenjivanje studenta</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
html, body {
	background-color: #eef2f5;
}

.navbar {
	background-color: #7DAACB !important;
}

.card {
	border: none;
	border-radius: 14px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.btn-primary {
	background-color: #7DAACB;
	border-color: #7DAACB;
}

.btn-primary:hover {
	background-color: #5a8aad;
	border-color: #5a8aad;
}

.section-title {
	font-size: 0.85rem;
	text-transform: uppercase;
	letter-spacing: 0.05em;
	color: #7DAACB;
	font-weight: 600;
}

.worklog-header {
	background-color: #f8f9fa;
	border-bottom: 1px solid #e9ecef;
	border-radius: 14px 14px 0 0;
}
</style>
</head>
<body>

	<nav class="navbar navbar-dark">
		<div class="container">
			<a class="navbar-brand fw-semibold"
				href="MainController?action=welcome"> Upravljanje praksama </a> <a
				href="MainController?action=logout"
				class="btn btn-outline-light btn-sm">Odjava</a>
		</div>
	</nav>

	<div class="container mt-4">

		<%
		if (session.getAttribute("notification") != null) {
		%>
		<div class="alert alert-success alert-dismissible fade show">
			<%=session.getAttribute("notification")%>
			<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
		</div>
		<%
		session.removeAttribute("notification");
		%>
		<%
		}
		%>

		<%
		if (app != null) {
		%>
		<div class="card mb-4">
			<div class="card-body">
				<h5 class="fw-semibold mb-1"><%=app.getStudentName()%></h5>
				<p class="text-muted mb-0">
					Praksa: <strong><%=app.getInternshipTitle()%></strong>
				</p>
			</div>
		</div>
		<%
		}
		%>

		<h6 class="section-title mb-3">Dnevnik rada</h6>

		<%
		if (workLogs != null && !workLogs.isEmpty()) {
			for (WorkLogDTO log : workLogs) {
		%>
		<div class="card mb-3">
			<div
				class="card-header worklog-header d-flex justify-content-between align-items-center p-3">
				<strong class="text-secondary">Sedmica: <%=formatDate(log.getWeekStartDate())%></strong>
				<%
				if (log.getHours() != null) {
				%>
				<span class="badge bg-primary"><%=log.getHours()%> sati</span>
				<%
				}
				%>
			</div>
			<div class="card-body p-3">
				<p class="text-muted small mb-1 fw-semibold">AKTIVNOSTI</p>
				<p class="mb-3"><%=log.getActivities()%></p>

				<%
				if (log.getSupervisorFeedback() != null && !log.getSupervisorFeedback().isEmpty()) {
				%>
				<hr class="my-2">
				<p class="text-muted small mb-1 fw-semibold">POVRATNA
					INFORMACIJA KOMPANIJE</p>
				<p class="text-secondary mb-0"><%=log.getSupervisorFeedback()%></p>
				<%
				} else {
				%>
				<p class="text-muted fst-italic mb-0 small">Kompanija još nije
					dala povratnu informaciju za ovu sedmicu.</p>
				<%
				}
				%>
			</div>
		</div>
		<%
		}
		} else {
		%>
		<div class="alert alert-info">Student još nije unio dnevnik
			rada.</div>
		<%
		}
		%>

		<h6 class="section-title mt-4 mb-3">Ocjenjivanje</h6>

		<%
		if (evaluation != null) {
		%>
		<div class="card mb-4" style="border-left: 4px solid #28a745;">
			<div class="card-body">
				<p class="text-success fw-semibold mb-2">Ocjena je već
					dodijeljena</p>
				<p class="mb-1">
					Ocjena: <strong><%=evaluation.getRating()%></strong>
				</p>
				<%
				if (evaluation.getComments() != null && !evaluation.getComments().isEmpty()) {
				%>
				<p class="text-secondary mb-0">
					Komentar:
					<%=evaluation.getComments()%></p>
				<%
				}
				%>
			</div>
		</div>

		<%
		} else if (app != null && app.getEndDate() != null && LocalDate.parse(app.getEndDate()).isBefore(LocalDate.now())) {
		%>
		<div class="card mb-4">
			<div class="card-body p-4">
				<form action="MainController" method="post">
					<input type="hidden" name="action" value="save-evaluation">

					<div class="row g-3">
						<div class="col-12 col-md-4">
							<label class="form-label">Ocjena (6-10)</label> <select
								name="rating" class="form-select" required>
								<option value="">-- Odaberi --</option>
								<option value="6">6</option>
								<option value="7">7</option>
								<option value="8">8</option>
								<option value="9">9</option>
								<option value="10">10</option>
							</select>
						</div>
						<div class="col-12 col-md-8">
							<label class="form-label">Komentar</label>
							<textarea name="comments" class="form-control" rows="2"></textarea>
						</div>
					</div>

					<button type="submit" class="btn btn-success mt-3">
						Sačuvaj ocjenu</button>
				</form>
			</div>
		</div>

		<%
		} else {
		%>
		<div class="alert alert-warning">Praksa još nije završena.
			Ocjena se može dodijeliti nakon završetka prakse.</div>
		<%
		}
		%>

		<a href="MainController?action=evaluations"
			class="btn btn-secondary btn-sm mt-2">Nazad</a>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>