package org.classFiles;

import java.util.Date;
import jakarta.persistence.*;

@Entity
@Table(name ="user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="userId")
    private int userId;

    @Column(name="email")
    private String email;

    @Column(name="password")
    private String password;

    @Column(name="fullName")
    private String fullName;

    @Column(name="phoneNumber")
    private String phoneNumber;

    @Column(name="gender")
    private String gender;

    @Column(name="dateOfBirth")
    private Date dateOfBirth;

    @Column(name="height")
    private double height;

    @Column(name="weight")
    private double weight;

    @Column(name="dietaryPreference")
    private String dietaryPreference;


    public User() {
    }


    public User(String email, String password, String fullName, String phoneNumber,
                String gender, Date dateOfBirth, double height, double weight,
                String dietaryPreference) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.height = height;
        this.weight = weight;
        this.dietaryPreference = dietaryPreference;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public double getHeight() {
        return height;
    }

    public void setHeight(double height) {
        this.height = height;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public String getDietaryPreference() {
        return dietaryPreference;
    }

    public void setDietaryPreference(String dietaryPreference) {
        this.dietaryPreference = dietaryPreference;
    }

}