const express = require('express')
const { UserCtrl } = require('../controllers')
const router = express.Router()

router.post('/user/auth', UserCtrl.authenticate)

module.exports = router