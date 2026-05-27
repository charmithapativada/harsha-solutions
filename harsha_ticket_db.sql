-- HARSHA PERFECT SOLUTIONS - Ticket Management System Database

-- Drop existing database if exists
DROP DATABASE IF EXISTS harsha_ticket_db;
CREATE DATABASE harsha_ticket_db;
USE harsha_ticket_db;

-- Users Table
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'DEVELOPER', 'CLIENT') NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    department VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_role (role),
    INDEX idx_email (email)
);

-- Tickets Table
CREATE TABLE tickets (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ticket_id VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description LONGTEXT NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'ON_HOLD') DEFAULT 'OPEN',
    category VARCHAR(100),
    client_id BIGINT NOT NULL,
    assigned_to BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_ticket_id (ticket_id),
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_assigned_to (assigned_to),
    INDEX idx_client_id (client_id)
);

-- Ticket Comments Table
CREATE TABLE ticket_comments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_ticket_id (ticket_id),
    INDEX idx_user_id (user_id)
);

-- Ticket Attachments Table
CREATE TABLE ticket_attachments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    uploaded_by BIGINT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_ticket_id (ticket_id)
);

-- Ticket Activity Log Table
CREATE TABLE ticket_activity_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    action VARCHAR(100),
    description VARCHAR(255),
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_ticket_id (ticket_id),
    INDEX idx_created_at (created_at)
);

-- Email Notifications Table
CREATE TABLE email_notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ticket_id BIGINT,
    recipient_email VARCHAR(100) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    body LONGTEXT NOT NULL,
    status ENUM('PENDING', 'SENT', 'FAILED') DEFAULT 'PENDING',
    attempts INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP NULL,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE SET NULL,
    INDEX idx_status (status)
);

-- Indexes for performance
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_tickets_created_at ON tickets(created_at);
CREATE INDEX idx_tickets_status_priority ON tickets(status, priority);

-- Sample Admin User (password: admin123 - hashed with bcrypt)
INSERT INTO users (username, email, password, role, first_name, last_name, department) 
VALUES ('admin', 'admin@harshaperfect.com', '$2a$10$slYQmyNdGzin7olVN3DOCOYygZH.0ANNvfRrwXbmWes5PjjzQUHhK', 'ADMIN', 'Admin', 'User', 'Administration');

-- Sample Developer User (password: dev123)
INSERT INTO users (username, email, password, role, first_name, last_name, department) 
VALUES ('developer', 'dev@harshaperfect.com', '$2a$10$lO7h3lqKPzZ5ND1w8U3HwOYF9nG.0BJMvGH.4MNmWef8QjkzTULr6', 'DEVELOPER', 'Dev', 'User', 'Development');

-- Sample Client User (password: client123)
INSERT INTO users (username, email, password, role, first_name, last_name, department) 
VALUES ('client', 'client@harshaperfect.com', '$2a$10$xZ9pK2lMQrB7ST5vP1uR9OZL8mN.0CPNwHI.5POlXfg9RjkaUVMse', 'CLIENT', 'Client', 'User', 'Support');
