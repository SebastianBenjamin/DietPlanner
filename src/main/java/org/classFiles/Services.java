package org.classFiles;

import jakarta.servlet.http.HttpSession;
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
        if (user == null || user.getLogId() == null || user.getDiet() == null) {
            System.out.println("user is null or logId is null or Diet is null");
            return;
        }

        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        try (Session session = sf.openSession()) {
            Transaction tx = session.beginTransaction();

            // Refresh the user object to get latest state
            User refreshedUser = session.get(User.class, user.getUserId());
            if (refreshedUser == null) {
                System.out.println("User not found in database");
                return;
            }

            LocalDate today = LocalDate.now();
            Diet diet = refreshedUser.getDiet();
            LogData logData = session.get(LogData.class, refreshedUser.getLogId());

            if (logData == null) {
                System.out.println("LogData not found for user");
                return;
            }

            LocalDate lastUpdate = refreshedUser.getLastStreakUpdate();

            if (lastUpdate == null || !lastUpdate.equals(today)) {
                System.out.println("Values\n" +
                        "diet.getExercise() : " + diet.getExercise() +
                        "\nlogData.isExercise() : " + logData.isExercise() +
                        "\ndiet.getTotalMeals() : " + diet.getTotalMeals() +
                        "\nlogData.getMeals() : " + logData.getMeals() +
                        "\ndiet.getWaterIntake() : " + diet.getWaterIntake() +
                        "\nwaterIntake : " + logData.getWater() +
                        "\ndb date : " + lastUpdate +
                        "\ntoday : " + today);

                // Convert water intake to milliliters
                int requiredWaterMl = diet.getWaterIntake() / 1000;

                if (diet.getExercise() == logData.isExercise() &&
                        diet.getTotalMeals() == logData.getMeals() &&
                        requiredWaterMl <= logData.getWater()) {

                    System.out.println("Streak Completed");
                    Integer streak = refreshedUser.getCurrentStreak() != null ?
                            refreshedUser.getCurrentStreak() : 0;

                    refreshedUser.setCurrentStreak(streak + 1);
                    logData.setStreak(streak + 1);
                    refreshedUser.setLastStreakUpdate(today);

                    session.merge(refreshedUser);
                    session.merge(logData);

                    // Update the original user object
                    user.setCurrentStreak(refreshedUser.getCurrentStreak());
                    user.setLastStreakUpdate(refreshedUser.getLastStreakUpdate());
                }
            }
            tx.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    }


