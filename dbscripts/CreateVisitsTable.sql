DROP TABLE IF EXISTS Visits;
CREATE TABLE Visits (
    visitid SERIAL UNIQUE,
    hospitalid INT NOT NULL, 
    patientid INT NOT NULL,
    admitted_datetime TIMESTAMP,
    discharged_datetime TIMESTAMP,
    PRIMARY KEY (visitid),
    FOREIGN KEY (hospitalid)
        REFERENCES Hospitals(hospitalid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (patientid)
        REFERENCES Patients(patientid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT patient_arrived UNIQUE(patientid, admitted_datetime),
    CONSTRAINT patient_left UNIQUE(patientid, discharged_datetime)
);