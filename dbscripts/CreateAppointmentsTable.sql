DROP TABLE IF EXISTS Appointments;
CREATE TABLE Appointments (
    AptId SERIAL UNIQUE,
    VisitId INT NOT NULL,
    apt_datetime TIMESTAMP NOT NULL,
    writeup_link VARCHAR(128),
    PRIMARY KEY (AptId, VisitId),
    FOREIGN KEY (VisitId) REFERENCES Visits(VisitId)
);