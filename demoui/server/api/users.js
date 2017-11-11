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
  const typeid = req.query.typeid
  const usertypename = req.query.usertypename
  const query = 'SELECT * FROM Users, UserTypes WHERE users.userid = :userid AND users.typeid=usertypes.usertypeid'
  connection.query(query, 
    { 
      type: connection.QueryTypes.SELECT,
      replacements: {
        typeid: typeid,
        userid: userid,
        usertypename: usertypename
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

router.post('/users/:userid/update', bodyParser.json(), function (req, res, next) {
  const userid = req.params.userid
  const username = req.body.data.username
  const password = req.body.data.password 

  const query = 'UPDATE Users SET username = :username, password = :password WHERE userid = :userid ;'
  connection.query(query,
    {
      type: connection.QueryTypes.UPDATE,
      replacements: {
        username: username,
        password: password,
        userid: userid
      }
    })
    .then(result => {
      res.send('/users/' + userid)
    })
})

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
