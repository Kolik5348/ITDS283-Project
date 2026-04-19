USE learnflow;
-- 03_quiz_system.sql

CREATE TABLE IF NOT EXISTS quizzes (
    quiz_id         INT             NOT NULL AUTO_INCREMENT,
    subject_id      INT             NOT NULL,                  
    title           VARCHAR(255)    NOT NULL,
    level           ENUM('easy', 'medium', 'hard') NOT NULL,
    total_questions INT             NOT NULL DEFAULT 0,        

    PRIMARY KEY (quiz_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE IF NOT EXISTS questions (
    question_id     INT             NOT NULL AUTO_INCREMENT,
    quiz_id         INT             NOT NULL,
    topic           VARCHAR(100)    NOT NULL,
    question_text   TEXT            NOT NULL,
    correct_choice  VARCHAR(1)      NOT NULL,
    explanation     TEXT            NULL,
    expected_time   FLOAT           NOT NULL DEFAULT 30,

    PRIMARY KEY (question_id),
    FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id)
);

CREATE TABLE IF NOT EXISTS choices (
    choice_id       INT             NOT NULL AUTO_INCREMENT,
    question_id     INT             NOT NULL,
    choice_label    VARCHAR(1)      NOT NULL,
    choice_text     VARCHAR(500)    NOT NULL,

    PRIMARY KEY (choice_id),
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

CREATE INDEX idx_questions_quiz_id ON questions (quiz_id);
CREATE INDEX idx_choices_question_id ON choices (question_id);
