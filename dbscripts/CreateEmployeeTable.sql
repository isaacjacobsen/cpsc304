DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(
    EmployeeId SERIAL UNIQUE,
	efirst_name VARCHAR(32) NOT NULL,
	elast_name VARCHAR(32) NOT NULL,
	phone_number VARCHAR(12) NOT NULL,
	address VARCHAR(32) NOT NULL,
	bimonthly_wage DECIMAL(32, 4),
	PRIMARY KEY (EmployeeId)
);

insert into Employee (efirst_name, elast_name, phone_number, address, bimonthly_wage)
VALUES('Zach', 'Zuckerburg', '7780003333', '1000 Heather St', 5500.25); 
insert into Employee (efirst_name, elast_name, phone_number, address, bimonthly_wage)
VALUES('Yoshi', 'Yamaha', '6041352468', '200 Granville St', 5805.98); 
SELECT * FROM Employee;