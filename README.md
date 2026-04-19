# LearnFlow 📚

> ระบบฝึกสอบออนไลน์ที่ช่วยติดตามพัฒนาการและแนะนำเนื้อหาตามจุดอ่อนของผู้เรียน

**Flutter** · **Flask** · **MySQL** · **Firebase**

---

## สารบัญ

- [LearnFlow 📚](#learnflow-)
  - [สารบัญ](#สารบัญ)
  - [ฟีเจอร์](#ฟีเจอร์)
  - [Tech Stack](#tech-stack)
  - [โครงสร้างโปรเจกต์](#โครงสร้างโปรเจกต์)
  - [AI Scoring Engine](#ai-scoring-engine)
  - [API Reference](#api-reference)
    - [Authentication](#authentication)
    - [Quiz](#quiz)
    - [Results \& Analytics](#results--analytics)
  - [การติดตั้งและรัน](#การติดตั้งและรัน)
    - [1. ตั้งค่า Database](#1-ตั้งค่า-database)
    - [2. ตั้งค่า Backend](#2-ตั้งค่า-backend)
    - [3. ตั้งค่า Flutter App](#3-ตั้งค่า-flutter-app)
  - [Troubleshooting](#troubleshooting)

---

## ฟีเจอร์

| ฟีเจอร์ | รายละเอียด |
|---|---|
| 🔐 Authentication | ล็อกอินด้วย Google / Email ผ่าน Firebase |
| 📝 Quiz System | ทำแบบทดสอบพร้อม Timer countdown, วัด Response Time รายข้อ, รองรับ Retake และ Cache คำตอบก่อนส่ง API |
| 🤖 AI Scoring Engine | คำนวณ Understanding Score จาก Accuracy (60%) + Speed (40%) แยกตามระดับความยาก |
| 📊 Analytics Dashboard | กราฟ Bar / Radar / Growth วิเคราะห์พัฒนาการ |
| 🎯 Smart Recommendations | แนะนำ Quiz อัตโนมัติตาม Mastery Level (Strong / Improving / Weak) |
| 🔔 Daily Reminder | แจ้งเตือนให้ทำ Quiz ทุกวัน 09:00 น. (Asia/Bangkok) รองรับ Android 15 |
| ⚡ Cache System | In-memory cache พร้อม TTL ลดการยิง API ซ้ำ และล้าง cache อัตโนมัติหลังทำ Quiz เสร็จ |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter / Dart |
| Backend | Python Flask |
| Database | MySQL 8.0 |
| Authentication | Firebase Auth |
| Charts | fl_chart |
| Platform | Android / iOS |

---

## โครงสร้างโปรเจกต์

```
ITDS283-Project/
├── learnflow/                        # Flutter App
│   └── lib/
│       ├── pages/                    # UI Pages
│       │   ├── HomePage.dart         # Dashboard + Recommendations
│       │   ├── QuizPlayPage.dart     # หน้าทำข้อสอบ
│       │   ├── ResultPage.dart       # ผลลัพธ์และเฉลย
│       │   └── Analyticspage.dart    # กราฟวิเคราะห์
│       ├── services/                 # API Client, Cache, Notification
│       ├── providers/                # State Management (Auth, Quiz, Theme)
│       └── widgets/                  # Shared Widgets (BottomNav)
│
└── learnflow_api/                    # Flask Backend
    ├── app.py                        # Entry point
    ├── routes/                       # Endpoints (auth, quiz, result, analysis)
    ├── services/
    │   ├── ai_service.py             # คำนวณ Accuracy / Speed / Understanding
    │   └── progress_service.py       # บันทึก Mastery และ Progress รายวัน
    ├── middleware/
    │   └── auth_middleware.py        # Firebase Token Verification
    └── database/
        ├── schema/                   # SQL Schema 7 ไฟล์
        └── seeds/                    # Seed Data
```

---

## AI Scoring Engine

ระบบคำนวณคะแนนความเข้าใจของผู้เรียนจาก 2 ปัจจัย คือความถูกต้องและความเร็วในการตอบ

```python
# Understanding Score ต่อ 1 ข้อ
understanding = (0.6 × accuracy) + (0.4 × speed)

# Topic Mastery = เฉลี่ย Understanding ทุกข้อในวิชานั้น
mastery = sum(understanding_scores) / len(understanding_scores)

# แปลงเป็น Level
> 0.80  →  Strong    (action: pass)
≥ 0.60  →  Improving (action: review)
< 0.60  →  Weak      (action: practice)
```

ผลลัพธ์ถูกบันทึกแยกตามระดับความยาก (Easy / Medium / Hard) เพื่อให้เห็นจุดอ่อนในแต่ละระดับ และใช้สร้าง Recommendation อัตโนมัติ

---

## API Reference

### Authentication
```
POST  /api/auth/login           ล็อกอิน + sync user
POST  /api/auth/register        สมัครสมาชิก
```

### Quiz
```
GET   /api/quizzes?page=1       รายการ quiz (pagination)
GET   /api/quiz/<id>            รายละเอียด quiz + คำถาม + ตัวเลือก + time limit
GET   /api/quiz/<id>/attempted  เช็คว่าเคยทำแล้วหรือยัง
POST  /api/quiz/submit          ส่งคำตอบและคำนวณคะแนน
```

### Results & Analytics
```
GET   /api/result/<attempt_id>  ผลลัพธ์ attempt
GET   /api/review/<attempt_id>  เฉลยรายข้อ
GET   /api/dashboard?days=7     Dashboard (Bar / Radar charts)
GET   /api/growth               กราฟพัฒนาการ all-time
GET   /api/analysis             Topic mastery breakdown
GET   /api/recommendations      Quiz แนะนำตามจุดอ่อน
GET   /api/profile              โปรไฟล์และสถิติรวม
GET   /health                   ตรวจสอบสถานะ Server และ Database
```

> ทุก Endpoint (ยกเว้น `/api/auth/*` และ `/health`) ต้องการ Firebase ID Token:  
> `Authorization: Bearer <token>`

---

## การติดตั้งและรัน

### 1. ตั้งค่า Database

Execute ไฟล์ใน `learnflow_api/database/schema/` ตามลำดับ แล้ว seed ข้อมูล:

```bash
# Seed ข้อมูลเริ่มต้น
mysql -u root -p learnflow < seed_subjects.sql
mysql -u root -p learnflow < seed_quizzes.sql
python database/seeds/seed_questions.py
```

### 2. ตั้งค่า Backend

```bash
cd learnflow_api
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # Mac / Linux

pip install -r requirements.txt
cp .env.example .env         # แก้ไขค่า DB และ Firebase
python app.py
```

**.env ที่ต้องตั้งค่า:**

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=learnflow
FIREBASE_CREDENTIALS=config/serviceAccountKey.json
FLASK_DEBUG=false
FLASK_PORT=5000
```

> ⚠️ วาง Firebase Service Account Key ไว้ที่ `config/serviceAccountKey.json` และอย่า commit ไฟล์นี้

### 3. ตั้งค่า Flutter App

```bash
cd learnflow
flutter pub get
flutter run
```

ตั้ง `baseUrl` ใน `lib/services/api_service.dart` ตาม device:

| Device | URL |
|---|---|
| Android Emulator | `http://10.0.2.2:5000` |
| iOS Simulator | `http://localhost:5000` |
| Physical Device | `http://192.168.x.x:5000` |

---

## Troubleshooting

| ปัญหา | วิธีแก้ |
|---|---|
| `Connection refused` | ตรวจสอบว่า `python app.py` รันอยู่ และ `baseUrl` ถูกต้อง |
| `401 Unauthorized` | Token หมดอายุ → ล็อกอินใหม่ |
| Android เชื่อมต่อ localhost ไม่ได้ | เปลี่ยน URL เป็น `10.0.2.2` |
| `MySQL Connection Error` | ตรวจสอบ `DB_PASSWORD` และ MySQL service รันอยู่ |
| `Cleartext HTTP blocked` | เพิ่ม `usesCleartextTraffic="true"` ใน `AndroidManifest.xml` |
| ไม่มีข้อสอบแสดง | รัน seed ครบ 3 ขั้นตอนตามลำดับ |
| Notifications ไม่แสดง | รองรับเฉพาะ Android / iOS เท่านั้น |

---

*ITDS283 Project · April 2026*