package org.classFiles;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Diets")
public class Diet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "diet_id")
    private Integer dietId;

    @Column(name = "diet_name", nullable = false)
    private String dietName;

    @Column(name = "diet_type")
    private String dietType;

    @Column(name = "diet_preference")
    private String dietPreference;

    @Column(name = "exercise" )
    private boolean exercise;

    @Column(name = "total_meals")
    private Integer totalMeals;

    @Column(name = "water_intake")
    private Integer waterIntake;

    @OneToMany(mappedBy = "diet", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<User> users = new HashSet<>();

    public void setDietId(Integer dietId) {
        this.dietId = dietId;
    }

    // Constructors
    public Diet() {
    }

    public Diet(String dietName, String dietType, String dietPreference,
                boolean exercise, Integer totalMeals, Integer waterIntake) {
        this.dietName = dietName;
        this.dietType = dietType;
        this.dietPreference = dietPreference;
        this.exercise = exercise;
        this.totalMeals = totalMeals;
        this.waterIntake = waterIntake;
    }

    // Getters and Setters
    public Integer getDietId() {
        return dietId;
    }

    public String getDietName() {
        return dietName;
    }

    public void setDietName(String dietName) {
        this.dietName = dietName;
    }

    public String getDietType() {
        return dietType;
    }

    public void setDietType(String dietType) {
        this.dietType = dietType;
    }

    public String getDietPreference() {
        return dietPreference;
    }

    public void setDietPreference(String dietPreference) {
        this.dietPreference = dietPreference;
    }

    public boolean getExercise() {
        return exercise;
    }

    public void setExercise(boolean exercise) {
        this.exercise = exercise;
    }

    public Integer getTotalMeals() {
        return totalMeals;
    }

    public void setTotalMeals(Integer totalMeals) {
        this.totalMeals = totalMeals;
    }

    public Integer getWaterIntake() {
        return waterIntake;
    }

    public void setWaterIntake(Integer waterIntake) {
        this.waterIntake = waterIntake;
    }

    public Set<User> getUsers() {
        return users;
    }

    public void setUsers(Set<User> users) {
        this.users = users;
    }
}