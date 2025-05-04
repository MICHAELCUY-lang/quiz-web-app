package com.quiz.servlets;

import com.quiz.dao.QuestionDAO;
import com.quiz.db.DatabaseConnection;
import com.quiz.model.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("addQuestion".equals(action)) {
            Question question = new Question();
            question.setSubjectId(Integer.parseInt(request.getParameter("subject_id")));
            question.setQuestionText(request.getParameter("question_text"));
            question.setOptionA(request.getParameter("option_a"));
            question.setOptionB(request.getParameter("option_b"));
            question.setOptionC(request.getParameter("option_c"));
            question.setOptionD(request.getParameter("option_d"));
            question.setCorrectOption(request.getParameter("correct_option"));
            
            QuestionDAO questionDAO = new QuestionDAO();
            if (questionDAO.addQuestion(question)) {
                response.sendRedirect("admin/add-question.jsp?success=1");
            } else {
                response.sendRedirect("admin/add-question.jsp?error=1");
            }
        } else if ("addSubject".equals(action)) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO subjects (name, description) VALUES (?, ?)")) {
                
                stmt.setString(1, name);
                stmt.setString(2, description);
                stmt.executeUpdate();
                
                response.sendRedirect("admin/manage-subjects.jsp?success=1");
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("admin/manage-subjects.jsp?error=1");
            }
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("deleteSubject".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("DELETE FROM subjects WHERE id = ?")) {
                
                stmt.setInt(1, id);
                stmt.executeUpdate();
                
                response.sendRedirect("admin/manage-subjects.jsp?success=1");
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("admin/manage-subjects.jsp?error=1");
            }
        }
    }
}