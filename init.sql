-- Use the correct database
USE app;

-- Drop tables if they already exist
DROP TABLE IF EXISTS visit_requests;
DROP TABLE IF EXISTS security_staff;
DROP TABLE IF EXISTS managing_staff;
DROP TABLE IF EXISTS residents;
DROP TABLE IF EXISTS users;

-- Create Users Table (Parent Table)
CREATE TABLE users (
                       id CHAR(36) PRIMARY KEY,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       name VARCHAR(100) NOT NULL,
                       gender ENUM('MALE', 'FEMALE') NOT NULL,
                       phone VARCHAR(20) NOT NULL UNIQUE,
                       IC VARCHAR(20) NOT NULL UNIQUE,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       role ENUM('MANAGING_STAFF', 'RESIDENT', 'SECURITY_STAFF') NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Residents Table
CREATE TABLE residents (
                           id CHAR(36) PRIMARY KEY,
                           FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE,
                           status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING'
);

-- Create Managing Staff Table (with department column)
CREATE TABLE managing_staff (
                                id CHAR(36) PRIMARY KEY,
                                department VARCHAR(100) NOT NULL DEFAULT 'General Administration',
                                isSuperAdmin BOOLEAN NOT NULL DEFAULT FALSE,
                                FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Security Staff Table (with shift column)
CREATE TABLE security_staff (
                                id CHAR(36) PRIMARY KEY,
                                shift ENUM('MORNING', 'EVENING', 'NIGHT') NOT NULL DEFAULT 'MORNING', -- Fix for shift issue
                                FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Visit Requests Table
CREATE TABLE visit_requests (
                                id CHAR(36) PRIMARY KEY, -- Using UUID format
                                resident_id CHAR(36) NOT NULL,
                                security_staff_id CHAR(36),
                                verification_code VARCHAR(10) NOT NULL UNIQUE,
                                status ENUM('SUBMITTED', 'CANCELLED', 'CLOSED') DEFAULT 'SUBMITTED',
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                FOREIGN KEY (resident_id) REFERENCES users(id) ON DELETE CASCADE,
                                FOREIGN KEY (security_staff_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Insert Managing Staff (Including 1 Super Admin)
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'admin', '$2a$12$DlP7e.4JdH3ikBGUqivRweq5LgGJbPpj2Xq6lo0lhnvF/ewuOVPG6', 'Admin User', 'MALE', '0123456789', '123456789012', 'admin@example.com', 'MANAGING_STAFF'),
    (UUID(), 'manager1', '$2a$12$0PsFbZMN/TU11pd4V4AmuO/EbdiwXMGJpIC0mMbAG1P4Yta1AtwRK', 'Manager One', 'MALE', '0123456788', '223456789012', 'manager1@example.com', 'MANAGING_STAFF'),
    (UUID(), 'manager2', '$2a$12$FlgUbm08J7T4KdPrCxfOBu4y7m7Ct0xPmkJr0DAtrSFm3f9HnjznW', 'Manager Two', 'FEMALE', '0123456787', '323456789012', 'manager2@example.com', 'MANAGING_STAFF'),
    (UUID(), 'manager3', '$2a$12$Croqw060DYRsBTOXP89hgukRQHX8bDeeMikO4Hrg7vbJ0BAi6ha.6', 'Manager Three', 'MALE', '0123456786', '423456789012', 'manager3@example.com', 'MANAGING_STAFF'),
    (UUID(), 'manager4', '$2a$12$6mGfQSDtLg3E.P335ozcZev3xpOfHRA1g8UlyeXBueEkN3NRmrZvC', 'Manager Four', 'FEMALE', '0123456785', '523456789012', 'manager4@example.com', 'MANAGING_STAFF');

INSERT INTO managing_staff (id, department, isSuperAdmin)
VALUES
    ((SELECT id FROM users WHERE username='admin'), 'Human Resources', TRUE),
    ((SELECT id FROM users WHERE username='manager1'), 'Finance', FALSE),
    ((SELECT id FROM users WHERE username='manager2'), 'Operations', FALSE),
    ((SELECT id FROM users WHERE username='manager3'), 'IT Support', FALSE),
    ((SELECT id FROM users WHERE username='manager4'), 'Facilities', FALSE);

-- Insert Residents (10 Users)
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'resident1', '$2a$12$s5xdIpoAjJv6jdNEAEDZhec0xFHGKhuCKgJBOuFBfaYnoRzdxNog6', 'Resident One', 'FEMALE', '0123456784', '623456789012', 'resident1@example.com', 'RESIDENT'),
    (UUID(), 'resident2', '$2a$12$rQ11IonzC4Hye3/oa11ove0X6aD/yU/rbTP9KBx335LKVvviXnA6K', 'Resident Two', 'MALE', '0123456783', '723456789012', 'resident2@example.com', 'RESIDENT'),
    (UUID(), 'resident3', '$2a$12$zTFN7nMwugoOFW7te48qdewiCpt1qVNo6.XbbJ0jay2WFIFyHHfrO', 'Resident Three', 'FEMALE', '0123456782', '823456789012', 'resident3@example.com', 'RESIDENT'),
    (UUID(), 'resident4', '$2a$12$dVOTAfhPVdOlgir6QPCNVOZHCl2kL/n9Gd8BvaEgsS8TWT2Y1VwuC', 'Resident Four', 'MALE', '0123456781', '923456789012', 'resident4@example.com', 'RESIDENT'),
    (UUID(), 'resident5', '$2a$12$zkw2fRbMgHpEyUfWv9VmW.NcSQgusY9bSc.T7P6fQn7CxlM5t2LSy', 'Resident Five', 'FEMALE', '0123456780', '1023456789012', 'resident5@example.com', 'RESIDENT');

INSERT INTO residents (id, status)
VALUES
    ((SELECT id FROM users WHERE username='resident1'), 'APPROVED'),
    ((SELECT id FROM users WHERE username='resident2'), 'PENDING'),
    ((SELECT id FROM users WHERE username='resident3'), 'PENDING'),
    ((SELECT id FROM users WHERE username='resident4'), 'PENDING'),
    ((SELECT id FROM users WHERE username='resident5'), 'REJECTED');

-- Insert Security Staff (10 Users)
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'security1', '$2a$12$OT6g.gDBwVclQSp8K1oj8OxYnc1dnvwRBRG8/tFpp9Px9qC85VO/2', 'Security One', 'MALE', '0123456779', '2023456789012', 'security1@example.com', 'SECURITY_STAFF'),
    (UUID(), 'security2', '$2a$12$0PHkm8mqFfTy/C41h60NrOImnxOaza5xg3ltOtQj4.W72guxTaJJe', 'Security Two', 'FEMALE', '0123456778', '3023456789012', 'security2@example.com', 'SECURITY_STAFF');

INSERT INTO security_staff (id, shift)
VALUES
    ((SELECT id FROM users WHERE username='security1'), 'NIGHT'),
    ((SELECT id FROM users WHERE username='security2'), 'MORNING');