DROP TABLE IF EXISTS Wards;
DROP TABLE IF EXISTS Hospitals;
CREATE TABLE Hospitals(
    HospitalId SERIAL UNIQUE,
	hname_short VARCHAR(4) NOT NULL,
	hname_full VARCHAR(32) NOT NULL,
	address VARCHAR(32),
	phone_num VARCHAR(32),
	postal_code VARCHAR(10),
	PRIMARY KEY (HospitalId)
);