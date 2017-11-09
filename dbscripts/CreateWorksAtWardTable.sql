DROP TABLE IF EXISTS WorksAtWard;
CREATE TABLE WorksAtWard (
    employeeid INT NOT NULL,
    wardid INT NOT NULL,
	PRIMARY KEY (employeeid, wardid),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (wardid)
        REFERENCES Wards(wardid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);