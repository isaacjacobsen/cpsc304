import { Router } from 'express'
var connection = require('../configs/sequelize')
const bodyParser = require('body-parser')

const router = Router()

// * Get Query #7

router.get('/employees', function (req, res, next) {
  const query = `SELECT
    ename, e.employeeid, CAST((bimonthly_wage) AS NUMERIC(36,2)), ew.hname_short,
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
    e.employeeid ASC`
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
      }
    })
    .then(employees => {
      if (employees.length >= 1) {
        res.json(employees)
      } else {
        res.status(404).json({err: 'no employees'})
      }
    })
})

router.get('/employees/hos/:hospitalcode', function (req, res, next) {
  const hospitalcode = req.params.hospitalcode
  const query = `SELECT
    ename, e.employeeid, CAST((bimonthly_wage) AS NUMERIC(36,2)), ew.hname_short,
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
         WHERE e.employeeid=ww.employeeid AND w.wardid=ww.wardid AND w.hospitalid=h.hospitalid AND h.hname_short=:hospitalcode)
         AS EW ON EW.employeeid = E.employeeid
ORDER BY
    e.employeeid ASC`
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        hospitalcode: hospitalcode
      }
    }).then(employees => {
      if (employees.length >= 1 ) {
        res.json(employees)
      } else {
        res.status(404).json({err: 'no employees'})
      }
  })
})

router.get('/employees/ward/:wardid', function (req, res, next) {
  const wardid = req.params.wardid
  const query = `SELECT
    ename, e.employeeid, ew.hname_short, ew.ward_name,
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
    e.employeeid ASC`
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        wardid: wardid
      }
    }).then(employees => {
    if (employees.length >= 1 ) {
      res.json(employees)
    } else {
      res.status(404).json({err: 'no employees'})
    }
  })
})

router.post('/employees/:employeeid/appointments', bodyParser.json(), function (req, res, next) {
  const employeeId = req.params.employeeid
  const patientName = req.body.data.pnameApt
  const patientPhone = req.body.data.pphone
  const aptTime = req.body.data.aptTime

  const getVisitIdQuery = `
    SELECT
      visitid
    FROM
        Visits
    WHERE
        discharged_datetime IS NULL
        AND patientid = (SELECT patientid
                FROM Patients
                WHERE
                    pname = :patientName
                    AND phone_num = :patientPhone)`
  const insertIntoAppointments = `
    INSERT INTO Appointments
    VALUES (:visitId, :aptTime)`
  const insertIntoAttendsAppointment = `
    INSERT INTO AttendsAppointment
    VALUES (:employeeId, :visitId, :aptTime)`

  connection.query(getVisitIdQuery,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        patientName: patientName,
        patientPhone: patientPhone
      }
    })
    .then(user => {
      if (user.length === 1) {
        var visitId = user[0].visitid

        connection.query(insertIntoAppointments,
          {
            type: connection.QueryTypes.INSERT,
            replacements: {
              visitId: visitId,
              aptTime: aptTime
            }
          })
          .then(x => {
            connection.query(insertIntoAttendsAppointment,
              {
                type: connection.QueryTypes.INSERT,
                replacements: {
                  employeeId: employeeId,
                  visitId: visitId,
                  aptTime: aptTime
                }
              })
              .then(
                res.status(200).send()
              )
          })
      } else {
        res.status(404).json({})
      }
    })
})

router.get('/employees/emp_payroll/:employeeid', function (req, res, next) {
  const employeeid = req.params.employeeid
  const query = 'SELECT \n' +
    '\tename,\n' +
    '    e.employeeid,\n' +
    '    CAST((bimonthly_wage) AS NUMERIC(36,2)),\n' +
    '    CAST((YearlyPay) AS NUMERIC(36,2)),\n' +
    '    CASE\n' +
    '        WHEN D.doctor_type IS NOT NULL THEN \'Doctor\'\n' +
    '        WHEN N.nurse_type IS NOT NULL THEN \'Nurse\'\n' +
    '        ELSE \'Unknown\'\n' +
    '    END AS EmployeeType\n' +
    'FROM\n' +
    '    (SELECT\n' +
    '        EmployeeId,\n' +
    '        SUM(pay_amt) As YearlyPay\n' +
    '    FROM\n' +
    '        Payroll\n' +
    '    WHERE\n' +
    '        (SELECT EXTRACT(YEAR FROM pay_date)) = \'2017\'\n' +
    '    GROUP BY\n' +
    '        EmployeeId) YP\n' +
    '    JOIN Employees E ON E.EmployeeId = YP.EmployeeId\n' +
    '    LEFT JOIN Doctors D On D.EmployeeId = E.EmployeeId\n' +
    '    LEFT JOIN Nurses N On N.EmployeeId = E.EmployeeId\n' +
    'WHERE e.employeeid = :employeeid\n'
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        employeeid: employeeid
      }
    })
  .then(user => {
    if (user.length === 1 ) {
      res.json(user[0])
    } else {
      res.status(404).json({})
    }
  })
})

router.get('/employees/:employeeid/emp_wards', function (req, res, next) {
  const employeeid = req.params.employeeid
  const query = `﻿SELECT w.ward_name, w.wardid, h.hname_short 
FROM Wards w, Employees e, Worksatward ww, Hospitals h
WHERE w.wardid=ww.wardid AND e.employeeid=ww.employeeid AND h.hospitalid=w.hospitalid
AND e.employeeid=:employeeid ;`
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        employeeid: employeeid
      }
    })
  .then(wards => {
    if (wards.length >= 1) {
      res.json(wards)
    } else {
      res.status(404).json({})
    }
  })
})

router.post('/employees/emp_payroll/:employeeid/update', bodyParser.json(), function (req, res, next) {
  const employeeid = req.params.employeeid
  const bimonthly_wage = req.body.data.bimonthly_wage
  const userid = req.body.data.userid

  const query = 'UPDATE Employees SET bimonthly_wage = :bimonthly_wage' +
    ' WHERE employeeid = :employeeid ;'
  connection.query(query,
    {
      type: connection.QueryTypes.UPDATE,
      replacements: {
        employeeid: employeeid,
        bimonthly_wage: bimonthly_wage
      }
    })
  .then(result => {
    console.log(userid)
    res.send('/users/' + userid + '/view_employees')
  });
});

router.post('/employees/:employeeid/del_ward/:wardid', function (req, res, next) {
  const employeeid = req.params.employeeid
  const wardid = req.params.wardid

  const query = `DELETE FROM WorksAtWard
                 WHERE
                    EmployeeId = :employeeid AND 
                    WardId = :wardid ;`
  connection.query(query,
    {
      type: connection.QueryTypes.DELETE,
      replacements: {
        employeeid: employeeid,
        wardid: wardid
      }
    }).then(result => {
      res.json({employeeid: employeeid})
  })
})

export default router