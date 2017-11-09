DROP TABLE IF EXISTS Hospital;
CREATE TABLE Hospital(
    HospitalId SERIAL,
	hname_short VARCHAR(4) NOT NULL,
	hname_full VARCHAR(32) NOT NULL,
	address VARCHAR(32),
	phone_num VARCHAR(32),
	postal_code VARCHAR(10),
	PRIMARY KEY (HospitalId)
);
insert into Hospital 
VALUES(DEFAULT, 'VGH', 'Vancouver General Hospital', '899 W 12th Ave, Vancouver, BC', '(604) 875-4111', 'V5Z 1M9'); 
SELECT * FROM Hospital;