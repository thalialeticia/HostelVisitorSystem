package com.example.hostelvisitorsystem.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;

@Entity
@Table(name = "security_staff")
public class SecurityStaff extends User {

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Shift shift;

    public enum Shift {
        MORNING, EVENING, NIGHT
    }

    public SecurityStaff() {
        this.setRole(Role.SECURITY_STAFF);
        this.shift = Shift.MORNING; // Default shift
    }

    public Shift getShift() {
        return shift;
    }

    public void setShift(Shift shift) {
        this.shift = shift;
    }
}