package com.quiz.model;

import java.sql.Timestamp;
import java.util.List;

public class Quiz {
    private int id;
    private int userId;
    private int subjectId;
    private Timestamp dateTaken;
    private List<QuizQuestion> questions;
    private int totalScore;
    
    public Quiz() {}
    
    public Quiz(int userId, int subjectId) {
        this.userId = userId;
        this.subjectId = subjectId;
    }
    
    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    public Timestamp getDateTaken() { return dateTaken; }
    public void setDateTaken(Timestamp dateTaken) { this.dateTaken = dateTaken; }
    public List<QuizQuestion> getQuestions() { return questions; }
    public void setQuestions(List<QuizQuestion> questions) { this.questions = questions; }
    public int getTotalScore() { return totalScore; }
    public void setTotalScore(int totalScore) { this.totalScore = totalScore; }
}