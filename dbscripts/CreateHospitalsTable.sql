DROP TABLE IF EXISTS Wards;
DROP TABLE IF EXISTS Hospitals;
CREATE TABLE Hospitals(
    HospitalId SERIAL UNIQUE,
	hname_short VARCHAR(4) NOT NULL,
	hname_full VARCHAR(32) NOT NULL,
	address VARCHAR(64) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
	phone_num VARCHAR(20) NOT NULL,
	PRIMARY KEY (HospitalId),
	UNIQUE(hname_full,hname_short,phone_num)
);