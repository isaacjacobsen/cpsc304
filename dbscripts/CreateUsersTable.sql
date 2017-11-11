DROP TABLE IF EXISTS Users;
CREATE TABLE Users(
    userid SERIAL UNIQUE,
    username VARCHAR(32) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    isActive BOOLEAN NOT NULL DEFAULT TRUE,
    name VARCHAR(32),
    typeid INT NOT NULL,
    employeeid INT,
    patientid INT,
    PRIMARY KEY (userid),
    FOREIGN KEY (typeid)
        REFERENCES usertypes(usertypeid),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (patientid)
        REFERENCES Patients(patientid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);