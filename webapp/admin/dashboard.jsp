<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("is_admin") == null || !(Boolean)session.getAttribute("is_admin")) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h1>Admin Dashboard</h1>
        
        <div class="admin-menu">
            <a href="add-question.jsp" class="button">Add Question</a>
            <a href="manage-questions.jsp" class="button">Manage Questions</a>
            <a href="manage-subjects.jsp" class="button">Manage Subjects</a>
            <a href="view-scores.jsp" class="button">View All Scores</a>
        </div>
        
        <p><a href="../index.jsp" class="button">Back to Home</a></p>
    </div>
</body>
</html>