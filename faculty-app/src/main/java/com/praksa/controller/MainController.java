package com.praksa.controller;

import jakarta.servlet.RequestDispatcher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.List;
import com.praksa.service.*;
import com.praksa.beans.CompanyBean;
import com.praksa.beans.InternshipBean;
import com.praksa.beans.StudentBean;
import com.praksa.beans.EvaluationBean;
import com.praksa.dto.*;

@MultipartConfig // za csv upload
@WebServlet("/MainController")
public class MainController extends HttpServlet {

	//jsp stranice
	private static final String LOGIN = "/WEB-INF/pages/login.jsp";
	private static final String DASHBOARD = "/WEB-INF/pages/dashboard.jsp";
	private static final String COMPANIES = "/WEB-INF/pages/companies.jsp";
	private static final String COMPANY_FORM = "/WEB-INF/pages/company-form.jsp";
	private static final String INTERNSHIPS = "/WEB-INF/pages/internships.jsp";
	private static final String INTERNSHIP = "/WEB-INF/pages/internship.jsp";
	private static final String STUDENTS = "/WEB-INF/pages/students.jsp";
	private static final String STUDENT_FORM = "/WEB-INF/pages/student-form.jsp";
	private static final String EVALUATIONS = "/WEB-INF/pages/evaluations.jsp";
	private static final String EVALUATION = "/WEB-INF/pages/evaluation.jsp";
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");

		String action = req.getParameter("action");
		HttpSession session = req.getSession();

		String address = LOGIN;

		if (action == null || action.isEmpty()) {
			address = LOGIN;

		} else if (action.equals("login")) {
			String username = req.getParameter("username");
			String password = req.getParameter("password");

			AuthService authService = new AuthService();
			try {
				LoginResponseDTO response = authService.login(username, password); // promijeni return tip
		        session.setAttribute("token", response.getToken());
		        session.setAttribute("userId", response.getUserId()); // DODAJ OVO
				session.setAttribute("companyBean", new CompanyBean());
				session.setAttribute("internshipBean", new InternshipBean());
				session.setAttribute("studentBean", new StudentBean());
				session.setAttribute("evaluationBean", new EvaluationBean());
			    address = DASHBOARD;
			} catch (Exception e) {
				session.setAttribute("error", "Pogrešno korisničko ime ili lozinka");
				address = LOGIN;
			}
		} else if (action.equals("logout")) {
			session.invalidate();
			address = LOGIN;
		} else {
		    String token = (String) session.getAttribute("token");
		    if (token == null || token.isEmpty()) {
		        address = LOGIN;
		    } else {
		        try {
		            address = handleAuthenticatedAction(action, req, session);
		        } catch (Exception e) {
		            e.printStackTrace();
		            session.setAttribute("error", "Greška na serveru");
		            address = LOGIN;
		        }
		    }
		}

		RequestDispatcher dispatcher = req.getRequestDispatcher(address);
		dispatcher.forward(req, resp);
	}

	private String handleAuthenticatedAction(String action, HttpServletRequest req, HttpSession session)
			throws Exception {

		String token = (String) session.getAttribute("token");
		CompanyService companyService = new CompanyService();

		if (action.equals("companies")) {
			CompanyBean bean = (CompanyBean) session.getAttribute("companyBean");
		    bean.getAll(token);
		    return COMPANIES;

		} else if (action.equals("new-company")) {
			CompanyBean bean = (CompanyBean) session.getAttribute("companyBean");
		    bean.setCompany(null);
		    return COMPANY_FORM;
		    
		} else if (action.equals("edit-company")) {
			 CompanyBean bean = (CompanyBean) session.getAttribute("companyBean");
			 String id = req.getParameter("id");
			 bean.getById(id, token);
			 return COMPANY_FORM;

		} else if (action.equals("create-company")) {
			CompanyBean bean = (CompanyBean) session.getAttribute("companyBean");
		    
		    CompanyDTO company = new CompanyDTO();
		    company.setName(req.getParameter("name"));
		    company.setDescription(req.getParameter("description"));
		    company.setContactEmail(req.getParameter("contactEmail"));
		    company.setContactPhone(req.getParameter("contactPhone"));
		    company.setAddress(req.getParameter("address"));
		    company.setUsername(req.getParameter("username"));
		    company.setPassword(req.getParameter("password"));
		    company.setEmail(req.getParameter("contactEmail"));
		    
		    bean.create(company, token);
		    session.setAttribute("notification", "Kompanija uspješno kreirana!");
		    return COMPANIES;

		} else if (action.equals("update-company")) {
			CompanyBean bean = (CompanyBean) session.getAttribute("companyBean");

		    CompanyDTO company = new CompanyDTO();
		    company.setName(req.getParameter("name"));
		    company.setDescription(req.getParameter("description"));
		    company.setContactEmail(req.getParameter("contactEmail"));
		    company.setContactPhone(req.getParameter("contactPhone"));
		    company.setAddress(req.getParameter("address"));

		    bean.update(bean.getCompany().getId(), company, token);
		    session.setAttribute("notification", "Kompanija uspješno ažurirana!");
		    return COMPANIES;

		} else if (action.equals("toggle-active")) {
			CompanyBean bean = (CompanyBean) session.getAttribute("companyBean");
		    String id = req.getParameter("id");
		    boolean active = Boolean.parseBoolean(req.getParameter("active"));
		    bean.setActive(id, active, token);
		    session.setAttribute("notification", 
		            active ? "Nalog uspješno aktiviran!" : "Nalog uspješno deaktiviran!");
		    return COMPANIES;
		    
		} else if (action.equals("internships")) {
		    InternshipBean bean = (InternshipBean) session.getAttribute("internshipBean");
		    bean.getAllForFaculty(token);
		    return INTERNSHIPS;

		} else if (action.equals("internship")) {
		    InternshipBean bean = (InternshipBean) session.getAttribute("internshipBean");
		    String id = req.getParameter("id");
		    bean.getById(id, token);
		    return INTERNSHIP;
		} else if (action.equals("students")) {
		    StudentBean bean = (StudentBean) session.getAttribute("studentBean");
		    bean.getAll(token);
		    return STUDENTS;

		} else if (action.equals("new-student")) {
		    StudentBean bean = (StudentBean) session.getAttribute("studentBean");
		    bean.setStudent(null);
		    return STUDENT_FORM;

		} else if (action.equals("edit-student")) {
		    StudentBean bean = (StudentBean) session.getAttribute("studentBean");
		    String id = req.getParameter("id");
		    bean.getById(id, token);
		    return STUDENT_FORM;

		} else if (action.equals("create-student")) {
		    StudentBean bean = (StudentBean) session.getAttribute("studentBean");
		    StudentDTO student = new StudentDTO();
		    student.setFullName(req.getParameter("fullName"));
		    student.setEmail(req.getParameter("email"));
		    student.setUsername(req.getParameter("username"));
		    student.setPassword(req.getParameter("password"));
		    student.setPhone(req.getParameter("phone"));
		    student.setAddress(req.getParameter("address"));
		    bean.create(student, token);
		    return STUDENTS;

		} else if (action.equals("update-student")) {
		    StudentBean bean = (StudentBean) session.getAttribute("studentBean");
		    StudentDTO student = new StudentDTO();
		    student.setFullName(req.getParameter("fullName"));
		    student.setEmail(req.getParameter("email"));
		    student.setUsername(req.getParameter("username"));
		    student.setPhone(req.getParameter("phone"));
		    student.setAddress(req.getParameter("address"));
		    bean.update(bean.getStudent().getId(), student, token);
		    return STUDENTS;

		} else if (action.equals("delete-student")) {
		    StudentBean bean = (StudentBean) session.getAttribute("studentBean");
		    String id = req.getParameter("id");
		    bean.delete(id, token);
		    session.setAttribute("notification", "Student uspješno obrisan!");
		    return STUDENTS;
		    
		} else if (action.equals("upload-csv")) {
		    try {
		        Part filePart = req.getPart("file");
		        byte[] csvBytes = filePart.getInputStream().readAllBytes();
		        StudentService studentService = new StudentService();
		        studentService.uploadCsv(csvBytes, token);
		        session.setAttribute("notification", "Studenti uspješno uvezeni!");
		    } catch (Exception e) {
		        e.printStackTrace();
		        session.setAttribute("notification", "Greška pri uvozu fajla!");
		    }
		    StudentBean bean = (StudentBean) session.getAttribute("studentBean");
		    bean.getAll(token);
		    return STUDENTS;
		} else if (action.equals("evaluations")) {
		    EvaluationBean bean = (EvaluationBean) session.getAttribute("evaluationBean");
		    bean.getAccepted(token);
		    return EVALUATIONS;

		} else if (action.equals("evaluation")) {
		    EvaluationBean bean = (EvaluationBean) session.getAttribute("evaluationBean");
		    String studentId = req.getParameter("studentId");
		    String internshipId = req.getParameter("internshipId");

		    ApplicationDTO selected = bean.getApplications().stream()
		            .filter(a -> a.getStudentId().equals(studentId) &&
		                        a.getInternshipId().equals(internshipId))
		            .findFirst().orElse(null);
		    bean.setSelectedApplication(selected);
		    bean.getWorkLogsByInternship(studentId, internshipId, token);

		    try {
		        bean.getEvaluation(studentId, internshipId, token);
		    } catch (Exception e) {
		        bean.setEvaluation(null);
		    }
		    return EVALUATION;

		} else if (action.equals("save-evaluation")) {
		    EvaluationBean bean = (EvaluationBean) session.getAttribute("evaluationBean");
		    ApplicationDTO app = bean.getSelectedApplication();

		    EvaluationDTO dto = new EvaluationDTO();
		    dto.setStudentId(app.getStudentId());
		    dto.setInternshipId(app.getInternshipId());
		    dto.setRating(Short.parseShort(req.getParameter("rating")));
		    dto.setComments(req.getParameter("comments"));

		    bean.saveEvaluation(dto, token);
		    session.setAttribute("notification", "Ocjena uspješno sačuvana!");
		    return EVALUATION;
		}

		return DASHBOARD;
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}