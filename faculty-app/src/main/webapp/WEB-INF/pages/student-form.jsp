<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.dto.StudentDTO"%>
<%
if (session.getAttribute("token") == null) {
    response.sendRedirect("MainController");
    return;
}

StudentDTO student = null;
if (session.getAttribute("studentBean") != null) {
    student = ((com.praksa.beans.StudentBean) session.getAttribute("studentBean")).getStudent();
}
boolean edit = student != null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= edit ? "Izmjena studenta" : "Novi student" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html, body { background-color: #eef2f5; min-height: 100%; }
        .navbar { background-color: #7DAACB !important; }
        .card {
            border: none;
            border-radius: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .btn-primary {
            background-color: #7DAACB;
            border-color: #7DAACB;
        }
        .btn-primary:hover {
            background-color: #5a8aad;
            border-color: #5a8aad;
        }
        .invalid-feedback { font-size: 0.82rem; }
        .toggle-password {
            cursor: pointer;
            background-color: white;
            border-left: none;
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

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-12 col-lg-10">
            <div class="card">
                <div class="card-body p-4">
                    <h5 class="fw-semibold text-secondary mb-4">
                        <%= edit ? "Izmjena studenta" : "Novi student" %>
                    </h5>

                    <form method="post"
                          action="MainController?action=<%= edit ? "update-student" : "create-student" %>"
                          id="studentForm" novalidate>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label">Ime i prezime *</label>
                                <input type="text" name="fullName" id="fullName"
                                       class="form-control"
                                       value="<%= edit ? student.getFullName() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label">Email *</label>
                                <input type="email" name="email" id="email"
                                       class="form-control"
                                       value="<%= edit ? student.getEmail() : "" %>">
                                <div class="invalid-feedback">Unesite ispravan email.</div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label">Korisničko ime *</label>
                                <input type="text" name="username" id="username"
                                       class="form-control"
                                       value="<%= edit ? student.getUsername() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label">Telefon *</label>
                                <input type="text" name="phone" id="phone"
                                       class="form-control"
                                       value="<%= edit && student.getPhone() != null ? student.getPhone() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Adresa *</label>
                            <input type="text" name="address" id="address"
                                   class="form-control"
                                   value="<%= edit && student.getAddress() != null ? student.getAddress() : "" %>">
                            <div class="invalid-feedback">Ovo polje je obavezno.</div>
                        </div>

                        <% if (!edit) { %>
                        <div class="mb-3">
                            <label class="form-label">Lozinka *</label>
                            <div class="input-group">
                                <input type="password" name="password" id="password"
                                       class="form-control">
                                <button type="button" class="input-group-text toggle-password"
                                        onclick="togglePassword()">
                                    <i class="bi bi-eye" id="eyeIcon"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback" id="passwordFeedback">
                                Ovo polje je obavezno.
                            </div>
                        </div>
                        <% } %>

                        <div class="d-flex gap-2 mt-3">
                            <button type="submit" class="btn btn-primary">Sačuvaj</button>
                            <a href="MainController?action=students" class="btn btn-secondary">
                                Odustani
                            </a>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('studentForm').addEventListener('submit', function(e) {
        let valid = true;

        const requiredFields = ['fullName', 'email', 'username', 'phone', 'address'];
        <% if (!edit) { %>
        requiredFields.push('password');
        <% } %>

        requiredFields.forEach(function(fieldId) {
            const field = document.getElementById(fieldId);
            if (!field) return;

            if (field.value.trim() === '') {
                field.classList.add('is-invalid');
                valid = false;
            } else if (fieldId === 'email' && !isValidEmail(field.value)) {
                field.classList.add('is-invalid');
                valid = false;
            } else {
                field.classList.remove('is-invalid');
            }
        });

        <% if (!edit) { %>
        const passwordField = document.getElementById('password');
        if (passwordField && passwordField.value.trim() === '') {
            passwordField.classList.add('is-invalid');
            document.getElementById('passwordFeedback').style.display = 'block';
            valid = false;
        }
        <% } %>

        if (!valid) e.preventDefault();
    });

    document.querySelectorAll('.form-control').forEach(function(input) {
        input.addEventListener('input', function() {
            this.classList.remove('is-invalid');
        });
    });

    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const eyeIcon = document.getElementById('eyeIcon');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            eyeIcon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            passwordInput.type = 'password';
            eyeIcon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }
</script>
</body>
</html>