<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.quiz.db.DatabaseConnection" %>
<%
    if (session.getAttribute("is_admin") == null || !(Boolean)session.getAttribute("is_admin")) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Question</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2>Add New Question</h2>
        
        <% if (request.getParameter("success") != null) { %>
            <div class="success">Question added successfully!</div>
        <% } %>
        
        <form action="../AdminServlet" method="post">
            <input type="hidden" name="action" value="addQuestion">
            
            <div class="form-group">
                <label for="subject">Subject:</label>
                <select name="subject_id" id="subject" required>
                    <%
                    try (Connection conn = DatabaseConnection.getConnection();
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT * FROM subjects")) {
                        
                        while (rs.next()) {
                    %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                    <%  
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="question">Question:</label>
                <textarea name="question_text" id="question" rows="3" required></textarea>
            </div>
            
            <div class="form-group">
                <label for="optionA">Option A:</label>
                <input type="text" name="option_a" id="optionA" required>
            </div>
            
            <div class="form-group">
                <label for="optionB">Option B:</label>
                <input type="text" name="option_b" id="optionB" required>
            </div>
            
            <div class="form-group">
                <label for="optionC">Option C:</label>
                <input type="text" name="option_c" id="optionC" required>
            </div>
            
            <div class="form-group">
                <label for="optionD">Option D:</label>
                <input type="text" name="option_d" id="optionD" required>
            </div>
            
            <div class="form-group">
                <label for="correct">Correct Answer:</label>
                <select name="correct_option" id="correct" required>
                    <option value="A">A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                </select>
            </div>
            
            <button type="submit" class="button">Add Question</button>
        </form>
        
        <p><a href="dashboard.jsp" class="button">Back to Dashboard</a></p>
    </div>
</body>
</html>