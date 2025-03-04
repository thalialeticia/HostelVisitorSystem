package com.example.hostelvisitorsystem.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "visit_requests")
public class VisitRequest extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "resident_id", nullable = false)
    private Resident resident;

    @ManyToOne
    @JoinColumn(name = "security_staff_id")
    private SecurityStaff securityStaff;

    @Column(nullable = false, unique = true)
    private String verificationCode;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status;

    @Column(nullable = false)
    private LocalDateTime requestDate;

    @Column
    private LocalDateTime approvalDate;

    public enum Status {
        SUBMITTED, APPROVED, REJECTED, CANCELLED, CLOSED
    }

    public VisitRequest() {
        this.verificationCode = UUID.randomUUID().toString();
    }

    // Getters & Setters
}
