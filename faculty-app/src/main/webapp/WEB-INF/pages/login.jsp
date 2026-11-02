<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prijava — Fakultet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            overflow: hidden;
            background-color: #7DAACB !important;
        }
        .login-wrapper {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-top: 0;
            margin-top: -80px;
        }
        .card {
            border: none;
            border-radius: 12px;
        }
        .btn-primary {
            border-radius: 8px;
        }
        .form-control {
            border-radius: 8px;
        }
        .form-control.is-invalid {
            border-color: #dc3545;
        }
        .invalid-feedback {
            display: none;
            color: #dc3545;
            font-size: 0.85rem;
        }
        .form-control.is-invalid ~ .invalid-feedback {
            display: block;
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="col-11 col-sm-8 col-md-5 col-lg-4">
        <div class="card shadow-lg">
            <div class="card-body p-4">

                <h4 class="card-title text-center mb-1">Prijava na sistem</h4>
                <p class="text-center text-muted small mb-4">Fakultetski portal</p>

                <% if (session.getAttribute("error") != null) { %>
                    <div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span><%= session.getAttribute("error") %></span>
                    </div>
                    <% session.removeAttribute("error"); %>
                <% } %>

                <form action="MainController" method="post" id="loginForm" novalidate>
                    <input type="hidden" name="action" value="login">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Korisničko ime</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white">
                                <i class="bi bi-person"></i>
                            </span>
                            <input type="text" 
                                   name="username" 
                                   id="username"
                                   class="form-control" 
                                   placeholder="Unesite korisničko ime"
                                   autocomplete="username">
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
                            <input type="password" 
                                   name="password" 
                                   id="password"
                                   class="form-control" 
                                   placeholder="Unesite lozinku"
                                   autocomplete="current-password">
                            <button type="button" 
                                    class="input-group-text bg-white border-start-0" 
                                    id="togglePassword"
                                    style="cursor: pointer; border-left: none;">
                                <i class="bi bi-eye" id="eyeIcon"></i>
                            </button>
                        </div>
                        <div class="invalid-feedback" id="passwordError">
                            Lozinka je obavezna.
                        </div>
                    </div>

                    <button type="submit" 
                            class="btn btn-primary w-100 py-2" 
                            id="submitBtn" 
                            disabled>
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
        const usernameVal = usernameInput.value.trim();
        const passwordVal = passwordInput.value.trim();
        submitBtn.disabled = !(usernameVal && passwordVal);
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

        if (!valid) {
            e.preventDefault();
        }
    });

    togglePassword.addEventListener('click', function() {
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            eyeIcon.classList.remove('bi-eye');
            eyeIcon.classList.add('bi-eye-slash');
        } else {
            passwordInput.type = 'password';
            eyeIcon.classList.remove('bi-eye-slash');
            eyeIcon.classList.add('bi-eye');
        }
    });
</script>
</body>
</html>