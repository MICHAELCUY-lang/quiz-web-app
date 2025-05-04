-- database.sql

CREATE DATABASE quiz_db;
USE quiz_db;

-- Users table (Master table)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subjects table
CREATE TABLE subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Questions table (Master table)
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    question_text TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES subjects(id)
);

-- Quiz table (Transaction table)
CREATE TABLE quizzes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    subject_id INT,
    date_taken TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (subject_id) REFERENCES subjects(id)
);

-- Quiz questions table (Transaction detail)
CREATE TABLE quiz_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id INT,
    question_id INT,
    user_answer CHAR(1),
    is_correct BOOLEAN,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- Scores table (Transaction table)
CREATE TABLE scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id INT,
    user_id INT,
    total_score INT,
    date_taken_quiz TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert default admin user
INSERT INTO users (username, password, is_admin) VALUES 
('admin', 'admin123', TRUE);

-- Insert sample subjects
INSERT INTO subjects (name, description) VALUES 
('Java Programming', 'Questions about Java programming'),
('Database', 'Database and SQL questions'),
('Web Development', 'HTML, CSS, JavaScript questions');