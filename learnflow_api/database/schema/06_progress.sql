USE learnflow;
-- 06_progress.sql
-- เก็บพัฒนาการรายวัน ใช้สร้าง Line Chart 7 วัน

CREATE TABLE IF NOT EXISTS progress (
    progress_id         INT         NOT NULL AUTO_INCREMENT,
    user_id             INT         NOT NULL,                  
    date                DATE        NOT NULL,                  
    avg_understanding   FLOAT       NOT NULL DEFAULT 0,       

    PRIMARY KEY (progress_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE KEY uq_user_date (user_id, date)
);

-- Index ช่วยให้ดึงข้อมูล 7 วันย้อนหลังเร็วขึ้น
CREATE INDEX idx_progress_user_date ON progress (user_id, date);