CREATE DATABASE IF NOT EXISTS metrics_db;

USE metrics_db;

CREATE TABLE metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cpu_usage FLOAT,
    ram_usage FLOAT,
    processes_running INT,
    total_processes INT,
    processes_sleeping INT,
    processes_zombie INT,
    processes_stopped INT,
    timestamp DATETIME,
    api VARCHAR(50)
);
