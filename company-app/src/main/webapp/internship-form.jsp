<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.InternshipService"%>
<%@ page import="com.praksa.dto.InternshipDTO"%>
<%@ page import="java.time.LocalDate"%>
<%
String token = (String) session.getAttribute("token");
String companyId = (String) session.getAttribute("companyId");
if (token == null || token.isEmpty()) {
    response.sendRedirect("login.jsp");
    return;
}

String id = request.getParameter("id");
boolean isEdit = id != null && !id.isEmpty();
InternshipDTO internship = null;
InternshipService internshipService = new InternshipService();

if (isEdit) {
    internship = internshipService.getById(id, token);
}

boolean formDisabled = isEdit && internship != null &&
    internship.getEndDate() != null &&
    LocalDate.parse(internship.getEndDate()).isBefore(LocalDate.now());

if ("POST".equals(request.getMethod()) && !formDisabled) {
    InternshipDTO dto = new InternshipDTO();
    dto.setCompanyId(companyId);
    dto.setTitle(request.getParameter("title"));
    dto.setShortDesc(request.getParameter("shortDesc"));
    dto.setDescription(request.getParameter("description"));
    dto.setTechnologies(request.getParameter("technologies"));
    dto.setRequirements(request.getParameter("requirements"));
    dto.setMinGpa(request.getParameter("minGpa"));
    dto.setRequiredYear(request.getParameter("requiredYear"));
    dto.setRequiredLanguages(request.getParameter("requiredLanguages"));
    dto.setAdditionalRequirements(request.getParameter("additionalRequirements"));
    dto.setStartDate(request.getParameter("startDate"));
    dto.setEndDate(request.getParameter("endDate"));
    dto.setApplicationDeadline(request.getParameter("applicationDeadline"));
    dto.setPositions(Integer.parseInt(request.getParameter("positions")));
    dto.setLocation(request.getParameter("location"));
    dto.setWorkType(request.getParameter("workType"));

    if (isEdit) {
        internshipService.update(id, dto, token);
        session.setAttribute("notification", "Praksa uspješno ažurirana!");
    } else {
        internshipService.create(dto, token);
        session.setAttribute("notification", "Praksa uspješno kreirana!");
    }
    response.sendRedirect("internships.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= formDisabled ? "Detalji prakse" : isEdit ? "Uredi praksu" : "Nova praksa" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body { background-color: #eef2f5; min-height: 100%; }
        .navbar { background-color: #7DAACB !important; }
        .card { border: none; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .btn-primary { background-color: #7DAACB; border-color: #7DAACB; }
        .btn-primary:hover { background-color: #5a8aad; border-color: #5a8aad; }
        .invalid-feedback { font-size: 0.82rem; }
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
        <div class="col-12 col-lg-10">
            <div class="card">
                <div class="card-body p-4">

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-semibold text-secondary mb-0">
                            <%= formDisabled ? "Detalji prakse" : isEdit ? "Uredi praksu" : "Nova praksa" %>
                        </h5>
                        <% if (formDisabled) { %>
                            <span class="badge bg-danger">Završena</span>
                        <% } %>
                    </div>

                    <form method="post" id="internshipForm" novalidate>
                        <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= id %>">
                        <% } %>

                        <% if (formDisabled) { %>
                        <fieldset disabled>
                        <% } %>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label">Naziv prakse *</label>
                                <input type="text" name="title" id="title" class="form-control"
                                       value="<%= isEdit && internship.getTitle() != null ? internship.getTitle() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label">Kratki opis *</label>
                                <input type="text" name="shortDesc" id="shortDesc" class="form-control"
                                       value="<%= isEdit && internship.getShortDesc() != null ? internship.getShortDesc() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Opis *</label>
                            <textarea name="description" id="description" class="form-control" rows="3"><%= isEdit && internship.getDescription() != null ? internship.getDescription() : "" %></textarea>
                            <div class="invalid-feedback">Ovo polje je obavezno.</div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label">Tehnologije *</label>
                                <input type="text" name="technologies" id="technologies" class="form-control"
                                       placeholder="npr. Java, Spring, React"
                                       value="<%= isEdit && internship.getTechnologies() != null ? internship.getTechnologies() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label">Potrebni jezici *</label>
                                <input type="text" name="requiredLanguages" id="requiredLanguages" class="form-control"
                                       placeholder="npr. Engleski, Njemački"
                                       value="<%= isEdit && internship.getRequiredLanguages() != null ? internship.getRequiredLanguages() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label">Lokacija *</label>
                                <input type="text" name="location" id="location" class="form-control"
                                       value="<%= isEdit && internship.getLocation() != null ? internship.getLocation() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label">Tip rada *</label>
                                <select name="workType" class="form-select">
                                    <option value="ON_SITE" <%= isEdit && "ON_SITE".equals(internship.getWorkType()) ? "selected" : "" %>>Na licu mjesta</option>
                                    <option value="REMOTE" <%= isEdit && "REMOTE".equals(internship.getWorkType()) ? "selected" : "" %>>Remote</option>
                                    <option value="HYBRID" <%= isEdit && "HYBRID".equals(internship.getWorkType()) ? "selected" : "" %>>Hibridno</option>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-4">
                                <label class="form-label">Datum početka *</label>
                                <input type="date" name="startDate" id="startDate" class="form-control"
                                       value="<%= isEdit && internship.getStartDate() != null ? internship.getStartDate() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-4">
                                <label class="form-label">Datum završetka *</label>
                                <input type="date" name="endDate" id="endDate" class="form-control"
                                       value="<%= isEdit && internship.getEndDate() != null ? internship.getEndDate() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-4">
                                <label class="form-label">Rok prijave *</label>
                                <input type="date" name="applicationDeadline" id="applicationDeadline" class="form-control"
                                       value="<%= isEdit && internship.getApplicationDeadline() != null ? internship.getApplicationDeadline() : "" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-4">
                                <label class="form-label">Broj mjesta *</label>
                                <input type="number" name="positions" id="positions" class="form-control" min="1"
                                       value="<%= isEdit && internship.getPositions() != null ? internship.getPositions() : "1" %>">
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-4">
                                <label class="form-label">Minimalni GPA</label>
                                <input type="number" name="minGpa" class="form-control" step="0.01" min="5" max="10"
                                       value="<%= isEdit && internship.getMinGpa() != null ? internship.getMinGpa() : "" %>">
                            </div>
                            <div class="col-12 col-md-4">
                                <label class="form-label">Godina studija</label>
                                <select name="requiredYear" class="form-select">
                                    <option value="ANY" <%= isEdit && "ANY".equals(internship.getRequiredYear()) ? "selected" : "" %>>Bilo koja</option>
                                    <option value="1" <%= isEdit && "1".equals(internship.getRequiredYear()) ? "selected" : "" %>>1. godina</option>
                                    <option value="2" <%= isEdit && "2".equals(internship.getRequiredYear()) ? "selected" : "" %>>2. godina</option>
                                    <option value="3" <%= isEdit && "3".equals(internship.getRequiredYear()) ? "selected" : "" %>>3. godina</option>
                                    <option value="4" <%= isEdit && "4".equals(internship.getRequiredYear()) ? "selected" : "" %>>4. godina</option>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label">Uslovi i ograničenja *</label>
                                <textarea name="requirements" id="requirements" class="form-control" rows="2"><%= isEdit && internship.getRequirements() != null ? internship.getRequirements() : "" %></textarea>
                                <div class="invalid-feedback">Ovo polje je obavezno.</div>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label">Dodatni uslovi</label>
                                <textarea name="additionalRequirements" class="form-control" rows="2"><%= isEdit && internship.getAdditionalRequirements() != null ? internship.getAdditionalRequirements() : "" %></textarea>
                            </div>
                        </div>

                        <% if (formDisabled) { %>
                        </fieldset>
                        <% } %>

                        <div class="d-flex gap-2 mt-3">
                            <% if (!formDisabled) { %>
                                <button type="submit" class="btn btn-primary">
                                    <%= isEdit ? "Sačuvaj izmjene" : "Kreiraj praksu" %>
                                </button>
                            <% } %>
                            <a href="internships.jsp" class="btn btn-secondary">
                                <%= formDisabled ? "Nazad" : "Odustani" %>
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
    <% if (!formDisabled) { %>
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('startDate').min = today;
    document.getElementById('endDate').min = today;
    document.getElementById('applicationDeadline').min = today;

    document.getElementById('internshipForm').addEventListener('submit', function(e) {
        let valid = true;
        const requiredFields = ['title', 'shortDesc', 'description', 'technologies',
                                'requiredLanguages', 'location', 'startDate', 'endDate',
                                'applicationDeadline', 'positions', 'requirements'];
        requiredFields.forEach(function(fieldId) {
            const field = document.getElementById(fieldId);
            if (!field) return;
            if (field.value.trim() === '') {
                field.classList.add('is-invalid');
                valid = false;
            } else {
                field.classList.remove('is-invalid');
            }
        });
        if (!valid) e.preventDefault();
    });

    document.querySelectorAll('.form-control').forEach(function(input) {
        input.addEventListener('input', function() {
            this.classList.remove('is-invalid');
        });
    });
    <% } %>
</script>
</body>
</html>