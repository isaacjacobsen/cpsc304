DROP TABLE IF EXISTS AttendsAppointment;
CREATE TABLE AttendsAppointment (
    employeeid INT NOT NULL,
    visitid INT NOT NULL,
    apt_datetime TIMESTAMP NOT NULL,
    PRIMARY KEY (employeeid, visitid, apt_datetime),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (visitid, apt_datetime)
        REFERENCES Appointments(visitid, apt_datetime)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);