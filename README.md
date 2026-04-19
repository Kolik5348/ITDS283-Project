# LearnFlow 📚

> ระบบฝึกสอบออนไลน์ที่ช่วยติดตามพัฒนาการและแนะนำเนื้อหาตามจุดอ่อนของผู้เรียน

**Flutter** · **Flask** · **MySQL** · **Firebase**

---

## สารบัญ

- [LearnFlow 📚](#learnflow-)
  - [สารบัญ](#สารบัญ)
  - [ฟีเจอร์](#ฟีเจอร์)
  - [Tech Stack](#tech-stack)
  - [โครงสร้างโปรเจค](#โครงสร้างโปรเจค)
  - [การติดตั้งและรัน](#การติดตั้งและรัน)
    - [1. ตั้งค่า Database](#1-ตั้งค่า-database)
    - [2. ตั้งค่า Backend (Flask)](#2-ตั้งค่า-backend-flask)
    - [3. ตั้งค่า Flutter App](#3-ตั้งค่า-flutter-app)
  - [API Reference](#api-reference)
    - [Authentication](#authentication)
    - [Profile](#profile)
    - [Quiz](#quiz)
    - [Results](#results)
    - [Analytics](#analytics)
    - [Recommendations](#recommendations)
  - [Architecture](#architecture)
  - [Troubleshooting](#troubleshooting)

---

## ฟีเจอร์

| ฟีเจอร์ | รายละเอียด |
|---|---|
| 🔐 Authentication | ล็อกอินด้วย Google / Email ผ่าน Firebase |
| 📝 Quiz | ทำข้อสอบพร้อมจับเวลา บันทึกประวัติ |
| 📊 Analytics | กราฟ Bar / Radar / Line วิเคราะห์ผลสอบ |
| 📈 Progress Tracking | ติดตามความก้าวหน้ารายวัน |
| 🎯 Smart Recommendations | แนะนำข้อสอบตามหัวข้อที่ยังอ่อน |
| 🌐 Multi-language | รองรับภาษาไทยและอังกฤษ |
| 📴 Offline Support | เก็บข้อมูลใน Hive สำหรับใช้งาน offline |

---

## Tech Stack

| Layer | Technology | Version |
|---|---|---|
| Mobile | Flutter / Dart | 3.0+ |
| Backend | Flask / Python | 3.0 / 3.9+ |
| Database | MySQL | 8.0 |
| Auth | Firebase Auth | — |
| State Management | Riverpod | 2.6.0 |
| Local Storage | Hive | 2.2.3 |
| Charts | fl_chart | 0.68.0 |

---

## โครงสร้างโปรเจค

```
ITDS283-Project/
├── learnflow/                        # Flutter App
│   ├── lib/
│   │   ├── main.dart                 # Entry point, Firebase init
│   │   ├── pages/                    # หน้าจอต่างๆ
│   │   │   ├── SplashScreen.dart
│   │   │   ├── LoginPage.dart
│   │   │   ├── HomePage.dart         # Dashboard
│   │   │   ├── QuizPage.dart         # รายการข้อสอบ
│   │   │   ├── QuizPlayPage.dart     # หน้าทำข้อสอบ
│   │   │   ├── ResultPage.dart       # ผลลัพธ์
│   │   │   ├── Analyticspage.dart    # กราฟวิเคราะห์
│   │   │   └── Profilepage.dart      # โปรไฟล์ผู้ใช้
│   │   ├── services/                 # API clients
│   │   │   ├── api_service.dart      # HTTP client (retry, timeout)
│   │   │   ├── cache_service.dart    # In-memory cache (TTL)
│   │   │   ├── local_storage_service.dart  # Hive offline storage
│   │   │   ├── profile_service.dart
│   │   │   ├── quiz_service.dart
│   │   │   ├── analytics_service.dart
│   │   │   └── notification_service.dart
│   │   └── widgets/                  # Reusable components
│   ├── assets/images/
│   └── pubspec.yaml
│
├── learnflow_api/                    # Flask Backend
│   ├── app.py                        # Entry point
│   ├── requirements.txt
│   ├── config/
│   │   ├── db_config.py              # MySQL connection pooling
│   │   ├── firebase_config.py
│   │   └── serviceAccountKey.json   # ⚠️ ห้าม commit!
│   ├── middleware/
│   │   └── auth_middleware.py        # Firebase token verification
│   ├── routes/
│   │   ├── auth.py
│   │   ├── quiz.py
│   │   ├── result.py
│   │   ├── analysis.py
│   │   ├── recommendation.py
│   │   └── user_profile.py
│   ├── services/
│   │   ├── ai_service.py             # คำนวณ Accuracy / Speed / Understanding
│   │   └── progress_service.py
│   └── database/
│       ├── init.sql
│       ├── schema/                   # 6 SQL files
│       └── seeds/
│           └── seed_questions.py
│
└── README.md
```

---

## การติดตั้งและรัน

### 1. ตั้งค่า Database

เปิด MySQL Workbench แล้ว Execute ไฟล์ใน `learnflow_api/database/schema/` ตามลำดับ:

```
01_users.sql
02_subjects.sql
03_quiz_system.sql
04_quiz_activity.sql
05_ai_analysis.sql
06_progress.sql
```

จากนั้น seed ข้อมูลเริ่มต้น:

```bash
# รัน seed SQL
seed_subjects.sql
seed_quizzes.sql

# สร้างข้อสอบ
cd learnflow_api
python database/seeds/seed_questions.py
```

---

### 2. ตั้งค่า Backend (Flask)

**1) วาง Firebase Service Account Key**

ไปที่ Firebase Console → Project Settings → Service Accounts → Generate New Private Key  
แล้ววางไฟล์ที่ `learnflow_api/config/serviceAccountKey.json`

> ⚠️ ไฟล์นี้ต้องอยู่ใน `.gitignore` เสมอ

**2) สร้าง `.env`**

```bash
cd learnflow_api
cp .env.example .env
```

แก้ไขค่าใน `.env`:

```env
# MySQL
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=learnflow

# Firebase
FIREBASE_CREDENTIALS=config/serviceAccountKey.json

# Flask
FLASK_ENV=development
SECRET_KEY=your_secret_key_here
LOG_LEVEL=INFO
CORS_ORIGINS=*
```

สร้าง `SECRET_KEY`:

```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

**3) ติดตั้ง dependencies และรัน**

```bash
cd learnflow_api

python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # Mac / Linux

pip install -r requirements.txt
python app.py
```

เมื่อสำเร็จจะเห็น:
```
LearnFlow API is running at http://0.0.0.0:5000
```

---

### 3. ตั้งค่า Flutter App

**1) ตั้ง `baseUrl`** ใน `lib/services/api_service.dart` ตาม device:

| Device | URL |
|---|---|
| Android Emulator | `http://10.0.2.2:5000` |
| iOS Simulator | `http://localhost:5000` |
| Physical device | `http://192.168.x.x:5000` |

> หา IP จาก `ipconfig` (Windows) หรือ `ifconfig` (Mac/Linux)

**2) อนุญาต HTTP** ใน `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

**3) รัน**

```bash
cd learnflow
flutter pub get
flutter run
```

## API Reference

### Authentication
```
POST  /api/auth/login           ล็อกอิน + sync user
POST  /api/auth/register        สมัครสมาชิก
```

### Profile
```
GET   /api/profile              ดึง user profile + สถิติ
```

### Quiz
```
GET   /api/quizzes?page=1       รายการ quiz (pagination)
GET   /api/quiz/<id>            รายละเอียด quiz + คำถาม + ตัวเลือก
GET   /api/quiz/<id>/attempted  เช็คว่าเคยทำแล้วหรือยัง
POST  /api/quiz/submit          ส่งคำตอบ
```

### Results
```
GET   /api/result/<attempt_id>  ผลลัพธ์ attempt
GET   /api/review/<attempt_id>  เฉลย
```

### Analytics
```
GET   /api/dashboard?days=7     Dashboard (Bar / Radar charts)
GET   /api/growth               กราฟพัฒนาการ (all-time)
GET   /api/analysis             Topic mastery breakdown
```

### Recommendations
```
GET   /api/recommendations      ข้อสอบแนะนำตามจุดอ่อน
```

---

## Architecture

```
┌──────────────────────────────────────────────┐
│              Flutter App (Mobile)            │
│   Pages · Services · Riverpod · Hive Cache   │
└────────────────────┬─────────────────────────┘
                     │  HTTPS + Firebase Token
                     ▼
┌──────────────────────────────────────────────┐
│              Flask API (Backend)             │
│   Routes · Middleware · AI Service · Limiter │
└────────────────────┬─────────────────────────┘
                     │  Connection Pooling
                     ▼
┌──────────────────────────────────────────────┐
│              MySQL Database                  │
│  Users · Quizzes · Attempts · Progress       │
└──────────────────────────────────────────────┘

Side Services:
  Firebase Auth   — token verification
  Hive            — offline quiz cache
  In-Memory Cache — API response cache (TTL 5–10 min)
```

---

## Troubleshooting

| ปัญหา | วิธีแก้ |
|---|---|
| `Connection refused` | ตรวจสอบว่า `python app.py` รันอยู่ และ `baseUrl` ถูกต้อง |
| `401 Unauthorized` | Token หมดอายุ → ล็อกอินใหม่ |
| Android เชื่อมต่อ localhost ไม่ได้ | เปลี่ยน URL เป็น `10.0.2.2` |
| `MySQL Connection Error` | ตรวจสอบ `DB_PASSWORD` และ MySQL service รันอยู่ |
| `Cleartext HTTP blocked` | เพิ่ม `usesCleartextTraffic="true"` ใน AndroidManifest.xml |
| ไม่มีข้อสอบแสดง | รัน seed ครบ 3 ขั้นตอนตามลำดับ |
| Notifications ไม่แสดง | รองรับเฉพาะ Android / iOS เท่านั้น |
| Build ช้า | รัน `flutter clean` แล้วลองใหม่ |

---

*ITDS283 Project · April 2026*