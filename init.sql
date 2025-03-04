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
                       id CHAR(36) PRIMARY KEY, -- Using UUID format
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL, -- Password stored as a hashed value
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
                           FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Managing Staff Table (with department column)
CREATE TABLE managing_staff (
                                id CHAR(36) PRIMARY KEY,
                                department VARCHAR(100) NOT NULL DEFAULT 'General Administration', -- Fix for department issue
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

-- Insert Managing Staff (Admin)
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'admin', '$2a$12$DlP7e.4JdH3ikBGUqivRweq5LgGJbPpj2Xq6lo0lhnvF/ewuOVPG6', 'Admin User', 'MALE', '0123456789', 'M1234567890', 'admin@example.com', 'MANAGING_STAFF');

INSERT INTO managing_staff (id, department)
VALUES ((SELECT id FROM users WHERE username='admin'), 'Human Resources');

-- Insert Residents
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'resident1', '$2a$12$s5xdIpoAjJv6jdNEAEDZhec0xFHGKhuCKgJBOuFBfaYnoRzdxNog6', 'Resident One', 'FEMALE', '0123456788', 'R1234567890', 'resident1@example.com', 'RESIDENT'),
    (UUID(), 'resident2', '$2a$12$rQ11IonzC4Hye3/oa11ove0X6aD/yU/rbTP9KBx335LKVvviXnA6K', 'Resident Two', 'MALE', '0123456787', 'R0987654321', 'resident2@example.com', 'RESIDENT');

INSERT INTO residents (id)
VALUES
    ((SELECT id FROM users WHERE username='resident1')),
    ((SELECT id FROM users WHERE username='resident2'));

-- Insert Security Staff
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'security1', '$2a$12$OT6g.gDBwVclQSp8K1oj8OxYnc1dnvwRBRG8/tFpp9Px9qC85VO/2', 'Security One', 'MALE', '0123456786', 'S1234567890', 'security1@example.com', 'SECURITY_STAFF');

INSERT INTO security_staff (id, shift)
VALUES ((SELECT id FROM users WHERE username='security1'), 'NIGHT');
