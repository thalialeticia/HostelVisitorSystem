package com.example.hostelvisitorsystem.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "visit_requests")
public class VisitRequest extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "resident_id", nullable = false)
    private Resident resident; // The resident who submits the request

    @ManyToOne
    @JoinColumn(name = "security_staff_id")
    private SecurityStaff securityStaff; // The security staff handling the request

    @ManyToOne
    @JoinColumn(name = "managing_staff_id")
    private ManagingStaff managingStaff; // The managing staff approving/rejecting the request

    @Column(name = "verification_code", nullable = false, unique = true)
    private String verificationCode; // Code for visitor check-in

    @Column(name = "visitor_name", nullable = false)
    private String visitorName; // Name of the visitor

    @Column(name = "visitor_phone", nullable = false)
    private String visitorPhone; // Contact number of the visitor

    @Column(name = "visit_date", nullable = false)
    private LocalDate visitDate; // Date of the visit

    @Column(name = "visit_time", nullable = false)
    private LocalTime visitTime; // Time of the visit

    @Column(name = "purpose", nullable = false, length = 255)
    private String purpose; // Purpose of visit

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private Status status; // Request status (Pending, Approved, etc.)

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime requestDate; // When the request was made

    @Column(name = "approval_date")
    private LocalDateTime approvalDate; // Only set when approved

    public enum Status {
        PENDING, APPROVED, REJECTED, CANCELLED, REACHED
    }

    // Constructor
    public VisitRequest() {
        this.verificationCode = UUID.randomUUID().toString().substring(0, 10).toUpperCase(); // Generate 10-character unique code
        this.status = Status.PENDING; // Default status is pending
        this.requestDate = LocalDateTime.now();
    }

    // Getters & Setters
    public Resident getResident() {
        return resident;
    }

    public void setResident(Resident resident) {
        this.resident = resident;
    }

    public SecurityStaff getSecurityStaff() {
        return securityStaff;
    }

    public void setSecurityStaff(SecurityStaff securityStaff) {
        this.securityStaff = securityStaff;
    }

    public ManagingStaff getManagingStaff() {
        return managingStaff;
    }

    public void setManagingStaff(ManagingStaff managingStaff) {
        this.managingStaff = managingStaff;
    }

    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    public String getVisitorName() {
        return visitorName;
    }

    public void setVisitorName(String visitorName) {
        this.visitorName = visitorName;
    }

    public String getVisitorPhone() {
        return visitorPhone;
    }

    public void setVisitorPhone(String visitorPhone) {
        this.visitorPhone = visitorPhone;
    }

    public LocalDate getVisitDate() {
        return visitDate;
    }

    public void setVisitDate(LocalDate visitDate) {
        this.visitDate = visitDate;
    }

    public LocalTime getVisitTime() {
        return visitTime;
    }

    public void setVisitTime(LocalTime visitTime) {
        this.visitTime = visitTime;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public LocalDateTime getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(LocalDateTime requestDate) {
        this.requestDate = requestDate;
    }

    public LocalDateTime getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(LocalDateTime approvalDate) {
        this.approvalDate = approvalDate;
    }
}
