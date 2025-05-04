<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, com.quiz.db.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Results</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer finalScore = (Integer) session.getAttribute("finalScore");
    Integer totalQuestions = (Integer) session.getAttribute("totalQuestions");
    Long duration = (Long) session.getAttribute("quizDuration");
    Integer quizId = (Integer) session.getAttribute("quizId");
    
    if (finalScore == null || totalQuestions == null) {
        response.sendRedirect("quiz-list.jsp");
        return;
    }
    
    // Get subject name
    String subjectName = "";
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(
             "SELECT s.name FROM subjects s " +
             "JOIN quizzes q ON s.id = q.subject_id " +
             "WHERE q.id = ?")) {
        
        stmt.setInt(1, quizId);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            subjectName = rs.getString("name");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    %>
    
    <div class="container">
        <h1>Quiz Results</h1>
        
        <div class="result-card">
            <h2>Congratulations!</h2>
            
            <div class="score-summary">
                <div class="score-item">
                    <h3>Subject</h3>
                    <p><%= subjectName %></p>
                </div>
                
                <div class="score-item">
                    <h3>Your Score</h3>
                    <p><%= finalScore %> out of <%= totalQuestions %></p>
                </div>
                
                <div class="score-item">
                    <h3>Percentage</h3>
                    <p><%= (finalScore * 100) / totalQuestions %>%</p>
                </div>
                
                <% if (duration != null) { %>
                <div class="score-item">
                    <h3>Time Taken</h3>
                    <p><%= duration / 60 %> minutes <%= duration % 60 %> seconds</p>
                </div>
                <% } %>
            </div>
            
            <div class="result-actions">
                <a href="quiz-list.jsp" class="button">Take Another Quiz</a>
                <a href="score-chart.jsp" class="button">View All Scores</a>
                <a href="index.jsp" class="button">Back to Home</a>
            </div>
        </div>
        
        <% 
        // Provide feedback based on score
        int percentage = (finalScore * 100) / totalQuestions;
        String feedback = "";
        String feedbackClass = "";
        
        if (percentage >= 90) {
            feedback = "Excellent! You've shown outstanding knowledge.";
            feedbackClass = "feedback-excellent";
        } else if (percentage >= 80) {
            feedback = "Great job! You have a strong understanding of the subject.";
            feedbackClass = "feedback-good";
        } else if (percentage >= 70) {
            feedback = "Good work! Keep studying to improve further.";
            feedbackClass = "feedback-average";
        } else if (percentage >= 60) {
            feedback = "You passed! Consider reviewing the topics you found challenging.";
            feedbackClass = "feedback-pass";
        } else {
            feedback = "Keep trying! Review the material and attempt again.";
            feedbackClass = "feedback-fail";
        }
        %>
        
        <div class="feedback <%= feedbackClass %>">
            <h3>Performance Feedback</h3>
            <p><%= feedback %></p>
        </div>
    </div>
    
    <% 
    // Clear the results from session after displaying
    session.removeAttribute("quizId");
    session.removeAttribute("finalScore");
    session.removeAttribute("totalQuestions");
    session.removeAttribute("quizDuration");
    %>
</body>
</html>