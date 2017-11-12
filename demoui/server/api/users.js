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
      if (user.length === 1 ) {
        res.json(user[0])
      } else {
        res.status(404).json({})
      }
    })
})

/* GET user by ID. */
router.get('/users/:userid', function (req, res, next) {
  const userid = req.params.userid
  const query =`﻿SELECT
                  userid,
                  username,
                  password,
                  name,
                  usertypeid,
                  usertypename,
                  CASE
                    WHEN D.employeeid IS NOT NULL THEN D.employeeid
                      WHEN N.employeeid IS NOT NULL THEN N.employeeid
                      WHEN P.patientid IS NOT NULL THEN P.patientid
                      ELSE NULL
                  END AS id,
                  doctor_type,
                  md_license_num,
                  nurse_type,
                  pname,
                  E.phone_num AS e_phone,
                  P.phone_num AS p_phone,
                  E.address AS e_add,
                  P.address AS p_add,
                  E.postal_code AS e_post,
                  P.postal_code AS p_post
                FROM
                  Users U
                    JOIN UserTypes UT ON UT.usertypeid = U.typeid
                    LEFT JOIN Employees E ON E.employeeid = U.employeeid
                    LEFT JOIN Doctors D ON D.employeeid = U.employeeid
                    LEFT JOIN Nurses N ON N.employeeid = U.employeeid
                    LEFT JOIN Patients P ON P.patientid = U.patientid
                WHERE
                  U.userid = :userid`

  connection.query(query, 
    { 
      type: connection.QueryTypes.SELECT,
      replacements: {
        userid: userid,
      }
    })
    .then(user => {
      if (user.length === 1 ) {
        console.log(user[0]);
        res.json(user[0])
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
      console.log(employeeid);
      console.log(patientid);
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
  const userid = req.body.data.userid
  const username = req.body.data.username
  const password = req.body.data.password

  const query = 'INSERT INTO Users (username, password, type) VALUES (:username, :password) ;'
  connection.query(query,
    {
      type: connection.QueryTypes.INSERT,
      replacements: {
        username: username,
        password: password
      }
    })
    .then(result => {
      // result[1] is the number of rows changed
      res.send('/users')
    })

})

export default router
