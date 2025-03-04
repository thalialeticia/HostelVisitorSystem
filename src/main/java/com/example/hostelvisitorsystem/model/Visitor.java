package com.example.hostelvisitorsystem.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "visitors")
public class Visitor extends BaseEntity {

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String phone;

    @Column(nullable = false)
    private String IC;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String address;

    // Getters & Setters
}
