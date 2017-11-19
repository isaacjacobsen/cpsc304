/* QUERY #1 */
/* This is used to make an appointment with an employee for a specific patient */

/* First get the visit id for the desired patient */
SELECT
    visitid
FROM
    Visits
WHERE
    discharged_datetime IS NULL
    AND patientid = (
        SELECT patientid
        FROM Patients
        WHERE
            pname = :patientName
            AND phone_num = :patientPhone)

/* Next insert the appointment into the appointments table */
INSERT INTO Appointments
VALUES (:visitId, :aptTime)

/* Lastly, add the current employee to the appointment */
INSERT INTO AttendsAppointment
VALUES (:employeeId, :visitId, :aptTime)


/* QUERY #2 */
/* This deletes an employee from a specific ward */
DELETE FROM WorksAtWard
WHERE
    EmployeeId = :employeeid AND 
    WardId = :wardid


/* QUERY #3 */
/* This is used to update an employee's personal information */
UPDATE Employees
SET
    phone_num = :phone_num,
    address = :address,
    postal_code = :postal_code
WHERE
    employeeid = :id_value


/* QUERY #4 */


/* QUERY #5 */
/* This gets the name of the employees who have had an appointment with a patient with a provided name */
SELECT DISTINCT ename
FROM
    Employees E
    JOIN AttendsAppointment AA ON AA.EmployeeID = E.EmployeeId
    JOIN Visits V ON V.VisitId = AA.VisitId
    JOIN Patients P ON P.PatientId = V.PatientId
WHERE
    pname = :pname


/* QUERY #6 */
/* The main purpose of this query is to get the employee information for those that work at a specific ward */
SELECT
    ename,
    e.employeeid,
    ew.hname_short,
    ew.ward_name,
    CAST((bimonthly_wage) AS NUMERIC(36,2)),
    CAST((YearlyPay) AS NUMERIC(36,2)),
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
    JOIN (SELECT DISTINCT e.employeeid, h.hname_short, w.ward_name
         FROM Employees e, Wards w, Worksatward ww, Hospitals h
         WHERE e.employeeid=ww.employeeid AND w.wardid=ww.wardid AND w.hospitalid=h.hospitalid AND w.wardid=:wardid)
         AS EW ON EW.employeeid = E.employeeid
ORDER BY
    e.employeeid ASC


/* QUERY #7 */
/* The main purpose of this query is to get the yearly pay for each employee */
SELECT
    ename,
    e.employeeid,
    CAST((bimonthly_wage) AS NUMERIC(36,2)),
    ew.hname_short,
    CAST((YearlyPay) AS NUMERIC(36,2)),
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
    JOIN (SELECT DISTINCT e.employeeid, h.hospitalid, h.hname_short
         FROM Employees e, Wards w, Worksatward ww, Hospitals h
         WHERE e.employeeid=ww.employeeid AND w.wardid=ww.wardid AND w.hospitalid=h.hospitalid)
         AS EW ON EW.employeeid = E.employeeid
ORDER BY
    e.employeeid ASC


/* QUERY #8 */


/* QUERY #9 */


/* QUERY #10 */
/* This gets the number of appointments for each employee */
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