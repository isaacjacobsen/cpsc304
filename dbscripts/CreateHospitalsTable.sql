DROP TABLE IF EXISTS Wards;
DROP TABLE IF EXISTS Hospitals;
CREATE TABLE Hospitals(
    hospitalid SERIAL UNIQUE,
	hname_short VARCHAR(4) NOT NULL,
	hname_full VARCHAR(32) NOT NULL,
	address VARCHAR(64) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
	phone_num VARCHAR(20) NOT NULL,
	PRIMARY KEY (hospitalid),
    CONSTRAINT hname_address UNIQUE(hname_full, address),
    CONSTRAINT hname_postalcode UNIQUE(hname_full, postal_code),
    CONSTRAINT hname_phone UNIQUE(hname_full, phone_num)
);