<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.ApplicationService"%>
<%
String token = (String) session.getAttribute("token");
if (token == null) {
    response.sendRedirect("login.jsp");
    return;
}
String id = request.getParameter("id");
String internshipId = request.getParameter("internshipId");
ApplicationService applicationService = new ApplicationService();
applicationService.reject(id, token);
session.setAttribute("notification", "Prijava odbijena!");
response.sendRedirect("applications.jsp?internshipId=" + internshipId);
%>