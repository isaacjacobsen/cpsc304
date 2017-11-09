DROP TABLE IF EXISTS Payroll;
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