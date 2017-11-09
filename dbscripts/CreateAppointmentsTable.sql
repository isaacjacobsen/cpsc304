DROP TABLE IF EXISTS Appointments;
CREATE TABLE Appointments (
    visitid INT NOT NULL,
    apt_datetime TIMESTAMP NOT NULL,
    writeup_link VARCHAR(128) UNIQUE,
    PRIMARY KEY (visitid, apt_datetime),
    FOREIGN KEY (visitid)
        REFERENCES Visits(visitid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);