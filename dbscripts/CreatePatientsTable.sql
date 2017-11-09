DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient(
    PatientId SERIAL UNIQUE,
	pfirst_name VARCHAR(32) NOT NULL,
	plast_name VARCHAR(32) NOT NULL,
	phone_number VARCHAR(12) NOT NULL,
	address VARCHAR(32) NOT NULL,
	postal_code VARCHAR(32),
	PRIMARY KEY (patientid)
);
insert into patient (pfirst_name, plast_name, phone_number, address, postal_code)
VALUES('John', 'Doe', '6041211111', '1234 Main St', 'V1V1A1'); 
insert into patient (pfirst_name, plast_name, phone_number, address, postal_code)
VALUES('Adam', 'Armstrong', '2501009999', '222 Marine Drive', 'V1A9V9'); 
insert into patient (pfirst_name, plast_name, phone_number, address, postal_code) 
VALUES('Ben', 'Brown', '7780001111', '333 Canada Way', 'V2Q2R4'); 
insert into patient (pfirst_name, plast_name, phone_number, address, postal_code) 
VALUES('Connor', 'Clark', '6141234567', '999 Queen St', 'T5U9I0'); 
SELECT * FROM Patient;