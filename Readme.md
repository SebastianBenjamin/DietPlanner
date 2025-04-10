# 🥗 Hibernate Diet Planner – Project Documentation

## 📘 Overview

This is a Hibernate-based **Diet Planner** web application designed to help users plan and track their diet and fitness goals. The application is responsive using **Tailwind CSS**, supports user login and registration, tracks food intake and exercises, and offers features like **PDF reports** and **email notifications**.

---

## 🗂️ Pages and Features

### 1. 🏠 Home Page (`index.jsp`)
- Landing page introducing the app.
- Brief description of benefits and features.
- Navigation links: Register, Login, About.

---

### 2. 📝 Register Page (`register.jsp`)
- User registration form with the following fields:
  - Name
  - Email
  - Password
  - Age
  - Gender
  - Weight
  - Height
  - Activity Level (Sedentary, Lightly Active, etc.)
  - Health Goal (Weight Loss, Maintenance, Weight Gain)
- Validates inputs before submission.
- Saves data using Hibernate ORM into `User` entity.

---

### 3. 🔐 Login Page (`login.jsp`)
- Login using:
  - Email / Username
  - Password
- Session management.
- Redirects to Dashboard on successful login.

---

### 4. 📊 Dashboard (`dashboard.jsp`)
Displays all user-specific information:

#### a. Current Diet Plan
- Displays today's diet schedule.
- Breakdown by meal: Breakfast, Lunch, Dinner, Snacks.

#### b. 🥘 Recipe of the Day
- Pulled from static/dummy JSON.
- Displays image, ingredients, and cooking instructions.

#### c. ✏️ Edit Profile
- Update weight, height, activity level, and goal.

#### d. 🔍 Search Recipes
- Search bar to find recipes from a local dummy JSON.
- Filters by calorie, meal type, or ingredient.

#### e. 🔁 Diet Streak & Goal Progress
- Number of days diet was followed successfully.
- Percentage progress toward target weight/goal.

#### f. ➕ Log Food & Exercise
- Log food items consumed (name, quantity, calories).
- Log exercise (type, duration, estimated calories burned).

---

### 5. 📤 Export & Notifications
- 📧 **Email Notifications**
  - Daily reminders
  - Weekly progress reports

- 📄 **Export to PDF**
  - Food intake and exercise log
  - Diet plan summary

---

### 6. 👨‍💼 Admin Page (`admin.jsp`)
- View all users.
- Add/modify/delete diet plans.
- Monitor overall app usage.
- Export user data to PDF.

---

## 🧪 Testing Plan

### ✅ Input Validation
- Check valid email format.
- Password length and strength.
- Prevent duplicate emails/usernames.

### ✅ Functional Tests
- Register new user
- Login with valid and invalid credentials
- Update profile
- View diet plan and recipe
- Export to PDF
- Receive email notifications

### ✅ UI/UX Testing
- Responsive layout on desktop/tablet/mobile
- All buttons, links, and forms behave as expected

---

## 🎁 Extra Suggestions

- 🌙 **Dark Mode Toggle**
- 📅 **Calendar View** of logs and progress
- 📌 Bookmark favorite recipes
- 🧠 AI-based diet suggestion (future integration)



