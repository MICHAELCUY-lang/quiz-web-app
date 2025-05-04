package com.quiz.dao;

import com.quiz.db.DatabaseConnection;
import com.quiz.model.Score;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScoreDAO {
    
    public boolean saveScore(Score score) {
        String sql = "INSERT INTO scores (quiz_id, user_id, total_score) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, score.getQuizId());
            stmt.setInt(2, score.getUserId());
            stmt.setInt(3, score.getTotalScore());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Score> getUserScores(int userId) {
        List<Score> scores = new ArrayList<>();
        String sql = "SELECT * FROM scores WHERE user_id = ? ORDER BY date_taken_quiz DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Score score = new Score();
                score.setId(rs.getInt("id"));
                score.setQuizId(rs.getInt("quiz_id"));
                score.setUserId(rs.getInt("user_id"));
                score.setTotalScore(rs.getInt("total_score"));
                score.setDateTakenQuiz(rs.getTimestamp("date_taken_quiz"));
                scores.add(score);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return scores;
    }
}