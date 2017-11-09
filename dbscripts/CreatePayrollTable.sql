DROP TABLE IF EXISTS Payroll;
CREATE TABLE Payroll(
    PayId SERIAL UNIQUE,
    HospitalId INT DEFAULT NULL, 
    EmployeeId INT DEFAULT NULL,
    pay_amt DECIMAL(32, 4),
    pay_date TIMESTAMP,
    PRIMARY KEY (PayId),
    FOREIGN KEY (HospitalId)
        REFERENCES Hospitals(HospitalId)
            ON DELETE SET DEFAULT
            ON UPDATE CASCADE,
    FOREIGN KEY (EmployeeId)
        REFERENCES Employees(EmployeeId)
            ON DELETE SET DEFAULT
            ON UPDATE CASCADE,
    CONSTRAINT pay_for_employee UNIQUE(EmployeeId, pay_date)
);