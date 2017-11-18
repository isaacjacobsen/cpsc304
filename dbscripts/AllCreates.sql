DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS usertypes;

DROP TABLE IF EXISTS attendsappointment;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS visits;

DROP TABLE IF EXISTS payroll;

DROP TABLE IF EXISTS worksatward;
DROP TABLE IF EXISTS wards;
DROP TABLE IF EXISTS hospitals;

DROP TABLE IF EXISTS patients;

DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS nurses;
DROP TABLE IF EXISTS employees;

CREATE TABLE Hospitals(
    hospitalid SERIAL UNIQUE,
    hname_short VARCHAR(4) NOT NULL UNIQUE,
    hname_full VARCHAR(32) NOT NULL,
    address VARCHAR(64) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
    phone_num VARCHAR(20) NOT NULL,
    PRIMARY KEY (hospitalid),
    CONSTRAINT hname_address UNIQUE(hname_full, address),
    CONSTRAINT hname_postalcode UNIQUE(hname_full, postal_code),
    CONSTRAINT hname_phone UNIQUE(hname_full, phone_num)
);

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


CREATE TABLE Employees (
    employeeid SERIAL UNIQUE,
    ename VARCHAR(64) NOT NULL,
    phone_num VARCHAR(20) NOT NULL,
    address VARCHAR(64) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
    bimonthly_wage DECIMAL(32, 4),
    PRIMARY KEY (employeeid),
    CONSTRAINT ename_address UNIQUE(ename, address),
    CONSTRAINT ename_phone UNIQUE(ename, phone_num)
);

CREATE TABLE Doctors (
    employeeid INT NOT NULL,
    md_license_num VARCHAR(16) NOT NULL UNIQUE,
    doctor_type VARCHAR(32) NOT NULL,
    PRIMARY KEY (employeeid),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE Nurses (
    employeeid INT NOT NULL,
    nurse_type VARCHAR(32) NOT NULL,
    PRIMARY KEY (employeeid),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);


CREATE TABLE WorksAtWard (
    employeeid INT NOT NULL,
    wardid INT NOT NULL,
    PRIMARY KEY (employeeid, wardid),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (wardid)
        REFERENCES Wards(wardid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);


CREATE TABLE Payroll(
    payid SERIAL UNIQUE,
    hospitalid INT DEFAULT NULL, 
    employeeid INT DEFAULT NULL,
    pay_amt DECIMAL(32, 4),
    pay_date TIMESTAMP,
    PRIMARY KEY (payid),
    FOREIGN KEY (hospitalid)
        REFERENCES Hospitals(hospitalid)
            ON DELETE SET DEFAULT
            ON UPDATE CASCADE,
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE SET DEFAULT
            ON UPDATE CASCADE,
    CONSTRAINT pay_for_employee UNIQUE(employeeid, pay_date)
);


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

CREATE TABLE Visits (
    visitid SERIAL UNIQUE,
    hospitalid INT NOT NULL, 
    patientid INT NOT NULL,
    admitted_datetime TIMESTAMP,
    discharged_datetime TIMESTAMP,
    PRIMARY KEY (visitid),
    FOREIGN KEY (hospitalid)
        REFERENCES Hospitals(hospitalid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (patientid)
        REFERENCES Patients(patientid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT patient_arrived UNIQUE(patientid, admitted_datetime),
    CONSTRAINT patient_left UNIQUE(patientid, discharged_datetime)
);

CREATE TABLE Appointments (
    visitid INT NOT NULL,
    apt_datetime TIMESTAMP NOT NULL,
    writeup_link VARCHAR(128) UNIQUE,
    PRIMARY KEY (visitid, apt_datetime),
    FOREIGN KEY (visitid)
        REFERENCES Visits(visitid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE AttendsAppointment (
    employeeid INT NOT NULL,
    visitid INT NOT NULL,
    apt_datetime TIMESTAMP NOT NULL,
    PRIMARY KEY (employeeid, visitid, apt_datetime),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (visitid, apt_datetime)
        REFERENCES Appointments(visitid, apt_datetime)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE UserTypes (
    usertypeid INT NOT NULL,
    usertypename VARCHAR(32) NOT NULL,
    access_patients BOOLEAN,
    access_employees BOOLEAN,
    access_payrolls BOOLEAN,
    access_hospitals BOOLEAN,
    access_appointments BOOLEAN,
    access_users BOOLEAN,
    access_wards BOOLEAN,
    access_visits BOOLEAN,
    PRIMARY KEY (usertypeid)
);

CREATE TABLE Users(
    userid SERIAL UNIQUE,
    username VARCHAR(32) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    isActive BOOLEAN NOT NULL DEFAULT TRUE,
    name VARCHAR(32),
    typeid INT NOT NULL,
    employeeid INT,
    patientid INT,
    PRIMARY KEY (userid),
    FOREIGN KEY (typeid)
        REFERENCES usertypes(usertypeid),
    FOREIGN KEY (employeeid)
        REFERENCES Employees(employeeid)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (patientid)
        REFERENCES Patients(patientid)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);