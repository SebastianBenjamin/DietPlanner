package org.classFiles;

import jakarta.servlet.http.HttpSession;
import org.hibernate.CacheMode;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Services {
    public List<Diet> getAllDiets() {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        session.beginTransaction();
        try {
            String hql = "FROM Diet";
            Query<Diet> query = session.createQuery(hql, Diet.class);
            return query.getResultList();
        } finally {
            session.close();
        }
    }

    public static List<Diet> getDietsByUser(int userId) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        try (Session session = sf.openSession()) {
            String hql = "FROM Diet WHERE createdBy = :userId";
            return session.createQuery(hql, Diet.class)
                    .setParameter("userId", userId)
                    .getResultList();
        }
    }

    public void updateUserLogInfo(User user, LogData logData) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            session.beginTransaction();

            // Update user's log info
            user.setLogDate(logData.getDate());
            user.setLogId(logData.getId().intValue());

            session.merge(user);

            session.getTransaction().commit();
        } catch (Exception e) {
            if (session.getTransaction() != null) {
                session.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    public void logWaterIntake(User user, int amountMl) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            session.beginTransaction();

            Date today = new Date();
            Date[] dayRange = getDayBoundaries(today);

            String hql = "FROM LogData WHERE user.userId = :userId AND date BETWEEN :startDate AND :endDate";
            Query<LogData> query = session.createQuery(hql, LogData.class);
            query.setParameter("userId", user.getUserId());
            query.setParameter("startDate", dayRange[0]);
            query.setParameter("endDate", dayRange[1]);

            List<LogData> existingLogs = query.getResultList();
            LogData logData;

            if (existingLogs.isEmpty()) {
                logData = new LogData(today, user, user.getDiet());
                logData.setWater(amountMl);
                session.persist(logData);
            } else {
                logData = existingLogs.get(0);
                logData.setWater(logData.getWater() + amountMl);
                session.merge(logData);
            }

            user.setLogDate(logData.getDate());
            user.setLogId(logData.getId().intValue());

            session.merge(user);
            session.getTransaction().commit();
            updateStreak(user);
        } catch (Exception e) {
            if (session.getTransaction() != null) {
                session.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    public int getTotalWaterIntake(User user, LocalDateTime dateTime) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            Date date = convertToDate(dateTime);
            Date[] dayRange = getDayBoundaries(date);

            String hql = "SELECT water FROM LogData WHERE user.userId = :userId AND date BETWEEN :startDate AND :endDate";
            Query<Integer> query = session.createQuery(hql, Integer.class);
            query.setParameter("userId", user.getUserId());
            query.setParameter("startDate", dayRange[0]);
            query.setParameter("endDate", dayRange[1]);

            Integer result = query.uniqueResult();
            return result != null ? result : 0;
        } finally {
            session.close();
        }
    }

    public void resetTodayWaterLog(User user) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            session.beginTransaction();

            // Get today's date boundaries using the existing helper method
            Date today = new Date();
            Date[] dayRange = getDayBoundaries(today);

            // Update today's entries to reset water to 0
            Query<?> query = session.createQuery(
                    "update LogData set water = 0 where user.userId = :userId and date between :startDate and :endDate");
            query.setParameter("userId", user.getUserId());
            query.setParameter("startDate", dayRange[0]);
            query.setParameter("endDate", dayRange[1]);
            query.executeUpdate();

            session.getTransaction().commit();
        } catch (Exception e) {
            if (session.getTransaction() != null) {
                session.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    // Helper method to convert LocalDateTime to Date
    private Date convertToDate(LocalDateTime localDateTime) {
        return Date.from(localDateTime.atZone(java.time.ZoneId.systemDefault()).toInstant());
    }


    private Date[] getDayBoundaries(Date date) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(date);
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        Date startOfDay = cal.getTime();

        cal.add(java.util.Calendar.DATE, 1);
        cal.add(java.util.Calendar.MILLISECOND, -1);
        Date endOfDay = cal.getTime();

        return new Date[]{startOfDay, endOfDay};
    }

    public boolean[] getMealStatus(User user, LocalDateTime dateTime) {
        try (SessionFactory sf = new Configuration().configure().buildSessionFactory();
             Session session = sf.openSession()) {

            Date date = convertToDate(dateTime);
            Date[] dayRange = getDayBoundaries(date);

            String hql = "FROM LogData WHERE user.userId = :userId AND date BETWEEN :startDate AND :endDate";
            Query<LogData> query = session.createQuery(hql, LogData.class);
            query.setParameter("userId", user.getUserId());
            query.setParameter("startDate", dayRange[0]);
            query.setParameter("endDate", dayRange[1]);

            LogData logData = query.uniqueResult();

            boolean[] mealStatus = new boolean[6];
            if (logData != null) {
                mealStatus[0] = logData.isMeal1();
                mealStatus[1] = logData.isMeal2();
                mealStatus[2] = logData.isMeal3();
                mealStatus[3] = logData.isMeal4();
                mealStatus[4] = logData.isMeal5();
                mealStatus[5] = logData.isMeal6();
            }

            return mealStatus;
        }
    }

    public void logMeal(User user, int mealNumber, boolean completed) {
        try (SessionFactory sf = new Configuration().configure().buildSessionFactory();
             Session session = sf.openSession()) {

            session.beginTransaction();

            Date today = new Date();
            Date[] dayRange = getDayBoundaries(today);

            String hql = "FROM LogData WHERE user.userId = :userId AND date BETWEEN :startDate AND :endDate";
            Query<LogData> query = session.createQuery(hql, LogData.class);
            query.setParameter("userId", user.getUserId());
            query.setParameter("startDate", dayRange[0]);
            query.setParameter("endDate", dayRange[1]);

            List<LogData> existingLogs = query.getResultList();
            LogData logData;

            if (existingLogs.isEmpty()) {
                logData = new LogData(today, user, user.getDiet());
                session.persist(logData);
            } else {
                logData = existingLogs.get(0);
            }


            switch (mealNumber) {
                case 1:
                    logData.setMeal1(completed);
                    break;
                case 2:
                    logData.setMeal2(completed);
                    break;
                case 3:
                    logData.setMeal3(completed);
                    break;
                case 4:
                    logData.setMeal4(completed);
                    break;
                case 5:
                    logData.setMeal5(completed);
                    break;
                case 6:
                    logData.setMeal6(completed);
                    break;
            }

            session.merge(logData);

            // Update user's log info

            user.setLogDate(logData.getDate());
            user.setLogId(logData.getId().intValue());
            session.merge(user);

            session.getTransaction().commit();
            updateStreak(user);
        }
    }

    // Add the missing exercise methods
    public boolean getExerciseStatus(User user, LocalDateTime dateTime) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            Date date = convertToDate(dateTime);
            Date[] dayRange = getDayBoundaries(date);

            String hql = "SELECT exercise FROM LogData WHERE user.userId = :userId AND date BETWEEN :startDate AND :endDate";
            Query<Boolean> query = session.createQuery(hql, Boolean.class);
            query.setParameter("userId", user.getUserId());
            query.setParameter("startDate", dayRange[0]);
            query.setParameter("endDate", dayRange[1]);

            Boolean result = query.uniqueResult();
            return result != null ? result : false;
        } finally {
            session.close();
        }
    }

    public void logExercise(User user, boolean completed) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            session.beginTransaction();

            Date today = new Date();
            Date[] dayRange = getDayBoundaries(today);

            String hql = "FROM LogData WHERE user.userId = :userId AND date BETWEEN :startDate AND :endDate";
            Query<LogData> query = session.createQuery(hql, LogData.class);
            query.setParameter("userId", user.getUserId());
            query.setParameter("startDate", dayRange[0]);
            query.setParameter("endDate", dayRange[1]);

            List<LogData> existingLogs = query.getResultList();
            LogData logData;

            if (existingLogs.isEmpty()) {
                logData = new LogData(today, user, user.getDiet());
                logData.setExercise(completed);
                session.persist(logData);
            } else {
                logData = existingLogs.get(0);
                logData.setExercise(completed);
                session.merge(logData);
            }

            user.setLogDate(logData.getDate());
            user.setLogId(logData.getId().intValue());
            session.merge(user);

            session.getTransaction().commit();
            updateStreak(user);

        } finally {
            session.close();
        }
    }

    public static LogData getLogDataById(int logId) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();

        try {
            // Get log by its primary key (logId)
            LogData logData = session.get(LogData.class, logId);
            return logData;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            session.close();
        }
    }

    public static Integer checkUserAuthentication(String email, String password) {
        Session session = null;
        Integer userId = null;

        try {
            // Initialize session
            SessionFactory sf = new Configuration().configure().buildSessionFactory();
            session = sf.openSession();
            session.beginTransaction();

            // HQL query to get user ID if authentication is successful
            String hql = "SELECT u.id FROM User u WHERE u.email = :email AND u.password = :password";
            Query<Integer> query = session.createQuery(hql, Integer.class);
            query.setParameter("email", email);
            query.setParameter("password", password);

            // Get user ID if exists, else null
            userId = query.uniqueResult();

            session.getTransaction().commit();
        } catch (Exception e) {
            if (session != null) session.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }

        return userId;
    }

    public void updateStreak(User user) {
        // Initial null checks
        if (user == null || user.getLogId() == null || user.getDiet() == null) {
            System.out.println("[DEBUG] Invalid input parameters");
            return;
        }

        System.out.println("[DEBUG] Starting streak update for user ID: " + user.getUserId());
        System.out.println("[DEBUG] Initial user state - LastUpdate: " + user.getLastStreakUpdate() +
                ", CurrentStreak: " + user.getCurrentStreak());

        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        try (Session session = sf.openSession()) {
            // Disable caching and force database reads
            session.setCacheMode(CacheMode.REFRESH);

            Transaction tx = session.beginTransaction();

            // 1. Get FRESH user data (bypass cache)
            session.clear();
            User refreshedUser = session.createQuery(
                            "SELECT u FROM User u LEFT JOIN FETCH u.diet WHERE u.userId = :userId", User.class)
                    .setParameter("userId", user.getUserId())
                    .setHint("org.hibernate.cacheMode", "REFRESH")
                    .uniqueResult();

            if (refreshedUser == null) {
                System.out.println("[ERROR] User not found in database");
                return;
            }

            // 2. Get FRESH log data (bypass cache)
            session.clear();
            LogData logData = session.createQuery(
                            "SELECT l FROM LogData l WHERE l.id = :logId", LogData.class)
                    .setParameter("logId", refreshedUser.getLogId())
                    .setHint("org.hibernate.cacheMode", "REFRESH")
                    .uniqueResult();

            if (logData == null) {
                System.out.println("[ERROR] LogData not found for logId: " + refreshedUser.getLogId());
                return;
            }

            System.out.println("[DEBUG] FRESH DATA - UserLastUpdate: " + refreshedUser.getLastStreakUpdate() +
                    ", LogDate: " + logData.getDate());

            LocalDate today = LocalDate.now();
            LocalDate lastUpdate = refreshedUser.getLastStreakUpdate();
            boolean isNewDay = lastUpdate == null || !lastUpdate.equals(today);

            System.out.println("[DEBUG] Date check - Today: " + today +
                    ", DB LastUpdate: " + lastUpdate +
                    ", IsNewDay: " + isNewDay);

            if (isNewDay) {
                // Check streak conditions
                int requiredWaterMl = refreshedUser.getDiet().getWaterIntake() * 1000;
                boolean conditionsMet = refreshedUser.getDiet().getExercise() == logData.isExercise()
                        && refreshedUser.getDiet().getTotalMeals() == logData.getMeals()
                        && requiredWaterMl <= logData.getWater();

                if (conditionsMet) {
                    int newStreak = (refreshedUser.getCurrentStreak() != null ? refreshedUser.getCurrentStreak() : 0) + 1;

                    refreshedUser.setCurrentStreak(newStreak);
                    logData.setStreak(newStreak);
                    refreshedUser.setLastStreakUpdate(today);

                    session.merge(refreshedUser);
                    session.merge(logData);

                    // Update the original user object
                    user.setCurrentStreak(newStreak);
                    user.setLastStreakUpdate(today);

                    System.out.println("[SUCCESS] Streak updated to: " + newStreak);
                } else {
                    System.out.println("[DEBUG] Diet conditions not met");
                }
            } else {
                System.out.println("[DEBUG] Not a new day - LastUpdate already set to today");
            }

            tx.commit();
            System.out.println("[DEBUG] Transaction committed");
        } catch (Exception e) {
            System.out.println("[ERROR] Exception: " + e.getMessage());
            e.printStackTrace();
        } finally {
            sf.close();
        }
    }
    }


