<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.UserService"%>
<%
String token = (String) session.getAttribute("token");
if (token == null || token.isEmpty()) {
    response.sendRedirect("login.jsp");
    return;
}

String error = null;
String success = null;

if ("POST".equals(request.getMethod())) {
    String oldPassword = request.getParameter("oldPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    if (!newPassword.equals(confirmPassword)) {
        error = "Nova lozinka i potvrda se ne poklapaju!";
    } else if (newPassword.length() < 6) {
        error = "Nova lozinka mora imati najmanje 6 karaktera!";
    } else {
        try {
            UserService userService = new UserService();
            userService.changePassword(oldPassword, newPassword, token);
            success = "Lozinka uspješno promijenjena!";
        } catch (Exception e) {
            error = "Stara lozinka nije ispravna!";
        }
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promjena lozinke</title>
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
        <a class="navbar-brand fw-semibold" href="dashboard.jsp">Upravljanje praksama</a>
        <a href="logout.jsp" class="btn btn-outline-light btn-sm">Odjava</a>
    </div>
</nav>

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-12 col-md-5">
            <div class="card">
                <div class="card-body p-4">
                    <h5 class="fw-semibold text-secondary mb-4">Promjena lozinke</h5>

                    <% if (error != null) { %>
                        <div class="alert alert-danger d-flex align-items-center gap-2">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <span><%= error %></span>
                        </div>
                    <% } %>
                    <% if (success != null) { %>
                        <div class="alert alert-success d-flex align-items-center gap-2">
                            <i class="bi bi-check-circle-fill"></i>
                            <span><%= success %></span>
                        </div>
                    <% } %>

                    <form method="post" id="passwordForm" novalidate>

                        <div class="mb-3">
                            <label class="form-label">Stara lozinka *</label>
                            <div class="input-group">
                                <input type="password" name="oldPassword" id="oldPassword"
                                       class="form-control">
                                <button type="button" class="input-group-text toggle-password"
                                        onclick="togglePass('oldPassword', 'eye1')">
                                    <i class="bi bi-eye" id="eye1"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback" id="oldPasswordError">
                                Ovo polje je obavezno.
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Nova lozinka *</label>
                            <div class="input-group">
                                <input type="password" name="newPassword" id="newPassword"
                                       class="form-control">
                                <button type="button" class="input-group-text toggle-password"
                                        onclick="togglePass('newPassword', 'eye2')">
                                    <i class="bi bi-eye" id="eye2"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback" id="newPasswordError">
                                Lozinka mora imati najmanje 6 karaktera.
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Potvrdi novu lozinku *</label>
                            <div class="input-group">
                                <input type="password" name="confirmPassword" id="confirmPassword"
                                       class="form-control">
                                <button type="button" class="input-group-text toggle-password"
                                        onclick="togglePass('confirmPassword', 'eye3')">
                                    <i class="bi bi-eye" id="eye3"></i>
                                </button>
                            </div>
                            <div class="invalid-feedback" id="confirmPasswordError">
                                Lozinke se ne poklapaju.
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                Promijeni lozinku
                            </button>
                            <a href="dashboard.jsp" class="btn btn-secondary">Odustani</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePass(inputId, iconId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }

    document.getElementById('passwordForm').addEventListener('submit', function(e) {
        let valid = true;

        const old = document.getElementById('oldPassword');
        const newP = document.getElementById('newPassword');
        const confirm = document.getElementById('confirmPassword');

        if (old.value.trim() === '') {
            old.classList.add('is-invalid');
            document.getElementById('oldPasswordError').style.display = 'block';
            valid = false;
        } else {
            old.classList.remove('is-invalid');
        }

        if (newP.value.trim().length < 6) {
            newP.classList.add('is-invalid');
            document.getElementById('newPasswordError').style.display = 'block';
            valid = false;
        } else {
            newP.classList.remove('is-invalid');
        }

        if (confirm.value !== newP.value || confirm.value.trim() === '') {
            confirm.classList.add('is-invalid');
            document.getElementById('confirmPasswordError').style.display = 'block';
            valid = false;
        } else {
            confirm.classList.remove('is-invalid');
        }

        if (!valid) e.preventDefault();
    });

    document.querySelectorAll('.form-control').forEach(function(input) {
        input.addEventListener('input', function() {
            this.classList.remove('is-invalid');
        });
    });
</script>
</body>
</html>