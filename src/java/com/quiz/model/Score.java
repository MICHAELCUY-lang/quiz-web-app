package com.quiz.model;

import java.sql.Timestamp;

public class Score {
    private int id;
    private int quizId;
    private int userId;
    private int totalScore;
    private Timestamp dateTakenQuiz;
    
    // Constructors, getters, and setters
    public Score() {}
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getTotalScore() { return totalScore; }
    public void setTotalScore(int totalScore) { this.totalScore = totalScore; }
    public Timestamp getDateTakenQuiz() { return dateTakenQuiz; }
    public void setDateTakenQuiz(Timestamp dateTakenQuiz) { this.dateTakenQuiz = dateTakenQuiz; }
}