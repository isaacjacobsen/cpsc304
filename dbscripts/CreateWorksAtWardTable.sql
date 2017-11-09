DROP TABLE IF EXISTS WorksAtWard;
CREATE TABLE WorksAtWard (
    EmployeeId INT NOT NULL,
    WardId INT NOT NULL,
	PRIMARY KEY (EmployeeId, WardId),
    FOREIGN KEY (EmployeeId)
        REFERENCES Employees(EmployeeId)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (WardId)
        REFERENCES Wards(WardId)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);