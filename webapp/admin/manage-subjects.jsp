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
    <title>Manage Subjects</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="container">
        <h2>Manage Subjects</h2>
        
        <% if (request.getParameter("success") != null) { %>
            <div class="success">Subject added successfully!</div>
        <% } %>
        
        <div class="add-subject-form">
            <h3>Add New Subject</h3>
            <form action="../AdminServlet" method="post">
                <input type="hidden" name="action" value="addSubject">
                
                <div class="form-group">
                    <label for="name">Subject Name:</label>
                    <input type="text" name="name" id="name" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea name="description" id="description" rows="3"></textarea>
                </div>
                
                <button type="submit" class="button">Add Subject</button>
            </form>
        </div>
        
        <div class="subject-list">
            <h3>Existing Subjects</h3>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try (Connection conn = DatabaseConnection.getConnection();
                         Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT * FROM subjects")) {
                        
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("description") %></td>
                        <td>
                            <a href="../AdminServlet?action=deleteSubject&id=<%= rs.getInt("id") %>" 
                               onclick="return confirm('Are you sure you want to delete this subject?')" 
                               class="button delete">Delete</a>
                        </td>
                    </tr>
                    <%  
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    %>
                </tbody>
            </table>
        </div>
        
        <p><a href="dashboard.jsp" class="button">Back to Dashboard</a></p>
    </div>
</body>
</html>