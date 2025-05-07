package org.classFiles;

import jakarta.persistence.Entity;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "LogData",
        uniqueConstraints = @UniqueConstraint(columnNames = {"log_date", "user_id"}))
public class LogData implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "log_id")
    private Long id;

    @Temporal(TemporalType.DATE)
    @Column(name = "log_date", nullable = false)
    private Date date;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "diet_id")
    private Diet diet;

    @Column(name = "meal1", columnDefinition = "BOOLEAN DEFAULT false")
    private boolean meal1;

    @Column(name = "meal2", columnDefinition = "BOOLEAN DEFAULT false")
    private boolean meal2;

    @Column(name = "meal3", columnDefinition = "BOOLEAN DEFAULT false")
    private boolean meal3;

    @Column(name = "meal4", columnDefinition = "BOOLEAN DEFAULT false")
    private boolean meal4;

    @Column(name = "meal5", columnDefinition = "BOOLEAN DEFAULT false")
    private boolean meal5;

    @Column(name = "meal6", columnDefinition = "BOOLEAN DEFAULT false")
    private boolean meal6;

    @Column(name = "streak", columnDefinition = "INT DEFAULT 0")
    private int streak;

    @Column(name = "water", columnDefinition = "INT DEFAULT 0")
    private int water;

    @Column(name = "exercise", columnDefinition = "BOOLEAN DEFAULT false")
    private boolean exercise;


    public LogData() {
    }

    public LogData(Date date, User user, Diet diet) {
        this.date = date;
        this.user = user;
        this.diet = diet;
    }


    public Long getId() {
        return id;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Diet getDiet() {
        return diet;
    }

    public void setDiet(Diet diet) {
        this.diet = diet;
    }



    public void setId(Long id) {
        this.id = id;
    }

    public boolean isMeal1() {
        return meal1;
    }

    public void setMeal1(boolean meal1) {
        this.meal1 = meal1;
    }

    public boolean isMeal2() {
        return meal2;
    }

    public void setMeal2(boolean meal2) {
        this.meal2 = meal2;
    }

    public boolean isMeal3() {
        return meal3;
    }

    public void setMeal3(boolean meal3) {
        this.meal3 = meal3;
    }

    public boolean isMeal4() {
        return meal4;
    }

    public void setMeal4(boolean meal4) {
        this.meal4 = meal4;
    }

    public boolean isMeal5() {
        return meal5;
    }

    public void setMeal5(boolean meal5) {
        this.meal5 = meal5;
    }

    public boolean isMeal6() {
        return meal6;
    }

    public void setMeal6(boolean meal6) {
        this.meal6 = meal6;
    }

    public int getStreak() {
        return streak;
    }

    public void setStreak(int streak) {
        this.streak = streak;
    }

    public int getWater() {
        return water;
    }

    public void setWater(int water) {
        this.water = water;
    }

    public boolean isExercise() {
        return exercise;
    }

    public void setExercise(boolean exercise) {
        this.exercise = exercise;
    }

    public boolean isDayComplete() {
        return meal1 && meal2 && meal3 && meal4 && meal5 && meal6 && exercise && (water >= 5);
    }

    public LogData(boolean exercise, int water, int streak, boolean meal6, boolean meal5, boolean meal4, boolean meal3, boolean meal2, boolean meal1, Diet diet, User user, Date date, Long id) {
        this.exercise = exercise;
        this.water = water;
        this.streak = streak;
        this.meal6 = meal6;
        this.meal5 = meal5;
        this.meal4 = meal4;
        this.meal3 = meal3;
        this.meal2 = meal2;
        this.meal1 = meal1;
        this.diet = diet;
        this.user = user;
        this.date = date;
        this.id = id;
    }
}