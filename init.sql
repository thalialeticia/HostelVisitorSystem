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
                                is_super_admin BOOLEAN NOT NULL DEFAULT FALSE,
                                FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Security Staff Table (with shift column)
CREATE TABLE security_staff (
                                id CHAR(36) PRIMARY KEY,
                                shift ENUM('MORNING', 'EVENING', 'NIGHT') NOT NULL DEFAULT 'MORNING', -- Fix for shift issue
                                FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Visit Requests Table (Added missing visitor fields)
CREATE TABLE visit_requests (
                                id CHAR(36) PRIMARY KEY,
                                resident_id CHAR(36) NOT NULL,
                                security_staff_id CHAR(36),
                                verification_code VARCHAR(10),
                                verification_code_count INT DEFAULT 0,
                                visitor_name VARCHAR(100) NOT NULL,
                                visitor_phone VARCHAR(20) NOT NULL,
                                visitor_ic VARCHAR(12) NOT NULL,
                                visitor_email VARCHAR(100) NOT NULL,
                                visitor_address VARCHAR(255) NOT NULL,
                                visit_date DATE NOT NULL,
                                visit_time TIME NOT NULL,
                                check_in_time TIMESTAMP DEFAULT NULL,  -- Stores actual check-in time
                                check_out_time TIMESTAMP DEFAULT NULL, -- Stores actual check-out time
                                expired_at TIMESTAMP DEFAULT NULL,
                                purpose VARCHAR(255) NOT NULL,
                                status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'REACHED', 'CHECKED_OUT') DEFAULT 'PENDING',
                                managing_staff_id CHAR(36),
                                approval_date TIMESTAMP DEFAULT NULL,
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                FOREIGN KEY (resident_id) REFERENCES users(id) ON DELETE CASCADE,
                                FOREIGN KEY (security_staff_id) REFERENCES users(id) ON DELETE SET NULL,
                                FOREIGN KEY (managing_staff_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Insert Managing Staff (Including 1 Super Admin)
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'admin', '$2a$12$DlP7e.4JdH3ikBGUqivRweq5LgGJbPpj2Xq6lo0lhnvF/ewuOVPG6', 'Admin User', 'MALE', '0123456789', '123456789012', 'admin@example.com', 'MANAGING_STAFF'),
    (UUID(), 'manager1', '$2a$12$0PsFbZMN/TU11pd4V4AmuO/EbdiwXMGJpIC0mMbAG1P4Yta1AtwRK', 'Manager One', 'MALE', '0123456788', '223456789012', 'manager1@example.com', 'MANAGING_STAFF'),
    (UUID(), 'manager2', '$2a$12$FlgUbm08J7T4KdPrCxfOBu4y7m7Ct0xPmkJr0DAtrSFm3f9HnjznW', 'Manager Two', 'FEMALE', '0123456787', '323456789012', 'manager2@example.com', 'MANAGING_STAFF'),
    (UUID(), 'manager3', '$2a$12$Croqw060DYRsBTOXP89hgukRQHX8bDeeMikO4Hrg7vbJ0BAi6ha.6', 'Manager Three', 'MALE', '0123456786', '423456789012', 'manager3@example.com', 'MANAGING_STAFF'),
    (UUID(), 'manager4', '$2a$12$6mGfQSDtLg3E.P335ozcZev3xpOfHRA1g8UlyeXBueEkN3NRmrZvC', 'Manager Four', 'FEMALE', '0123456785', '523456789012', 'manager4@example.com', 'MANAGING_STAFF');

INSERT INTO managing_staff (id, department, is_super_admin)
VALUES
    ((SELECT id FROM users WHERE username='admin'), 'Human Resources', TRUE),
    ((SELECT id FROM users WHERE username='manager1'), 'Finance', FALSE),
    ((SELECT id FROM users WHERE username='manager2'), 'Operations', FALSE),
    ((SELECT id FROM users WHERE username='manager3'), 'IT Support', FALSE),
    ((SELECT id FROM users WHERE username='manager4'), 'Facilities', FALSE);

-- Insert Residents (8 Users)
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'resident1', '$2a$12$s5xdIpoAjJv6jdNEAEDZhec0xFHGKhuCKgJBOuFBfaYnoRzdxNog6', 'Resident One', 'FEMALE', '0123456784', '623456789012', 'resident1@example.com', 'RESIDENT'),
    (UUID(), 'resident2', '$2a$12$rQ11IonzC4Hye3/oa11ove0X6aD/yU/rbTP9KBx335LKVvviXnA6K', 'Resident Two', 'MALE', '0123456783', '723456789012', 'resident2@example.com', 'RESIDENT'),
    (UUID(), 'resident3', '$2a$12$zTFN7nMwugoOFW7te48qdewiCpt1qVNo6.XbbJ0jay2WFIFyHHfrO', 'Resident Three', 'FEMALE', '0123456782', '823456789012', 'resident3@example.com', 'RESIDENT'),
    (UUID(), 'resident4', '$2a$12$dVOTAfhPVdOlgir6QPCNVOZHCl2kL/n9Gd8BvaEgsS8TWT2Y1VwuC', 'Resident Four', 'MALE', '0123456781', '923456789012', 'resident4@example.com', 'RESIDENT'),
    (UUID(), 'resident5', '$2a$12$zkw2fRbMgHpEyUfWv9VmW.NcSQgusY9bSc.T7P6fQn7CxlM5t2LSy', 'Resident Five', 'FEMALE', '0123456780', '1023456789012', 'resident5@example.com', 'RESIDENT'),
    (UUID(), 'resident6', '$2a$12$6pyYWLWD2J7MnSauhvVf4uy35eCq6dMwCD8uwITvKF/jHps4PnRdi', 'Resident Six', 'MALE', '0123456700', '923456789023', 'resident6@example.com', 'RESIDENT'),
    (UUID(), 'resident7', '$2a$12$YysE2vgPyO/D0t/V.kklcuPr/T3f4y0vWxE66cTmZS21U5BQX477u', 'Resident Seven', 'FEMALE', '0123453280', '1023456789010', 'resident7@example.com', 'RESIDENT'),
    (UUID(), 'resident8', '$2a$12$.EQjeq0ZasIEO.yR/3P0O.d2nXKIIVgIZD3OExLbQkqJbcsWyw4IK', 'Resident Eight', 'FEMALE', '0123253280', '1023456712010', 'resident8@example.com', 'RESIDENT'),
    (UUID(), 'resident9', '$2a$12$vJyjnMSQsB3dIg32GabGBudI4QC9SPYCXZ9g4Hhp5nYjSOJL/NqKq', 'Resident Nine', 'FEMALE', '0123453980', '8723456789010', 'resident9@example.com', 'RESIDENT'),
    (UUID(), 'resident10', '$2a$12$83HRG2MW80yUr6A951HXbOKOCpLlDyW.j0b/jxbGai6fCIgHhkeIu', 'Resident Ten', 'FEMALE', '0123293280', '9923456712010', 'resident10@example.com', 'RESIDENT');


INSERT INTO residents (id, status)
VALUES
    ((SELECT id FROM users WHERE username='resident1'), 'APPROVED'),
    ((SELECT id FROM users WHERE username='resident2'), 'PENDING'),
    ((SELECT id FROM users WHERE username='resident3'), 'PENDING'),
    ((SELECT id FROM users WHERE username='resident4'), 'PENDING'),
    ((SELECT id FROM users WHERE username='resident5'), 'REJECTED'),
    ((SELECT id FROM users WHERE username='resident6'), 'PENDING'),
    ((SELECT id FROM users WHERE username='resident7'), 'PENDING'),
    ((SELECT id FROM users WHERE username='resident8'), 'APPROVED'),
    ((SELECT id FROM users WHERE username='resident9'), 'APPROVED'),
    ((SELECT id FROM users WHERE username='resident10'), 'APPROVED');

-- Insert Security Staff (3 Users)
INSERT INTO users (id, username, password, name, gender, phone, IC, email, role)
VALUES
    (UUID(), 'security1', '$2a$12$OT6g.gDBwVclQSp8K1oj8OxYnc1dnvwRBRG8/tFpp9Px9qC85VO/2', 'Security One', 'MALE', '0123456779', '2023456789012', 'security1@example.com', 'SECURITY_STAFF'),
    (UUID(), 'security2', '$2a$12$0PHkm8mqFfTy/C41h60NrOImnxOaza5xg3ltOtQj4.W72guxTaJJe', 'Security Two', 'FEMALE', '0123456778', '3023456789012', 'security2@example.com', 'SECURITY_STAFF'),
    (UUID(), 'security3', '$2a$12$yTDCuRwrCEqyBG2YvC.H8uqbHbNfhIUw1/loYrKVf.srUh1C7byXS', 'Security Three', 'FEMALE', '0223456778', '3099456789012', 'security3@example.com', 'SECURITY_STAFF');

INSERT INTO security_staff (id, shift)
VALUES
    ((SELECT id FROM users WHERE username='security1'), 'MORNING'),
    ((SELECT id FROM users WHERE username='security2'), 'EVENING'),
    ((SELECT id FROM users WHERE username='security3'), 'NIGHT');

-- Insert sample visit requests (Fixed logic for REACHED status)
INSERT INTO visit_requests (
    id, resident_id, security_staff_id, verification_code,
    visitor_name, visitor_phone, visitor_ic, visitor_email, visitor_address,
    visit_date, visit_time, purpose, status, managing_staff_id, approval_date, created_at, updated_at, check_in_time, check_out_time, expired_at
) VALUES
      -- APPROVED request (No security yet) EXPIRED
      (UUID(), (SELECT id FROM users WHERE username='resident1'), NULL,
       'ABC123', 'John Doe', '0123456789', '111122223333', 'johndoe@example.com', '123 Main St, City',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')) - INTERVAL 1 DAY
          , TIME(NOW() - INTERVAL 1 DAY), 'Family Visit', 'APPROVED', NULL, NULL, DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, NULL,
       TIMESTAMP(CONVERT_TZ(CURDATE(), '+00:00', '+08:00'), '23:59:59')),

      -- REACHED request (Security confirmed arrival)
      (UUID(), (SELECT id FROM users WHERE username='resident1'), (SELECT id FROM users WHERE username='security1'),
       'XYZ999', 'Alice Green', '0192345678', '222211119999', 'alicegreen@example.com', '222 Avenue St, City',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), TIME(NOW() - INTERVAL 20 MINUTE), 'Business Meeting', 'REACHED',
       (SELECT id FROM users WHERE username='manager1'), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, TIMESTAMP(CONVERT_TZ(CURDATE(), '+00:00', '+08:00'), '23:59:59')),

      -- APPROVED request (No security yet)
      (UUID(), (SELECT id FROM users WHERE username='resident2'), NULL,
       'XYZ789', 'Alice Brown', '0176543210', '333344445555', 'alicebrown@example.com', '789 Pine St, Village',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), TIME(NOW() + INTERVAL 20 MINUTE), 'Business Meeting', 'APPROVED',
       (SELECT id FROM users WHERE username='manager1'), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, NULL, TIMESTAMP(CONVERT_TZ(CURDATE(), '+00:00', '+08:00'), '23:59:59')),

      -- Client Meeting (APPROVED, No security yet)
      (UUID(), (SELECT id FROM users WHERE username='resident5'), NULL,
       'GHI654', 'Emma Wilson', '0198877665', '444455556666', 'emmawilson@example.com', '321 Oak St, Metro',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), TIME(NOW() - INTERVAL 20 MINUTE), 'Client Meeting', 'APPROVED',
       (SELECT id FROM users WHERE username='manager3'), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, NULL, TIMESTAMP(CONVERT_TZ(CURDATE(), '+00:00', '+08:00'), '23:59:59')),

      -- Delivery (REJECTED, No security needed)
      (UUID(), (SELECT id FROM users WHERE username='resident3'), NULL,
       NULL, 'Tom Smith', '0112233445', '555566667777', 'tomsmith@example.com', '654 Maple St, Valley',
       '2025-03-12', '11:00', 'Delivery', 'REJECTED',
       (SELECT id FROM users WHERE username='manager2'), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, NULL, NULL),

      -- Work Meeting (PENDING, No security yet)
      (UUID(), (SELECT id FROM users WHERE username='resident1'), NULL,
       NULL, 'Michael Scott', '0167894561', '666677778888', 'michaels@example.com', '987 Cedar St, Town',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), TIME(NOW() - INTERVAL 20 MINUTE), 'Work Meeting', 'PENDING', NULL, NULL, DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, NULL, NULL),

      -- Friend Visit (PENDING, No security yet)
      (UUID(), (SELECT id FROM users WHERE username='resident1'), NULL,
       NULL, 'Pam Beesly', '0171237896', '777788889999', 'pambeesly@example.com', '246 Birch St, City',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), TIME(NOW() + INTERVAL 55 MINUTE), 'Friend Visit', 'PENDING', NULL, NULL, DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, NULL, NULL),

      -- Family Visit (REACHED, Security confirmed)
      (UUID(), (SELECT id FROM users WHERE username='resident1'), (SELECT id FROM users WHERE username='security2'),
       'RST987', 'Jim Halpert', '0135678945', '888899990000', 'jimhalpert@example.com', '135 Aspen St, Town',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), TIME(NOW() - INTERVAL 25 MINUTE), 'Family Visit', 'REACHED', NULL, NULL, DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, TIMESTAMP(CONVERT_TZ(CURDATE(), '+00:00', '+08:00'), '23:59:59')),

      -- Friend Visit (PENDING, No security yet)
      (UUID(), (SELECT id FROM users WHERE username='resident1'), NULL,
       '', 'Kelly Lee', '0171237999', '999900001111', 'kellylee@example.com', '567 Walnut St, Metro',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), TIME(NOW() + INTERVAL 45 MINUTE), 'Friend Visit', 'PENDING', NULL, NULL, DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), NULL, NULL, NULL),

      -- Family Visit (REACHED, Security confirmed)
      (UUID(), (SELECT id FROM users WHERE username='resident1'), (SELECT id FROM users WHERE username='security1'),
       'RST287', 'James Choo', '0135678941', '101112131415', 'jameschoo@example.com', '789 Cherry St, Valley',
       DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), TIME(NOW() - INTERVAL 15 MINUTE), 'Family Visit', 'REACHED',
       (SELECT id FROM users WHERE username='manager2'), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')), now(), NULL, TIMESTAMP(CONVERT_TZ(CURDATE(), '+00:00', '+08:00'), '23:59:59'));
