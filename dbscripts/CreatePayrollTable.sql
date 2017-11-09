DROP TABLE IF EXISTS Payroll;
CREATE TABLE Payroll(
    PayId SERIAL UNIQUE,
	HospitalId INT NOT NULL, 
	EmployeeId INT NOT NULL,
	pay_amt DECIMAL(32, 4),
	pay_date TIMESTAMP,
	PRIMARY KEY (PayId),
	FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId),
	FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId)
);