<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Online Quiz System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>Welcome to Online Quiz System</h1>
        
        <% if (session.getAttribute("user") == null) { %>
            <div class="button-group">
                <a href="login.jsp" class="button">Login</a>
                <a href="register.jsp" class="button">Register</a>
            </div>
        <% } else { 
            out.print("Welcome, " + session.getAttribute("username") + "!");
            if (session.getAttribute("is_admin") != null && (Boolean)session.getAttribute("is_admin")) { %>
                <a href="admin/dashboard.jsp" class="button">Admin Dashboard</a>
            <% } %>
            <a href="quiz-list.jsp" class="button">Take Quiz</a>
            <a href="score-chart.jsp" class="button">View Scores</a>
            <a href="LogoutServlet" class="button">Logout</a>
        <% } %>
    </div>
</body>
</html>