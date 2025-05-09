package org.classFiles;

import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import java.time.LocalDateTime;
import java.util.List;

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

    public void logWaterIntake(User user, int amountMl) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            session.beginTransaction();
            WaterLog waterLog = new WaterLog(user, amountMl);
            session.persist(waterLog);
            session.getTransaction().commit();
        } finally {
            session.close();
        }
    }

    public List<WaterLog> getUserWaterLogs(User user, LocalDateTime startDate, LocalDateTime endDate) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            String hql = "FROM WaterLog w WHERE w.user = :user AND w.timestamp BETWEEN :startDate AND :endDate ORDER BY w.timestamp DESC";
            Query<WaterLog> query = session.createQuery(hql, WaterLog.class);
            query.setParameter("user", user);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.getResultList();
        } finally {
            session.close();
        }
    }

    public int getTotalWaterIntake(User user, LocalDateTime date) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            LocalDateTime startOfDay = date.toLocalDate().atStartOfDay();
            LocalDateTime endOfDay = startOfDay.plusDays(1).minusNanos(1);

            String hql = "SELECT SUM(w.amountMl) FROM WaterLog w WHERE w.user = :user AND w.timestamp BETWEEN :startDate AND :endDate";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("user", user);
            query.setParameter("startDate", startOfDay);
            query.setParameter("endDate", endOfDay);

            Long result = query.uniqueResult();
            return result != null ? result.intValue() : 0;
        } finally {
            session.close();
        }
    }
    public boolean deleteWaterLog(long logId, User user) {
        SessionFactory sf = new Configuration().configure().buildSessionFactory();
        Session session = sf.openSession();
        try {
            session.beginTransaction();

            WaterLog log = session.get(WaterLog.class, logId);

            if (log != null && log.getUser().getUserId() == user.getUserId()) {
                session.remove(log);
                session.getTransaction().commit();
                return true;
            } else {
                session.getTransaction().rollback();
                return false;
            }
        } catch (Exception e) {
            if (session.getTransaction().isActive()) {
                session.getTransaction().rollback();
            }
            return false;
        } finally {
            session.close();
        }
    }
}