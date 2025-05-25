CREATE DATABASE IF NOT EXISTS todo_app;

USE todo_app;

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('male', 'female', 'other') DEFAULT 'other',
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    task_header VARCHAR(100) NOT NULL,
    task_description TEXT,
    user_id INT NOT NULL,
    creation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finish_time TIMESTAMP NULL,
    complete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (user_name, password, email, gender, role)
SELECT
    'admin',
    'scrypt:32768:8:1$92VdACpHlhkUDc8J$a5eab9363c17076a3bd2f50597e59b1c58f4adb23591f8487412b0b6d1bf8b7a69d0bedddf2572626d1dd42dad4d53240474d829ab064128d214abbb8bacd51c', -- 'admin123'
    'admin@example.com',
    'other',
    'admin'
WHERE NOT EXISTS (
    SELECT 1 FROM users WHERE user_name = 'admin'
);

CREATE USER 'app_user'@'%' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON todo_app.* TO 'app_user'@'%';
FLUSH PRIVILEGES;
