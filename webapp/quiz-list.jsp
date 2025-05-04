<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.quiz.db.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Quizzes</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>Select a Subject for Quiz</h2>
        
        <div class="quiz-list">
            <%
            try (Connection conn = DatabaseConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM subjects")) {
                
                while (rs.next()) {
            %>
                <div class="quiz-card">
                    <h3><%= rs.getString("name") %></h3>
                    <p><%= rs.getString("description") %></p>
                    <a href="quiz.jsp?subject_id=<%= rs.getInt("id") %>" class="button">Start Quiz</a>
                </div>
            <%  
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            %>
        </div>
        
        <p><a href="index.jsp" class="button">Back to Home</a></p>
    </div>
</body>
</html>