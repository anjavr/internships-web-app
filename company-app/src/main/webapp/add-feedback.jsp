<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.WorkLogService"%>
<%
String token = (String) session.getAttribute("token");
if (token == null) {
	response.sendRedirect("login.jsp");
	return;
}
String workLogId = request.getParameter("workLogId");
String feedback = request.getParameter("feedback");
String internshipId = request.getParameter("internshipId");
String studentId = request.getParameter("studentId");

WorkLogService workLogService = new WorkLogService();
workLogService.addFeedback(workLogId, feedback, token);
session.setAttribute("notification", "Komentar uspješno sačuvan!");
response.sendRedirect("worklogs.jsp?internshipId=" + internshipId + "&studentId=" + studentId);
%>