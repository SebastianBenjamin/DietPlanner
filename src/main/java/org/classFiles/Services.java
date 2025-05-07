package org.classFiles;

import org.hibernate.Hibernate;
import org.hibernate.Session;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;


import java.util.List;

public class Services {
    public List<Diet> getAllDiets() {
        SessionFactory sf= new Configuration().configure().buildSessionFactory();
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
}
