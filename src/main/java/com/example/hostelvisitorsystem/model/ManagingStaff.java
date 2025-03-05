package com.example.hostelvisitorsystem.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "managing_staff")
public class ManagingStaff extends User {

    @Column(nullable = false)
    private String department;

    @Column(nullable = false)
    private boolean isSuperAdmin = false; // Default false

    public ManagingStaff() {
        this.setRole(Role.MANAGING_STAFF);
        this.department = "General Administration"; // Default department
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public boolean isSuperAdmin() { // ✅ Add this method
        return isSuperAdmin;
    }

    public void setSuperAdmin(boolean superAdmin) {
        isSuperAdmin = superAdmin;
    }
}
