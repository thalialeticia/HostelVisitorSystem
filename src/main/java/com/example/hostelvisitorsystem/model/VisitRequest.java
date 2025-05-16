package com.example.hostelvisitorsystem.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.security.SecureRandom;

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

    @Column(name = "verification_code")
    private String verificationCode; // Code for visitor check-in

    @Column(name = "verification_code_count")
    private int verificationCodeCount;

    @Column(name = "visitor_name", nullable = false)
    private String visitorName; // Name of the visitor

    @Column(name = "visitor_phone", nullable = false)
    private String visitorPhone; // Contact number of the visitor

    @Column(name = "visitor_ic", nullable = false, length = 12)
    private String visitorIc; // IC Number (12-digit)

    @Column(name = "visitor_email", nullable = false, length = 100)
    private String visitorEmail; // Email of the visitor

    @Column(name = "visitor_address", nullable = false, length = 255)
    private String visitorAddress; // Address of the visitor

    @Column(name = "visit_date", nullable = false)
    private LocalDate visitDate; // Date of the visit

    @Column(name = "visit_time", nullable = false)
    private LocalTime visitTime; // Time of the visit

    @Column(name = "check_in_time")
    private LocalDateTime checkInTime; // Timestamp for visitor check-in

    @Column(name = "check_out_time")
    private LocalDateTime checkOutTime; // Timestamp for visitor check-out

    @Column(name = "expired_at")
    private LocalDateTime expiredAt; // Timestamp for code expiration date

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
        PENDING, APPROVED, REJECTED, CANCELLED, REACHED, CHECKED_OUT
    }

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; // Uppercase letters and numbers
    private static final SecureRandom RANDOM = new SecureRandom();

    // Constructor
    public VisitRequest() {
        this.status = Status.PENDING; // Default status is pending
        this.requestDate = LocalDateTime.now();
        this.verificationCodeCount = 0;
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

    public int getVerificationCodeCount() {
        return verificationCodeCount;
    }

    public void setVerificationCodeCount(int verificationCodeCount) {
        this.verificationCodeCount = verificationCodeCount;
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

    public String getVisitorIc() {
        return visitorIc;
    }

    public void setVisitorIc(String visitorIc) {
        this.visitorIc = visitorIc;
    }

    public String getVisitorEmail() {
        return visitorEmail;
    }

    public void setVisitorEmail(String visitorEmail) {
        this.visitorEmail = visitorEmail;
    }

    public String getVisitorAddress() {
        return visitorAddress;
    }

    public void setVisitorAddress(String visitorAddress) {
        this.visitorAddress = visitorAddress;
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

    public LocalDateTime getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(LocalDateTime checkInTime) {
        this.checkInTime = checkInTime;
    }

    public LocalDateTime getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(LocalDateTime checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public LocalDateTime getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(LocalDateTime expiredAt) {
        this.expiredAt = expiredAt;
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
