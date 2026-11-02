kako treba da izgleda logout.jsp4:31 PMClaude responded: Samo ove dvije linije — invalidira sesiju i preusmjerava na login.jsp<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
session.invalidate();
response.sendRedirect("login.jsp");
%>