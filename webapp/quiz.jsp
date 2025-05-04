<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.quiz.dao.QuestionDAO, com.quiz.model.Question" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <%
        int subjectId = Integer.parseInt(request.getParameter("subject_id"));
        QuestionDAO questionDAO = new QuestionDAO();
        List<Question> questions = questionDAO.getQuestionsBySubject(subjectId);
        
        if (request.getParameter("q") == null) {
            // Start new quiz
            session.setAttribute("questions", questions);
            session.setAttribute("currentQuestion", 0);
            session.setAttribute("correctAnswers", 0);
            session.setAttribute("quizStarted", true);
        %>
            <h2>Quiz Started!</h2>
            <p>Number of questions: <%= questions.size() %></p>
            <a href="quiz.jsp?subject_id=<%= subjectId %>&amp;q=0" class="button">Start</a>
        <%
        } else {
            int currentIndex = Integer.parseInt(request.getParameter("q"));
            List<Question> sessionQuestions = (List<Question>) session.getAttribute("questions");
            int correctAnswers = (Integer) session.getAttribute("correctAnswers");
            
            // Check previous answer if any
            if (request.getParameter("answer") != null) {
                Question prevQuestion = sessionQuestions.get(currentIndex - 1);
                String userAnswer = request.getParameter("answer");
                if (userAnswer.equals(prevQuestion.getCorrectOption())) {
                    correctAnswers++;
                    session.setAttribute("correctAnswers", correctAnswers);
                }
            }
            
            if (currentIndex < sessionQuestions.size()) {
                Question question = sessionQuestions.get(currentIndex);
        %>
                <h2>Question <%= currentIndex + 1 %> of <%= sessionQuestions.size() %></h2>
                <div class="question">
                    <p><%= question.getQuestionText() %></p>
                    <form action="quiz.jsp" method="get">
                        <input type="hidden" name="subject_id" value="<%= subjectId %>">
                        <input type="hidden" name="q" value="<%= currentIndex + 1 %>">
                        
                        <div class="option">
                            <input type="radio" name="answer" value="A" id="optA" required>
                            <label for="optA">A. <%= question.getOptionA() %></label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" name="answer" value="B" id="optB">
                            <label for="optB">B. <%= question.getOptionB() %></label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" name="answer" value="C" id="optC">
                            <label for="optC">C. <%= question.getOptionC() %></label>
                        </div>
                        
                        <div class="option">
                            <input type="radio" name="answer" value="D" id="optD">
                            <label for="optD">D. <%= question.getOptionD() %></label>
                        </div>
                        
                        <button type="submit" class="button">
                            <%= currentIndex == sessionQuestions.size() - 1 ? "Finish" : "Next" %>
                        </button>
                    </form>
                </div>
        <%
            } else {
                // Quiz completed, save score
                int userId = (Integer) session.getAttribute("user_id");
                int totalQuestions = sessionQuestions.size();
                int score = correctAnswers;
                
                // Save to database
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
                    scoreStmt.setInt(3, score);
                    scoreStmt.executeUpdate();
                    
                    conn.commit();
                    quizStmt.close();
                    scoreStmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                
                // Clear session
                session.removeAttribute("questions");
                session.removeAttribute("currentQuestion");
                session.removeAttribute("correctAnswers");
                session.removeAttribute("quizStarted");
        %>
                <h2>Quiz Completed!</h2>
                <div class="result">
                    <p>Your Score: <%= score %> out of <%= totalQuestions %></p>
                    <p>Percentage: <%= (score * 100) / totalQuestions %>%</p>
                </div>
                <a href="quiz-list.jsp" class="button">Take Another Quiz</a>
                <a href="score-chart.jsp" class="button">View All Scores</a>
        <%
            }
        }
        %>
    </div>
</body>
</html>