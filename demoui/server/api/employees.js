import { Router } from 'express'
var connection = require('../configs/sequelize')

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


export default router