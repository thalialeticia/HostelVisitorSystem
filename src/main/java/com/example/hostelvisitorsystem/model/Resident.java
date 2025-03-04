package com.example.hostelvisitorsystem.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "residents")
public class Resident extends User {
    public Resident() {
        this.setRole(Role.RESIDENT);
    }
}
