/* #1: This is for adding an appointment for a specific user currently at the hospital */
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
                pname = 'John Doe'
                AND phone_num = '(604)-121-1111');

CREATE TEMP TABLE CurrentTime AS
SELECT current_timestamp AS cts;

CREATE TEMP TABLE DoctorAtAppointment AS
SELECT E.Employeeid
FROM
    Employees E
    JOIN Doctors D ON D.EmployeeId = E.EmployeeId
WHERE
    ename = 'Zach Zuckerburg'
    AND phone_num = '(778)-000-3333';

INSERT INTO Appointments
VALUES((SELECT visitid FROM PatientVisit), (SELECT cts FROM CurrentTime));

INSERT INTO AttendsAppointment
VALUES((SELECT EmployeeId FROM DoctorAtAppointment), (SELECT visitid FROM PatientVisit), (SELECT cts FROM CurrentTime));

ROLLBACK;

/* #2: This deletes an employee from a specific ward */
BEGIN TRANSACTION;

DELETE FROM WorksAtWard
WHERE
    EmployeeId = 
        (SELECT EmployeeId
        FROM Employees
        WHERE
            ename = 'Paul George'
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

/* #3: This updates a user's phone number */
BEGIN TRANSACTION;

UPDATE Patients
SET phone_num = '(604)-222-2222'
WHERE
    pname = 'Ben Brown'
    AND address like '%333 Canada Way%';

SELECT * FROM Patients;

ROLLBACK;

/* #4: This gets all the patients' names admitted to VGH this month */
SELECT DISTINCT pname
FROM
    Visits V
    JOIN Patients P ON P.PatientId = V.PatientId
    JOIN Hospitals H ON H.HospitalId = V.HospitalId
WHERE
    (SELECT EXTRACT(YEAR FROM admitted_datetime)) = (SELECT EXTRACT(YEAR FROM current_timestamp))
    AND (SELECT EXTRACT(MONTH FROM admitted_datetime)) = (SELECT EXTRACT(MONTH FROM current_timestamp))
    AND H.hname_short = 'VGH'

/* #5: This gets the names of the employees who have had an appointment with "Adam Armstrong" */
SELECT ename
FROM
    Employees E
    JOIN AttendsAppointment AA ON AA.EmployeeID = E.EmployeeId
    JOIN Visits V ON V.VisitId = AA.VisitId
    JOIN Patients P ON P.PatientId = V.PatientId
WHERE
    pname = 'Adam Armstrong'

/* #6: This gets the names of all employees who work at a specific ward */
SELECT
    ename,
    CASE
        WHEN D.doctor_type IS NOT NULL THEN 'Doctor'
        WHEN N.nurse_type IS NOT NULL THEN 'Nurse'
        ELSE 'Unknown'
    END AS EmployeeType
FROM
    Wards W
    JOIN WorksAtWard WAW ON WAW.WardId = W.WardId
    JOIN Employees E ON E.EmployeeId = WAW.EmployeeId
    JOIN Hospitals H ON H.HospitalId = W.HospitalId
    LEFT JOIN Doctors D ON D.EmployeeId = E.EmployeeId
    LEFT JOIN Nurses N On N.EmployeeId = E.EmployeeId
WHERE
    hname_full = 'Vancouver General Hospital'
    AND ward_name = 'ICU'

/* #7: This gets the yearly pay for each employee */
SELECT
    ename,
    YearlyPay,
    CASE
        WHEN D.doctor_type IS NOT NULL THEN 'Doctor'
        WHEN N.nurse_type IS NOT NULL THEN 'Nurse'
        ELSE 'Unknown'
    END AS EmployeeType
FROM
    (SELECT
        EmployeeId,
        SUM(pay_amt) As YearlyPay
    FROM
        Payroll
    WHERE
        (SELECT EXTRACT(YEAR FROM pay_date)) = '2017'
    GROUP BY
        EmployeeId) YP
    JOIN Employees E ON E.EmployeeId = YP.EmployeeId
    LEFT JOIN Doctors D On D.EmployeeId = E.EmployeeId
    LEFT JOIN Nurses N On N.EmployeeId = E.EmployeeId
ORDER BY
    YearlyPay DESC

/* #8: Find names of patients who haven't checked out yet of hospital (use short name) (No discharge date) */
/*SELECT DISTINCT
    pname As PatientName
FROM
    Visits V
    JOIN Hospitals H ON H.HospitalId = V.HospitalId
    JOIN Patients P ON P.PatientId = V.PatientId
WHERE
    (((SELECT EXTRACT(MONTH FROM admitted_datetime)) >= 9 AND (SELECT EXTRACT(YEAR FROM admitted_datetime)) >= 2017)
    OR (SELECT EXTRACT(YEAR FROM admitted_datetime)) > 2017)
    AND H.hname_full = 'Vancouver General Hospital'*/

/* #9: This finds the cardiologists that work in the same hospital as "Yoshi Yamaha" */
SELECT DISTINCT
    E2.EmployeeId,
    ename
FROM
    Employees E2
    JOIN WorksAtWard WAW2 ON WAW2.EmployeeId = E2.EmployeeId
    JOIN Wards W2 ON W2.WardId = WAW2.WardId
    JOIN Hospitals H2 ON H2.HospitalId = W2.HospitalId
    JOIN Doctors D ON D.EmployeeId = E2.EmployeeId
WHERE
    ename <> 'Yoshi Yamaha'
    AND D.doctor_type = 'Cardiologist'
    AND H2.HospitalId IN
        (SELECT DISTINCT
            H.HospitalId
        FROM
            Employees E
            JOIN WorksAtWard WAW ON WAW.EmployeeId = E.EmployeeId
            JOIN Wards W ON W.WardId = WAW.WardId
            JOIN Hospitals H ON H.HospitalId = W.HospitalId
        WHERE
            ename = 'Yoshi Yamaha')

/* #10: Number of appointments by each employee */
SELECT
    E.EmployeeId,
    ename As EmployeeName,
    CASE
        WHEN D.doctor_type IS NOT NULL THEN 'Doctor'
        WHEN N.nurse_type IS NOT NULL THEN 'Nurse'
        ELSE 'Unknown'
    END AS EmployeeType,
    COUNT(*) As AppointmentCount
FROM
    Appointments A
    JOIN Visits V ON V.VisitId = A.VisitId
    JOIN AttendsAppointment AA ON AA.VisitId = A.VisitId AND AA.apt_datetime = A.apt_datetime
    JOIN Employees E ON E.EmployeeId = AA.EmployeeId
    LEFT JOIN Doctors D ON D.EmployeeId = E.EmployeeId
    LEFT JOIN Nurses N ON N.EmployeeId = E.EmployeeId
GROUP BY
    E.EmployeeId,
    D.doctor_type,
    N.nurse_type
ORDER BY
    COUNT(*) DESC,
    CASE
        WHEN D.doctor_type IS NOT NULL THEN 2
        WHEN N.nurse_type IS NOT NULL THEN 1
        ELSE 0
    END DESC,
    ename