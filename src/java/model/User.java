package model;

import java.io.Serializable;

public class User implements Serializable {

    private String userId;
    private String fullName;
    private String email;
    private String password;
    private String role;       // 'MPP' or 'CHC'
    private String department;
    private boolean isActive;
    private int isTempPassword;
    private String phone;
    // Tambah ini di bahagian atas bersama variable lain
    private String portfolio;

    // Tambah di bahagian bawah
    public String getPortfolio() {
        return portfolio;
    }

    public void setPortfolio(String portfolio) {
        this.portfolio = portfolio;
    }

    public User() {
    }

    // Constructor
    public User(String userId, String fullName, String email, String role, String department, boolean isActive) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.department = department;
        this.isActive = isActive;
    }

    // Getters and Setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public int getIsTempPassword() {
        return isTempPassword;
    }

    public void setIsTempPassword(int isTempPassword) {
        this.isTempPassword = isTempPassword;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

}
