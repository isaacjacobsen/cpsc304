DROP TABLE IF EXISTS Doctors;
CREATE TABLE Doctors (
    employeeid INT NOT NULL,
	md_license_num VARCHAR(16) NOT NULL UNIQUE,
	doctor_type VARCHAR(32) NOT NULL,
	PRIMARY KEY (employeeid),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);