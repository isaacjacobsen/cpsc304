DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(
    EmployeeId VARCHAR(32) NOT NULL,
	efirst_name VARCHAR(32) NOT NULL,
	elast_name VARCHAR(32) NOT NULL,
	phone_number VARCHAR(12) NOT NULL,
	address VARCHAR(32) NOT NULL,
	bimonthly_wage DECIMAL(32, 4),
	PRIMARY KEY (EmployeeId)
);

insert into Employee 
VALUES('9800', 'Zach', 'Zuckerburg', '7780003333', '1000 Heather St', 5500.25); 
insert into Employee
VALUES('6089', 'Yoshi', 'Yamaha', '6041352468', '200 Granville St', 5805.98); 
SELECT * FROM Employee;