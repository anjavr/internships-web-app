<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.DiaryService"%>
<%
String token = (String) session.getAttribute("token");
if (token == null) {
    response.sendRedirect("login.jsp");
    return;
}
String diaryId = request.getParameter("diaryId");
String internshipId = request.getParameter("internshipId");
String studentId = request.getParameter("studentId");

DiaryService diaryService = new DiaryService();
diaryService.markFeedbackDone(diaryId, token);
session.setAttribute("notification", "Komentari su zaključani. Student može predati dnevnik.");
response.sendRedirect("worklogs.jsp?internshipId=" + internshipId + "&studentId=" + studentId);
%>