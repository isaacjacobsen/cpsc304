DROP TABLE IF EXISTS Nurses;
CREATE TABLE Nurses (
    EmployeeId INT NOT NULL,
	nurse_type VARCHAR(32) NOT NULL,
	PRIMARY KEY (EmployeeId),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId)
);