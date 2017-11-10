import { Router } from 'express'
var connection = require('../configs/sequelize')
const bodyParser = require('body-parser')

const router = Router()

/*
  GET user using username/password.
  of form /users?username=username&password=password
*/
router.get('/users', function (req, res, next) {
  console.log("IN USERS")
  const username = req.query.username
  const password = req.query.password
  const query = 'SELECT * FROM Users WHERE username = :username AND password = :password ;'
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
  const query = 'SELECT * FROM Users WHERE userid = :userid ;'
  connection.query(query, 
    { 
      type: connection.QueryTypes.SELECT,
      replacements: {
        typeid: typeid,
        userid: userid
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
