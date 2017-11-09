DROP TABLE IF EXISTS Wards;
CREATE TABLE Wards(
    wardid SERIAL UNIQUE,
    hospitalid INT NOT NULL,
    ward_name VARCHAR(32) NOT NULL,
    ext_num VARCHAR(5),
    PRIMARY KEY (wardid),
    FOREIGN KEY (hospitalid)
        REFERENCES Hospitals(hospitalid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT ward_at_hospital UNIQUE(hospitalid, ward_name)
);