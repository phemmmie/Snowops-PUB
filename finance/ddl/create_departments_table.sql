CREATE TABLE finance.departments (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL,
    description TEXT,
    manager_id INT,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

