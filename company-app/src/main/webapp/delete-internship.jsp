<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.InternshipService"%>
<%
String token = (String) session.getAttribute("token");
if (token == null) {
    response.sendRedirect("login.jsp");
    return;
}
String id = request.getParameter("id");
InternshipService internshipService = new InternshipService();
internshipService.deleteInternship(id, token);
session.setAttribute("notification", "Praksa uspješno obrisana!");
response.sendRedirect("internships.jsp");
%>