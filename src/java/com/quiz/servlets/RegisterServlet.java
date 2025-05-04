package com.quiz.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quiz.dao.UserDAO;
import com.quiz.model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("register.jsp?error=password_mismatch");
            return;
        }
        
        // Create new user
        User user = new User(username, password);
        UserDAO userDAO = new UserDAO();
        
        // Check if username already exists
        if (userDAO.validateUser(username, password) != null) {
            response.sendRedirect("register.jsp?error=username_exists");
            return;
        }
        
        // Register new user
        boolean success = userDAO.registerUser(user);
        
        if (success) {
            response.sendRedirect("login.jsp?registered=1");
        } else {
            response.sendRedirect("register.jsp?error=registration_failed");
        }
    }
}