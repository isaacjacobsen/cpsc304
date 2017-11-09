DROP TABLE IF EXISTS Visits;
CREATE TABLE Visits (
    VisitId SERIAL UNIQUE,
	HospitalId INT NOT NULL, 
	PatientId INT NOT NULL,
	date_time_admitted TIMESTAMP,
	date_time_discharged TIMESTAMP,
	PRIMARY KEY (VisitId),
	FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId),
	FOREIGN KEY (PatientId) REFERENCES Patients(PatientId)
);