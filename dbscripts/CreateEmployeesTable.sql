DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeId SERIAL UNIQUE,
	efirst_name VARCHAR(32) NOT NULL,
	elast_name VARCHAR(32) NOT NULL,
	phone_num VARCHAR(20) NOT NULL,
	address VARCHAR(64) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
	bimonthly_wage DECIMAL(32, 4),
	PRIMARY KEY (EmployeeId)
);