package com.quiz.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quiz.dao.QuestionDAO;
import com.quiz.db.DatabaseConnection;
import com.quiz.model.Question;

@WebServlet("/QuizServlet")
public class QuizServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if ("start".equals(action)) {
            startQuiz(request, response);
        } else {
            response.sendRedirect("quiz-list.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            submitQuiz(request, response);
        } else if ("next".equals(action)) {
            nextQuestion(request, response);
        }
    }
    
    private void startQuiz(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int subjectId = Integer.parseInt(request.getParameter("subject_id"));
        
        QuestionDAO questionDAO = new QuestionDAO();
        List<Question> questions = questionDAO.getQuestionsBySubject(subjectId);
        
        HttpSession session = request.getSession();
        session.setAttribute("quizQuestions", questions);
        session.setAttribute("currentQuestion", 0);
        session.setAttribute("correctAnswers", 0);
        session.setAttribute("startTime", System.currentTimeMillis());
        
        response.sendRedirect("quiz.jsp");
    }
    
    private void nextQuestion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
        int currentQuestion = (Integer) session.getAttribute("currentQuestion");
        int correctAnswers = (Integer) session.getAttribute("correctAnswers");
        
        // Check answer
        String userAnswer = request.getParameter("answer");
        if (userAnswer != null && questions != null && currentQuestion < questions.size()) {
            Question question = questions.get(currentQuestion);
            if (userAnswer.equals(question.getCorrectOption())) {
                correctAnswers++;
                session.setAttribute("correctAnswers", correctAnswers);
            }
        }
        
        currentQuestion++;
        session.setAttribute("currentQuestion", currentQuestion);
        
        response.sendRedirect("quiz.jsp");
    }
    
    private void submitQuiz(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Question> questions = (List<Question>) session.getAttribute("quizQuestions");
        int currentQuestion = (Integer) session.getAttribute("currentQuestion");
        int correctAnswers = (Integer) session.getAttribute("correctAnswers");
        
        // Check last answer
        String userAnswer = request.getParameter("answer");
        if (userAnswer != null && questions != null && currentQuestion < questions.size()) {
            Question question = questions.get(currentQuestion);
            if (userAnswer.equals(question.getCorrectOption())) {
                correctAnswers++;
            }
        }
        
        int userId = (Integer) session.getAttribute("user_id");
        int subjectId = Integer.parseInt(request.getParameter("subject_id"));
        long endTime = System.currentTimeMillis();
        long startTime = (Long) session.getAttribute("startTime");
        long duration = (endTime - startTime) / 1000; // Convert to seconds
        
        // Save quiz result
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            // Create quiz entry
            PreparedStatement quizStmt = conn.prepareStatement(
                "INSERT INTO quizzes (user_id, subject_id) VALUES (?, ?)", 
                Statement.RETURN_GENERATED_KEYS
            );
            quizStmt.setInt(1, userId);
            quizStmt.setInt(2, subjectId);
            quizStmt.executeUpdate();
            
            ResultSet rs = quizStmt.getGeneratedKeys();
            int quizId = 0;
            if (rs.next()) {
                quizId = rs.getInt(1);
            }
            
            // Save score
            PreparedStatement scoreStmt = conn.prepareStatement(
                "INSERT INTO scores (quiz_id, user_id, total_score) VALUES (?, ?, ?)"
            );
            scoreStmt.setInt(1, quizId);
            scoreStmt.setInt(2, userId);
            scoreStmt.setInt(3, correctAnswers);
            scoreStmt.executeUpdate();
            
            conn.commit();
            quizStmt.close();
            scoreStmt.close();
            
            // Store quiz result in session for result page
            session.setAttribute("quizId", quizId);
            session.setAttribute("finalScore", correctAnswers);
            session.setAttribute("totalQuestions", questions.size());
            session.setAttribute("quizDuration", duration);
            
            // Clear quiz session data
            session.removeAttribute("quizQuestions");
            session.removeAttribute("currentQuestion");
            session.removeAttribute("correctAnswers");
            session.removeAttribute("startTime");
            
            response.sendRedirect("result.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("quiz.jsp?error=1");
        }
    }
}