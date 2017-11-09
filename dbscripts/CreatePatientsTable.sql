DROP TABLE IF EXISTS Patients;
CREATE TABLE Patients (
    PatientId SERIAL UNIQUE,
	pfirst_name VARCHAR(32) NOT NULL,
	plast_name VARCHAR(32) NOT NULL,
	phone_number VARCHAR(12) NOT NULL,
	address VARCHAR(32) NOT NULL,
	postal_code VARCHAR(32),
	PRIMARY KEY (patientid)
);