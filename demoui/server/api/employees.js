import { Router } from 'express'
var connection = require('../configs/sequelize')
const bodyParser = require('body-parser')

const router = Router()

// * Get Query #7

router.get('/employees', function (req, res, next) {
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
    'ORDER BY\n' +
    '    e.employeeid ASC ;'
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
      }
    })
    .then(employees => {
      if (employees.length >= 1 ) {
        res.json(employees)
      } else {
        res.status(404).json({err: 'no employees'})
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
    res.send('/users/' + userid + '/view_employees')
  });
});

export default router