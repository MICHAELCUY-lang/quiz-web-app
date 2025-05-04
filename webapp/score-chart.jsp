<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.quiz.db.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Score Chart</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="container">
        <h2>Your Quiz Scores</h2>
        
        <canvas id="scoreChart"></canvas>
        
        <%
        int userId = (Integer) session.getAttribute("user_id");
        List<Integer> scores = new ArrayList<>();
        List<String> dates = new ArrayList<>();
        List<String> subjects = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT s.total_score, s.date_taken_quiz, sub.name " +
                 "FROM scores s " +
                 "JOIN quizzes q ON s.quiz_id = q.id " +
                 "JOIN subjects sub ON q.subject_id = sub.id " +
                 "WHERE s.user_id = ? ORDER BY s.date_taken_quiz DESC LIMIT 10")) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                scores.add(rs.getInt("total_score"));
                dates.add(rs.getTimestamp("date_taken_quiz").toString());
                subjects.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        %>
        
        <script>
        const ctx = document.getElementById('scoreChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: <%= dates.toString() %>,
                datasets: [{
                    label: 'Quiz Scores',
                    data: <%= scores.toString() %>,
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    title: {
                        display: true,
                        text: 'Your Recent Quiz Scores'
                    }
                }
            }
        });
        </script>
        
        <div class="score-details">
            <h3>Recent Quiz Details</h3>
            <table class="score-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Subject</th>
                        <th>Score</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for (int i = 0; i < scores.size(); i++) {
                    %>
                    <tr>
                        <td><%= dates.get(i) %></td>
                        <td><%= subjects.get(i) %></td>
                        <td><%= scores.get(i) %></td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
        </div>
        
        <p><a href="index.jsp" class="button">Back to Home</a></p>
    </div>
</body>
</html>