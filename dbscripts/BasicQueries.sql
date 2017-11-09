// This is for adding an appointment for a specific user currently at the hospital
BEGIN TRANSACTION;
DROP TABLE IF EXISTS PatientVisit;
DROP TABLE IF EXISTS CurrentTime;
DROP TABLE IF EXISTS DoctorAtAppointment;

CREATE TEMP TABLE PatientVisit AS
SELECT visitid
FROM
    Visits
WHERE
    discharged_datetime IS NULL
    AND patientid = (SELECT patientid
            FROM Patients
            WHERE
                (pfirst_name || ' ' || plast_name) = 'John Doe'
                AND phone_num = '(604)-121-1111');

CREATE TEMP TABLE CurrentTime AS
SELECT current_timestamp AS cts;

CREATE TEMP TABLE DoctorAtAppointment AS
SELECT E.Employeeid
FROM
    Employees E
    JOIN Doctors D ON D.EmployeeId = E.EmployeeId
WHERE
    (efirst_name || ' ' || elast_name) = 'Zach Zuckerburg'
    AND phone_num = '(778)-000-3333';

INSERT INTO Appointments
VALUES((SELECT visitid FROM PatientVisit), (SELECT cts FROM CurrentTime));

INSERT INTO AttendsAppointment
VALUES((SELECT EmployeeId FROM DoctorAtAppointment), (SELECT visitid FROM PatientVisit), (SELECT cts FROM CurrentTime));

ROLLBACK;

// This deletes an employee from a specific ward
BEGIN TRANSACTION;

DELETE FROM WorksAtWard
WHERE
    EmployeeId = 
        (SELECT EmployeeId
        FROM Employees
        WHERE
            (efirst_name || ' ' || elast_name) = 'Paul George'
            AND phone_num = '(604)-202-9402')
    AND WardId = 
        (SELECT WardId
        FROM
            Wards W
            JOIN Hospitals H ON H.HospitalId = W.HospitalId
        WHERE
            hname_full = 'Vancouver General Hospital'
            AND ward_name = 'CCU');

ROLLBACK;