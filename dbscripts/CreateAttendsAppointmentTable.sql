DROP TABLE IF EXISTS AttendsAppointment;
CREATE TABLE AttendsAppointment (
    EmployeeId INT NOT NULL,
    AptId INT NOT NULL,
    VisitId INT NOT NULL,
    PRIMARY KEY (EmployeeId, AptId, VisitId),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (AptId) REFERENCES Appointments(AptId),
    FOREIGN KEY (VisitId) REFERENCES Visits(VisitId)
);