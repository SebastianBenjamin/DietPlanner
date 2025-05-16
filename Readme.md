
# Diet Planner - Personalized Nutrition Assistant 🥗

![Application Screenshot](https://github.com/SebastianBenjamin/DietPlanner/blob/main/src/main/screenshots/img.png?raw=true)

### ![GitHub Repo](https://img.shields.io/badge/GitHub-Repository-181717?logo=github\&style=for-the-badge) 

### ![Stars](https://img.shields.io/github/stars/SebastianBenjamin/DietPlanner?style=for-the-badge) ![Forks](https://img.shields.io/github/forks/SebastianBenjamin/DietPlanner?style=for-the-badge) ![Issues](https://img.shields.io/github/issues/SebastianBenjamin/DietPlanner?style=for-the-badge) 

## 📝 Table of Contents
- [About](#-about)
- [Key Features](#-key-features)
- [Technology Stack](#-technology-stack)
- [System Requirements](#-system-requirements)
- [Installation Guide](#-installation-guide)
- [Database Configuration](#-database-configuration)
- [Application Deployment](#-application-deployment)
- [Project Architecture](#-project-architecture)
- [Development Team](#-development-team)
- [License](#-license)

## 🌟 About

Diet Planner is a **Spring-Hibernate** based web application that revolutionizes personal nutrition management. This comprehensive solution combines intelligent diet planning with habit tracking and AI-powered guidance to help users achieve their health goals.

**Core Value Proposition:**
- 🎯 Personalized nutrition planning tailored to individual needs
- 📈 Comprehensive progress tracking with actionable insights
- 🤖 Intelligent AI assistant for real-time nutrition guidance
- 📱 Responsive design for seamless cross-device experience

## ✨ Key Features

### 🍽️ Diet Planning Module
| Feature | Description |
|---------|-------------|
| Custom Diet Creation | Build personalized plans with custom meal frequencies and preferences |
| Predefined Templates | Choose from professionally designed diet templates |
| Nutritional Targets | Set daily calorie, protein, and water intake goals |

### 📊 Health Tracking System
| Component | Capabilities |
|-----------|--------------|
| Meal Logger | Track meal completion status with visual indicators |
| Water Tracker | Monitor daily hydration with goal progress |
| Exercise Log | Record workout sessions and intensity levels |
| Streak System | Motivation through achievement streaks and milestones |

### 🤖 AI Nutrition Assistant
- Natural language processing for nutrition queries
- Context-aware recommendations
- Quick-access templates for common questions
- Personalized feedback based on user data

### 🎨 User Experience
- Modern dashboard with at-a-glance metrics
- Intuitive navigation and workflow
- Responsive design optimized for all devices
- Visual data representations for easy interpretation

## 💻 Technology Stack

### Backend Infrastructure
![Java](https://img.shields.io/badge/Java-17-007396?logo=java)
![Spring](https://img.shields.io/badge/Spring-5.3.20-6DB33F?logo=spring)
![Hibernate](https://img.shields.io/badge/Hibernate-5.6.14-59666C?logo=hibernate)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql)

### Frontend Ecosystem
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3.3.2-06B6D4?logo=tailwind-css)
![JSP](https://img.shields.io/badge/JSP-2.3-F37626?logo=java)
![JavaScript](https://img.shields.io/badge/JavaScript-ES6+-F7DF1E?logo=javascript)

### Development Tools
![Apache Tomcat](https://img.shields.io/badge/Apache_Tomcat-10.0.27-F8DC75?logo=apache-tomcat)
![Maven](https://img.shields.io/badge/Maven-3.8.6-C71A36?logo=apache-maven)

## ⚙️ System Requirements

**Minimum Specifications:**
- Java Development Kit 17+
- Apache Tomcat 10.x
- MySQL Server 8.0+ or XAMPP
- Maven 3.8+
- Modern web browser (Chrome, Firefox, Edge)

## 🛠️ Installation Guide

1. **Clone the Repository**
   ```bash
   git clone https://github.com/SebastianBenjamin/DietPlanner.git
   cd DietPlanner
   ```

2. **Configure Application Properties**
  - Update database connection parameters in:
    ```
    src/main/resources/hibernate.cfg.xml
    ```

3. **Build Dependencies**
   ```bash
   mvn clean install
   ```

## 🗃️ Database Configuration

1. **Initialize MySQL Database**
   ```sql
   CREATE DATABASE dietplanner ;
   ```

2. **Import Schema**
   ```bash
   mysql -u [username] -p dietplanner < dietplanner.sql
   ```

## 🚀 Application Deployment

**Tomcat Deployment Steps:**
1. Build the WAR package:
   ```bash
   mvn clean package
   ```

2. Deploy to Tomcat:
  - Copy `target/DietPlanner.war` to `[TOMCAT_HOME]/webapps/`
  - Start Tomcat server

3. Access application:
   ```
   http://localhost:8080/DietPlanner/
   ```

## 🏗️ Project Architecture

```
DietPlanner/
├── src/
│   ├── main/
│   │   ├── java/org/                      
│   │   │   ├── classFiles/             # Domain models and business logic
│   │   │   │   ├── User.java          # User entity
│   │   │   │   ├── Diet.java          # Diet plan entity
│   │   │   │   ├── LogData.java       # Log data Entity
│   │   │   │   └── Services.java      # Core business services
│   │   │   └── Controllers/           # MVC controllers
│   │   │       └── Controller.java    # Main application controller
│   │   ├── resources/                 
│   │   │   └── hibernate.cfg.xml      # ORM configuration
│   │   └── webapp/                    
│   │       ├── WEB-INF/views/         # View templates (JSP)
│   │       └── static/                # Static assets (CSS/JS/images)
├── pom.xml                            # Build configuration
└── dietplanner.sql                    # Database schema
```

## 👨‍💻 Development Team

### Core Contributors

| Name | GitHub | Contributions |
|------|--------|---------------|
| Akshay Venugopalan | [@akshayvenu](https://github.com/akshayvenu) | Logging systems, AI chatbot integration |
| Benjamin Sebastian | [@SebastianBenjamin](https://github.com/SebastianBenjamin) | Dashboard UI, diet management, streak logic |
| Shravya Salian | [@salianShravya](https://github.com/salianShravya) | Authentication system, UI components |


---

💡 **Pro Tip:** For optimal results, use the application consistently to benefit from the streak system and receive increasingly personalized recommendations from our AI nutrition assistant, Nutri Mate!

![Application Screenshot](https://github.com/SebastianBenjamin/DietPlanner/blob/main/src/main/screenshots/img.png?raw=true)
![Application Screenshot](https://github.com/SebastianBenjamin/DietPlanner/blob/main/src/main/screenshots/img_1.png?raw=true)
![Application Screenshot](https://github.com/SebastianBenjamin/DietPlanner/blob/main/src/main/screenshots/img_2.png?raw=true)
