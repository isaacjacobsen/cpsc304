DROP TABLE IF EXISTS Visit;
CREATE TABLE Visit(
    VisitId SERIAL UNIQUE,
	HospitalId INT NOT NULL, 
	PatientId INT NOT NULL,
	date_time_admitted TIMESTAMP,
	date_time_discharged TIMESTAMP,
	PRIMARY KEY (VisitId),
	FOREIGN KEY (HospitalId) REFERENCES Hospital(HospitalId),
	FOREIGN KEY (PatientId) REFERENCES Patient(PatientId)
);

SELECT * FROM Visit;