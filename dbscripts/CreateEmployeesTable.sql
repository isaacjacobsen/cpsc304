DROP TABLE IF EXISTS Employees;
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