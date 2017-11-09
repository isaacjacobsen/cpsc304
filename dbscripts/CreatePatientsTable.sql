DROP TABLE IF EXISTS Patients;
CREATE TABLE Patients (
    patientid SERIAL UNIQUE,
    pname VARCHAR(64) NOT NULL,
    phone_num VARCHAR(20),
    address VARCHAR(64),
    postal_code VARCHAR(6),
    PRIMARY KEY (patientid),
    CONSTRAINT pname_address UNIQUE(pname, address),
    CONSTRAINT pname_phone UNIQUE(pname, phone_num)
);