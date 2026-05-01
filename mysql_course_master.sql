-- =========================================
-- MySQL Course Master Script
-- Covers Chapters 1–34
-- =========================================

-- PART I: FOUNDATIONS
-- Chapter 1: Installation & Connection
-- (No SQL needed here, just setup commands)

-- Chapter 2: Databases & Tables
CREATE DATABASE course_master;
USE course_master;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    enrolled DATE,
    gpa DECIMAL(3,2)
);

-- Chapter 3: Data Types
-- Example columns already included above

-- =========================================
-- PART II: CORE SQL — QUERYING DATA
-- Chapter 4: SELECT
SELECT * FROM students;
SELECT first_name, last_name, gpa FROM students;

-- Chapter 5: WHERE
SELECT * FROM students WHERE age BETWEEN 18 AND 25;

-- Chapter 6: ORDER BY & LIMIT
SELECT * FROM students ORDER BY gpa DESC LIMIT 5;

-- Chapter 7: Aggregate Functions
SELECT AVG(gpa) AS avg_gpa, COUNT(*) AS total FROM students;

-- =========================================
-- PART III: MANIPULATING DATA
-- Chapter 8: INSERT
INSERT INTO students (first_name, last_name, gpa, enrolled)
VALUES ('Alice','Johnson',3.85,'2023-09-01');

-- Chapter 9: UPDATE
UPDATE students SET gpa = 3.95 WHERE id = 1;

-- Chapter 10: DELETE
DELETE FROM students WHERE gpa < 2.0;

-- =========================================
-- PART IV: RELATIONSHIPS & JOINS
-- Chapter 11: Foreign Keys
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    credits INT DEFAULT 3
);

CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade DECIMAL(4,2),
    enrolled DATE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE RESTRICT,
    UNIQUE (student_id, course_id)
);

-- Chapter 12: JOINs
SELECT s.first_name, c.name, e.grade
FROM students s
INNER JOIN enrollments e ON s.id = e.student_id
INNER JOIN courses c ON c.id = e.course_id;

-- Chapter 13: Subqueries
SELECT first_name, gpa
FROM students
WHERE gpa > (SELECT AVG(gpa) FROM students);

-- =========================================
-- PART V: ADVANCED MYSQL
-- Chapter 14: Indexes
CREATE INDEX idx_students_email ON students(email);

-- Chapter 15: Views
CREATE VIEW high_gpa AS SELECT * FROM students WHERE gpa >= 3.5;

-- Chapter 16: Stored Procedures
DELIMITER //
CREATE PROCEDURE GetHighGPA()
BEGIN
    SELECT * FROM students WHERE gpa >= 3.5;
END;
//
DELIMITER ;

-- Chapter 17: Triggers
DELIMITER //
CREATE TRIGGER before_student_insert
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    SET NEW.enrolled = CURDATE();
END;
//
DELIMITER ;

-- Chapter 18: Transactions
START TRANSACTION;
UPDATE students SET gpa = gpa + 0.1 WHERE id = 2;
COMMIT;

-- Chapter 19: User Management
CREATE USER 'learner'@'localhost' IDENTIFIED BY 'password123';
GRANT SELECT, INSERT, UPDATE ON course_master.* TO 'learner'@'localhost';

-- Chapter 20: Optimization (example)
EXPLAIN SELECT * FROM students WHERE gpa > 3.5;

-- =========================================
-- PART VI: DATABASE DESIGN
-- Chapter 21: Normalization
-- (Conceptual, no direct SQL — handled in schema design)

-- =========================================
-- PART VII: PERFORMANCE & INTERNALS
-- Chapter 22: Full-Text Search
ALTER TABLE students ADD COLUMN bio TEXT;
CREATE FULLTEXT INDEX idx_bio ON students(bio);

-- Chapter 23: JSON
ALTER TABLE students ADD COLUMN preferences JSON;

-- Chapter 24: Profiling
EXPLAIN ANALYZE SELECT * FROM students WHERE gpa > 3.5;

-- Chapter 25: Partitioning
-- Example: RANGE partition
CREATE TABLE orders (
    id INT NOT NULL,
    order_date DATE NOT NULL
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026)
);

-- Chapter 26: Advanced Procedures
-- (Cursors, error handling — add as needed)

-- Chapter 27: Event Scheduler
SET GLOBAL event_scheduler = ON;
CREATE EVENT cleanup_old_students
ON SCHEDULE EVERY 1 YEAR
DO DELETE FROM students WHERE enrolled < '2020-01-01';

-- =========================================
-- PART VIII: REPLICATION & HIGH AVAILABILITY
-- Chapter 28–29: Replication & Backup
-- (Configuration outside SQL script)

-- =========================================
-- PART IX: CONNECTING MYSQL TO APPLICATIONS
-- Chapter 30–31: Python/Node.js
-- (Handled in external code, not SQL)

-- =========================================
-- PART X: PRACTICE PROJECTS
-- Chapter 32: Exercises
-- (Insert your practice queries here)

-- Chapter 33: Real-World Project (E-Commerce)
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Chapter 34: Cheat Sheet
-- (Quick reference commands already included above)
