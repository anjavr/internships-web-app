<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.praksa.dto.StudentDTO"%>
<%@ page import="com.praksa.beans.StudentBean"%>
<jsp:useBean class="com.praksa.beans.StudentBean" id="studentBean" scope="session"/>

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
    <title>Studenti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body { background-color: #eef2f5; }
        .navbar { background-color: #7DAACB !important; }
        .card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
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
        <a class="navbar-brand fw-semibold" href="MainController?action=welcome">
            Upravljanje praksama
        </a>
        <a href="MainController?action=logout" class="btn btn-outline-light btn-sm">Odjava</a>
    </div>
</nav>

<div class="container mt-4">

    <% if (session.getAttribute("notification") != null) { %>
        <div class="alert alert-info alert-dismissible fade show">
            <%= session.getAttribute("notification") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% session.removeAttribute("notification"); %>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-semibold text-secondary">Upravljanje studentima</h5>
        <a href="MainController?action=new-student" class="btn btn-success btn-sm">
            + Novi student
        </a>
    </div>

    <div class="card p-3 mb-3">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>Ime i prezime</th>
                        <th>Email</th>
                        <th>Korisničko ime</th>
                        <th>Telefon</th>
                        <th>Akcije</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<StudentDTO> students = studentBean.getStudents();
                    if (students != null && !students.isEmpty()) {
                        for (StudentDTO student : students) {
                    %>
                    <tr>
                        <td><%= student.getFullName() %></td>
                        <td><%= student.getEmail() != null ? student.getEmail() : "" %></td>
                        <td><%= student.getUsername() != null ? student.getUsername() : "" %></td>
                        <td><%= student.getPhone() != null ? student.getPhone() : "" %></td>
                        <td>
                            <a href="MainController?action=edit-student&id=<%= student.getId() %>"
                               class="btn btn-warning btn-sm">Uredi</a>

                            <button type="button" class="btn btn-danger btn-sm"
                                    data-bs-toggle="modal"
                                    data-bs-target="#deleteModal"
                                    data-id="<%= student.getId() %>"
                                    data-name="<%= student.getFullName() %>">
                                Obriši
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="5" class="text-center text-muted py-3">Nema studenata</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card p-3">
        <h6 class="fw-semibold text-secondary mb-3">Uvoz studenata iz CSV fajla</h6>
        <form method="post" action="MainController?action=upload-csv"
              enctype="multipart/form-data">
            <div class="input-group">
                <input type="file" name="file" class="form-control" accept=".csv" required>
                <button type="submit" class="btn btn-primary">Uvezi CSV</button>
            </div>
            <small class="text-muted mt-1 d-block">
                    Format: imeIPrezime;email;korisnickoIme;lozinka;telefon;adresa (separator: ;)
            </small>
        </form>
    </div>

    <a href="MainController?action=welcome" class="btn btn-secondary btn-sm mt-3 mb-3">Nazad</a>
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
                <p class="text-danger small mt-2 mb-0">
                    <strong>Upozorenje:</strong> Ova akcija je nepovratna. Brišu se i sve prijave, dnevnici i ocjene studenta.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm"
                        data-bs-dismiss="modal">Odustani</button>
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
            'Da li ste sigurni da želite obrisati studenta "' + name + '"?';

        document.getElementById('deleteBtn').href =
            'MainController?action=delete-student&id=' + id;
    });
</script>
</body>
</html>