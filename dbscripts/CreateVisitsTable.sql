DROP TABLE IF EXISTS Visits;
CREATE TABLE Visits (
    VisitId SERIAL UNIQUE,
    HospitalId INT NOT NULL, 
    PatientId INT NOT NULL,
    admitted_datetime TIMESTAMP,
    discharged_datetime TIMESTAMP,
    PRIMARY KEY (VisitId),
    FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId),
    FOREIGN KEY (PatientId) REFERENCES Patients(PatientId),
    CONSTRAINT patient_arrived UNIQUE(PatientId, admitted_datetime),
    CONSTRAINT patient_left UNIQUE(PatientId, discharged_datetime)
);