DROP TABLE IF EXISTS Doctors;
CREATE TABLE Doctors (
    EmployeeId INT NOT NULL,
	md_license_num VARCHAR(16) NOT NULL UNIQUE,
	doctor_type VARCHAR(32) NOT NULL,
	PRIMARY KEY (EmployeeId),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId)
);