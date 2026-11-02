<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.praksa.dto.CompanyDTO"%>
<%@ page import="com.praksa.beans.CompanyBean"%>
<jsp:useBean class="com.praksa.beans.CompanyBean" id="companyBean"
	scope="session" />

<%
if (session.getAttribute("token") == null) {
	response.sendRedirect("MainController");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Kompanije</title>
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

.table thead {
	background-color: #7DAACB;
	color: white;
}

.btn-primary {
	background-color: #7DAACB;
	border-color: #7DAACB;
}

.btn-primary:hover {
	background-color: #5a8aad;
	border-color: #5a8aad;
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

		<div class="d-flex justify-content-between align-items-center mb-3">
			<h5 class="fw-semibold text-secondary">Upravljanje kompanijama</h5>
			<a href="MainController?action=new-company"
				class="btn btn-success btn-sm"> + Nova kompanija </a>
		</div>

		<%
		if (session.getAttribute("notification") != null) {
		%>
		<div class="alert alert-info alert-dismissible fade show">
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
		if (session.getAttribute("error") != null) {
		%>
		<div class="alert alert-danger alert-dismissible fade show">
			<%=session.getAttribute("error")%>
			<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
		</div>
		<%
		session.removeAttribute("error");
		%>
		<%
		}
		%>

		<div class="card p-3">
			<div class="table-responsive">
				<table class="table table-hover mb-0">
					<thead>
						<tr>
							<th>Naziv</th>
							<th>Email</th>
							<th>Telefon</th>
							<th>Adresa</th>
							<th>Status</th>
							<th>Akcije</th>
						</tr>
					</thead>
					<tbody>
						<%
						List<CompanyDTO> companies = companyBean.getCompanies();
						if (companies != null && !companies.isEmpty()) {
							for (CompanyDTO company : companies) {
						%>
						<tr>
							<td><%=company.getName()%></td>
							<td><%=company.getContactEmail() != null ? company.getContactEmail() : ""%></td>
							<td><%=company.getContactPhone() != null ? company.getContactPhone() : ""%></td>
							<td><%=company.getAddress() != null ? company.getAddress() : ""%></td>
							<td>
								<%
								if (company.isActive()) {
								%> <span class="badge bg-success">Aktivan</span> <%
 } else {
 %> <span class="badge bg-danger">Neaktivan</span> <%
 }
 %>
							</td>
							<td><a
								href="MainController?action=edit-company&id=<%=company.getId()%>"
								class="btn btn-warning btn-sm">Uredi</a> <%
 if (company.isActive()) {
 %>
								<button type="button" class="btn btn-danger btn-sm"
									data-bs-toggle="modal" data-bs-target="#confirmModal"
									data-id="<%=company.getId()%>" data-active="false"
									data-action="deaktivirati" data-name="<%=company.getName()%>">
									Deaktiviraj</button> <%
 } else {
 %>
								<button type="button" class="btn btn-success btn-sm"
									data-bs-toggle="modal" data-bs-target="#confirmModal"
									data-id="<%=company.getId()%>" data-active="true"
									data-action="aktivirati" data-name="<%=company.getName()%>">
									Aktiviraj</button> <%
 }
 %></td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="6" class="text-center text-muted py-3">Nema
								podataka o kompanijama</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>

		<a href="MainController?action=welcome"
			class="btn btn-secondary btn-sm mt-3">Nazad</a>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="confirmModal" tabindex="-1">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content" style="border-radius: 14px; border: none;">
				<div class="modal-header"
					style="background-color: #7DAACB; color: white; border-radius: 14px 14px 0 0;">
					<h5 class="modal-title">Potvrda akcije</h5>
					<button type="button" class="btn-close btn-close-white"
						data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<p id="modalMessage" class="mb-0"></p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-sm"
						data-bs-dismiss="modal">Odustani</button>
					<a id="confirmBtn" href="#" class="btn btn-primary btn-sm">Potvrdi</a>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		document
				.getElementById('confirmModal')
				.addEventListener(
						'show.bs.modal',
						function(event) {
							var button = event.relatedTarget;
							var id = button.getAttribute('data-id');
							var active = button.getAttribute('data-active');
							var action = button.getAttribute('data-action');
							var name = button.getAttribute('data-name');

							document.getElementById('modalMessage').textContent = 'Da li ste sigurni da želite '
									+ action
									+ ' nalog kompanije "'
									+ name
									+ '"?';

							document.getElementById('confirmBtn').href = 'MainController?action=toggle-active&id='
									+ id + '&active=' + active;
						});
	</script>
</body>
</html>