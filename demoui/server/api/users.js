import { Router } from 'express'
var connection = require('../configs/sequelize')
const bodyParser = require('body-parser')

const router = Router()

/*
  GET user using username/password.
  of form /users?username=username&password=password
*/
router.get('/users', function (req, res, next) {
  const username = req.query.username
  const password = req.query.password
  const query = 'SELECT * FROM Users WHERE username = :username AND password = :password '
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        username: username,
        password: password
      }
    })
    .then(user => {
      if (user.length === 1) {
        res.json(user[0])
      } else {
        res.status(404).json({})
      }
    })
})

/* GET user by ID. */
router.get('/users/:userid', function (req, res, next) {
  const userid = req.params.userid
  const query = `
                SELECT *
                FROM
                  UsersWithInfoView
                WHERE
                  userid = :userid`

  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        userid: userid
      }
    })
    .then(user => {
      if (user.length === 1) {
        res.json(user[0])
      } else {
        res.status(404).json({})
      }
    })
})

router.get('/appo/:getPname', function (req, res, next) {
  console.log('get pname!' + req.params.getPname)
  const pname = req.params.getPname
  const query = 'SELECT DISTINCT ename FROM Employees E JOIN AttendsAppointment AA ON AA.EmployeeID = E.EmployeeId JOIN Visits V ON V.VisitId = AA.VisitId JOIN Patients P ON P.PatientId = V.PatientId WHERE pname = \'' + req.params.getPname + '\''
  
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        pname: pname
      }
    })
    .then(app => {
      console.log(app)
      if (app.length > 0) {
        res.json(app)
      } else {
        res.status(404).json({})
      }
    })
})

router.get('/showall', function (req, res, next) {
  const query = 'SELECT ' +
  'E.EmployeeId, ' +
    'ename As EmployeeName, ' +
    'CASE ' +
  'WHEN D.doctor_type IS NOT NULL THEN \'Doctor\' ' +
  'WHEN N.nurse_type IS NOT NULL THEN \'Nurse\' ' +
  'ELSE \'Unknown\' ' +
  'END AS EmployeeType, ' +
  'COUNT(*) As AppointmentCount ' +
  'FROM ' +
  'Appointments A ' +
  'JOIN Visits V ON V.VisitId = A.VisitId ' +
  'JOIN AttendsAppointment AA ON AA.VisitId = A.VisitId AND AA.apt_datetime = A.apt_datetime ' +
  'JOIN Employees E ON E.EmployeeId = AA.EmployeeId ' +
  'LEFT JOIN Doctors D ON D.EmployeeId = E.EmployeeId ' +
  'LEFT JOIN Nurses N ON N.EmployeeId = E.EmployeeId ' +
  'GROUP BY ' +
  'E.EmployeeId, ' +
    'D.doctor_type, ' +
   'N.nurse_type ' +
  'ORDER BY ' +
  'COUNT(*) DESC, ' +
    'CASE ' +
  'WHEN D.doctor_type IS NOT NULL THEN 2 ' +
  'WHEN N.nurse_type IS NOT NULL THEN 1 ' +
  'ELSE 0 ' +
  'END DESC, ' +
    'ename'

  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
    })
    .then(app => {
      console.log(app)
      if (app.length > 0) {
        res.json(app)
      } else {
        res.status(404).json({})
      }
    })
})

router.get('/currmonthpatients', function (req, res, next) {
  const query = `SELECT DISTINCT pname, P.patientid, P.phone_num
FROM
    Visits V
    JOIN Patients P ON P.PatientId = V.PatientId
    JOIN Hospitals H ON H.HospitalId = V.HospitalId
WHERE
    (SELECT EXTRACT(YEAR FROM admitted_datetime)) = (SELECT EXTRACT(YEAR FROM current_timestamp))
    AND (SELECT EXTRACT(MONTH FROM admitted_datetime)) = (SELECT EXTRACT(MONTH FROM current_timestamp))
    AND H.hname_short = 'VGH'`
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
      }
    })
    .then(patients => {
      if (patients.length >= 1) {
        res.json(patients)
      } else {
        res.status(404).json({err: 'no patients'})
      }
    })
})

router.get('/inpatients', function (req, res, next) {
  const query = `SELECT DISTINCT
	V.admitted_datetime,
    pname As PatientName,
    P.patientid,
    P.phone_num
FROM
    Visits V
    JOIN Hospitals H ON H.hospitalid = V.hospitalid
    JOIN Patients P ON P.PatientId = V.PatientId
WHERE
    V.discharged_datetime IS NULL
ORDER BY
	V.admitted_datetime`
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
      }
    })
    .then(patients => {
      if (patients.length >= 1) {
        res.json(patients)
      } else {
        res.status(404).json({err: 'no patients'})
      }
    })
})

router.get('/addAppo', function (req, res, next) {
  const query = '' // deleted
  connection.query(query,
    {
      type: connection.QueryTypes.SELECT,
      // deleted
    })
    .then(app => {
      console.log(app)
      if (app.length > 0) {
        res.json(app)
      } else {
        res.status(404).json({})
      }
    })
})



router.post('/users/:userid/update', bodyParser.json(), function (req, res, next) {
  const userid = req.params.userid;
  const username = req.body.data.username;
  const password = req.body.data.password;
  const name = req.body.data.name;
  const phone_num = req.body.data.phoneNum;
  const address = req.body.data.address;
  const postCode = req.body.data.postCode;
  var employeeid = "";
  var patientid = "";

  const query_1 = "SELECT employeeid, patientid FROM Users WHERE userid = :userid ;";
  connection.query(query_1,
    {
      type: connection.QueryTypes.SELECT,
      replacements: {
        userid: userid
      }
    })
    .then(result => {
      employeeid = result[0].employeeid;
      patientid = result[0].patientid;
      const query_2 = "UPDATE _tab_1 SET phone_num = :phone_num, address = :address, postal_code = :postal_code" +
        " WHERE _id = :id_value ;"
      if (employeeid !== null){
        connection.query(query_2.replace("_tab_1", "Employees").replace("_id", "employeeid"),
          {
            type: connection.QueryTypes.UPDATE,
            replacements: {
              id_value: employeeid,
              phone_num: phone_num,
              address: address,
              postal_code: postCode
            }
          }
        ).then(result => {
          console.log("sucessfully updated phonenum");
        })
      } else if (patientid !== null){
        connection.query(query_2.replace("_tab_1", "Patients").replace("_id", "patientid"),
          {
            type: connection.QueryTypes.UPDATE,
            replacements: {
              id_value: patientid,
              phone_num: phone_num,
              address: address,
              postal_code: postCode
            }
          }
        ).then(result => {
          console.log("sucessfully updated phonenum");
        })
      }
    });
  const query = 'UPDATE Users SET username = :username, password = :password, name = :name' +
    ' WHERE userid = :userid ;'
  connection.query(query,
    {
      type: connection.QueryTypes.UPDATE,
      replacements: {
        name: name,
        username: username,
        password: password,
        userid: userid
      }
    })
    .then(result => {
      res.send('/users/' + userid)
    });
});

router.post('/users/add', bodyParser.json(), function (req, res, next) {
  const username = req.body.data.username
  const password = req.body.data.password
  const typeid = req.body.data.typeid
  const userid = req.params.userid;

  const query = 'INSERT INTO Users (username, password, typeid) VALUES (:username, :password, :typeid) ;'
  connection.query(query,
    {
      type: connection.QueryTypes.INSERT,
      replacements: {
        username: username,
        password: password,
        typeid: typeid
      }
    })
    .then(result => {
      // result[1] is the number of rows changed
      res.send('/users/' + userid)
    })

})

export default router
