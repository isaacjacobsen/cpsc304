DROP TABLE IF EXISTS Nurses;
CREATE TABLE Nurses (
    employeeid INT NOT NULL,
	nurse_type VARCHAR(32) NOT NULL,
	PRIMARY KEY (employeeid),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);