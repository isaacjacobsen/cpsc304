/* Create Basic Users */
INSERT INTO Users (username, password)
VALUES ('test', 'test');
INSERT INTO Users (username, password)
VALUES ('hey', 'yo');

/* Create Employees */
INSERT INTO Employees (efirst_name, elast_name, phone_number, address, bimonthly_wage)
VALUES('Zach', 'Zuckerburg', '7780003333', '1000 Heather St', 5500.25); 
INSERT INTO Employees (efirst_name, elast_name, phone_number, address, bimonthly_wage)
VALUES('Yoshi', 'Yamaha', '6041352468', '200 Granville St', 5805.98);
INSERT INTO Employees (efirst_name, elast_name, phone_number, address, bimonthly_wage)
VALUES('Jenny', 'Appletree', '6041392468', '123 Main St', 2505.88);
INSERT INTO Employees (efirst_name, elast_name, phone_number, address, bimonthly_wage)
VALUES('John', 'Norton', '7789922468', '874 29th Ave', 2790.88);

/* Create Doctors */
INSERT INTO Doctors
VALUES(1, '1245hfaofe', 'Neuro Surgeon'); 
INSERT INTO Doctors
VALUES(2, '34124fsgfs', 'Pediatrician');

/* Create Nurses */
INSERT INTO Nurses
VALUES(3, 'ER');
INSERT INTO Nurses
VALUES(4, 'Pediatric');

/* Create Patients */
INSERT INTO Patients (pfirst_name, plast_name, phone_number, address, postal_code)
VALUES('John', 'Doe', '6041211111', '1234 Main St', 'V1V1A1'); 
INSERT INTO Patients (pfirst_name, plast_name, phone_number, address, postal_code)
VALUES('Adam', 'Armstrong', '2501009999', '222 Marine Drive', 'V1A9V9'); 
INSERT INTO Patients (pfirst_name, plast_name, phone_number, address, postal_code) 
VALUES('Ben', 'Brown', '7780001111', '333 Canada Way', 'V2Q2R4'); 
INSERT INTO Patients (pfirst_name, plast_name, phone_number, address, postal_code) 
VALUES('Connor', 'Clark', '6141234567', '999 Queen St', 'T5U9I0');

INSERT INTO Hospital 
VALUES(DEFAULT, 'VGH', 'Vancouver General Hospital', '899 W 12th Ave, Vancouver, BC', '(604) 875-4111', 'V5Z 1M9'); 