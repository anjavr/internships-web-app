<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.AuthService"%>
<%
if (session.getAttribute("token") != null) {
    response.sendRedirect("dashboard.jsp");
    return;
}

String error = null;

if ("POST".equals(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    try {
        AuthService authService = new AuthService();
        String token = authService.login(username, password);
        String companyId = authService.extractCompanyId(token);
        session.setAttribute("token", token);
        session.setAttribute("companyId", companyId);
        session.setAttribute("username", username);
        response.sendRedirect("dashboard.jsp");
        return;
    } catch (Exception e) {
        error = "Pogrešno korisničko ime ili lozinka";
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prijava — Kompanija</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            overflow: hidden;
            background-color: #7DAACB;
        }
        .login-wrapper {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: -80px;
        }
        .card {
            border: none;
            border-radius: 12px;
        }
        .btn-primary {
            background-color: #7DAACB;
            border-color: #7DAACB;
            border-radius: 8px;
        }
        .btn-primary:hover {
            background-color: #5a8aad;
            border-color: #5a8aad;
        }
        .form-control { border-radius: 8px; }
        .invalid-feedback {
            display: none;
            color: #dc3545;
            font-size: 0.85rem;
        }
        .form-control.is-invalid ~ .invalid-feedback { display: block; }
        .toggle-password {
            cursor: pointer;
            background-color: white;
            border-left: none;
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="col-11 col-sm-8 col-md-5 col-lg-4">
        <div class="card shadow-lg">
            <div class="card-body p-4">

                <h4 class="card-title text-center mb-1">Prijava kompanije</h4>
                <p class="text-center text-muted small mb-4">Portal za kompanije</p>

                <% if (error != null) { %>
                    <div class="alert alert-danger d-flex align-items-center gap-2">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span><%= error %></span>
                    </div>
                <% } %>

                <form method="post" id="loginForm" novalidate>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Korisničko ime</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white">
                                <i class="bi bi-person"></i>
                            </span>
                            <input type="text" name="username" id="username"
                                   class="form-control"
                                   placeholder="Unesite korisničko ime">
                        </div>
                        <div class="invalid-feedback" id="usernameError">
                            Korisničko ime je obavezno.
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Lozinka</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white">
                                <i class="bi bi-lock"></i>
                            </span>
                            <input type="password" name="password" id="password"
                                   class="form-control"
                                   placeholder="Unesite lozinku">
                            <button type="button"
                                    class="input-group-text toggle-password"
                                    id="togglePassword">
                                <i class="bi bi-eye" id="eyeIcon"></i>
                            </button>
                        </div>
                        <div class="invalid-feedback" id="passwordError">
                            Lozinka je obavezna.
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2"
                            id="submitBtn" disabled>
                        <i class="bi bi-box-arrow-in-right me-1"></i>
                        Prijava
                    </button>
                </form>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const submitBtn = document.getElementById('submitBtn');
    const togglePassword = document.getElementById('togglePassword');
    const eyeIcon = document.getElementById('eyeIcon');
    const usernameError = document.getElementById('usernameError');
    const passwordError = document.getElementById('passwordError');

    function checkInputs() {
        submitBtn.disabled = !(usernameInput.value.trim() && passwordInput.value.trim());
    }

    usernameInput.addEventListener('input', function() {
        checkInputs();
        if (this.value.trim() === '') {
            this.classList.add('is-invalid');
            usernameError.style.display = 'block';
        } else {
            this.classList.remove('is-invalid');
            usernameError.style.display = 'none';
        }
    });

    passwordInput.addEventListener('input', function() {
        checkInputs();
        if (this.value.trim() === '') {
            this.classList.add('is-invalid');
            passwordError.style.display = 'block';
        } else {
            this.classList.remove('is-invalid');
            passwordError.style.display = 'none';
        }
    });

    document.getElementById('loginForm').addEventListener('submit', function(e) {
        let valid = true;
        if (usernameInput.value.trim() === '') {
            usernameInput.classList.add('is-invalid');
            usernameError.style.display = 'block';
            valid = false;
        }
        if (passwordInput.value.trim() === '') {
            passwordInput.classList.add('is-invalid');
            passwordError.style.display = 'block';
            valid = false;
        }
        if (!valid) e.preventDefault();
    });

    togglePassword.addEventListener('click', function() {
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            eyeIcon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            passwordInput.type = 'password';
            eyeIcon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    });
</script>
</body>
</html>