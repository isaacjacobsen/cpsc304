import { Router } from 'express'
var connection = require('../configs/sequelize')

const router = Router()

router.get('/employees', function (req, res, next) {
  const query = 'SELECT employeeid, ename, bimonthly_wage FROM Employees ;'
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