<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Online Quiz</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>Register New Account</h2>
        
        <% 
        String error = request.getParameter("error");
        if (error != null) { 
        %>
            <div class="error">
                <% if ("username_exists".equals(error)) { %>
                    Username already exists!
                <% } else if ("registration_failed".equals(error)) { %>
                    Registration failed. Please try again.
                <% } else if ("password_mismatch".equals(error)) { %>
                    Passwords do not match!
                <% } %>
            </div>
        <% } %>
        
        <!-- Updated form action to use the proper context path -->
        <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            
            <button type="submit" class="button">Register</button>
        </form>
        
        <p>Already have an account? <a href="login.jsp">Login here</a></p>
        <p><a href="index.jsp">Back to Home</a></p>
    </div>
    
    <script>
    // Validate passwords match before submitting
    function validateForm() {
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirmPassword").value;
        
        if (password !== confirmPassword) {
            alert("Passwords do not match!");
            return false;
        }
        return true;
    }
    
    document.querySelector("form").onsubmit = validateForm;
    </script>
</body>
</html>