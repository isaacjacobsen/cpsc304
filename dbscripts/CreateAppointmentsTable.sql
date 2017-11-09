DROP TABLE IF EXISTS Appointments;
CREATE TABLE Appointments (
    VisitId INT NOT NULL,
    apt_datetime TIMESTAMP NOT NULL,
    writeup_link VARCHAR(128) UNIQUE,
    PRIMARY KEY (VisitId, apt_datetime),
    FOREIGN KEY (VisitId)
        REFERENCES Visits(VisitId)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);