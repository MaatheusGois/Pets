const express = require('express');
const {ApiErrorCtrl} = require('../../../../controllers');
const router = new express.Router();

router.get('/error/all', ApiErrorCtrl.getAll);

module.exports = router;
