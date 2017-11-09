DROP TABLE IF EXISTS Visits;
CREATE TABLE Visits (
    VisitId SERIAL UNIQUE,
    HospitalId INT NOT NULL, 
    PatientId INT NOT NULL,
    admitted_datetime TIMESTAMP,
    discharged_datetime TIMESTAMP,
    PRIMARY KEY (VisitId),
    FOREIGN KEY (HospitalId)
        REFERENCES Hospitals(HospitalId)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (PatientId)
        REFERENCES Patients(PatientId)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT patient_arrived UNIQUE(PatientId, admitted_datetime),
    CONSTRAINT patient_left UNIQUE(PatientId, discharged_datetime)
);