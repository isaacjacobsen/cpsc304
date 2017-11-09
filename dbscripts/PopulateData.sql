/* Create Basic Users */
INSERT INTO Users (username, password, type)
VALUES ('test', 'test', 'PAT');
INSERT INTO Users (username, password, type)
VALUES ('hey', 'yo', 'DOC');

/* Create Employees */
INSERT INTO Employees (efirst_name, elast_name, phone_num, address, postal_code, bimonthly_wage)
VALUES('Zach', 'Zuckerburg', '(778)-000-3333', '1000 Heather St', 'V2J9H7', 5500.25); 
INSERT INTO Employees (efirst_name, elast_name, phone_num, address, postal_code, bimonthly_wage)
VALUES('Yoshi', 'Yamaha', '(604)-135-2468', '200 Granville St', 'V9H7K9', 5805.98);
INSERT INTO Employees (efirst_name, elast_name, phone_num, address, postal_code, bimonthly_wage)
VALUES('Jenny', 'Appletree', '(604)-139-2468', '123 Main St', 'V7K2Q0', 2505.88);
INSERT INTO Employees (efirst_name, elast_name, phone_num, address, postal_code, bimonthly_wage)
VALUES('John', 'Norton', '(778)-992-2468', '874 29th Ave', 'V0I4H8', 2790.88);

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
INSERT INTO Patients (pfirst_name, plast_name, phone_num, address, postal_code)
VALUES('John', 'Doe', '(604)-121-1111', '1234 Main St', 'V1V1A1'); 
INSERT INTO Patients (pfirst_name, plast_name, phone_num, address, postal_code)
VALUES('Adam', 'Armstrong', '(250)-100-9999', '222 Marine Drive', 'V1A9V9'); 
INSERT INTO Patients (pfirst_name, plast_name, phone_num, address, postal_code) 
VALUES('Ben', 'Brown', '(778)-000-1111', '333 Canada Way', 'V2Q2R4'); 
INSERT INTO Patients (pfirst_name, plast_name, phone_num, address, postal_code) 
VALUES('Connor', 'Clark', '(604)-123-4567', '999 Queen St', 'T5U9I0');

INSERT INTO Hospitals 
VALUES(DEFAULT, 'VGH', 'Vancouver General Hospital', '899 W 12th Ave, Vancouver, BC', 'V5Z1M9', '(604)-875-4111'); 