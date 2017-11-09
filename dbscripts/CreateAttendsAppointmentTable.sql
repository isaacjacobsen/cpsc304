DROP TABLE IF EXISTS AttendsAppointment;
CREATE TABLE AttendsAppointment (
    EmployeeId INT NOT NULL,
    VisitId INT NOT NULL,
    apt_datetime TIMESTAMP NOT NULL,
    PRIMARY KEY (EmployeeId, VisitId, apt_datetime),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (VisitId, apt_datetime) REFERENCES Visits(VisitId, apt_datetime)
);