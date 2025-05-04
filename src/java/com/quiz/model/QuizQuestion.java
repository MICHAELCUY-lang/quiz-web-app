package com.quiz.model;

public class QuizQuestion {
    private int id;
    private int quizId;
    private int questionId;
    private String userAnswer;
    private boolean isCorrect;
    
    public QuizQuestion() {}
    
    public QuizQuestion(int quizId, int questionId, String userAnswer, boolean isCorrect) {
        this.quizId = quizId;
        this.questionId = questionId;
        this.userAnswer = userAnswer;
        this.isCorrect = isCorrect;
    }
    
    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public String getUserAnswer() { return userAnswer; }
    public void setUserAnswer(String userAnswer) { this.userAnswer = userAnswer; }
    public boolean isCorrect() { return isCorrect; }
    public void setCorrect(boolean correct) { isCorrect = correct; }
}