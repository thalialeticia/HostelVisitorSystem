package com.example.hostelvisitorsystem.model;

import jakarta.persistence.*;

@Entity
@Table(name = "residents")
public class Resident extends User {

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status;

    public enum Status {
        PENDING, APPROVED, REJECTED
    }

    public Resident() {
        this.setRole(Role.RESIDENT);
        this.status = Status.PENDING;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }
}

