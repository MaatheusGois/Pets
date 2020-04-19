const express = require('express');
const {ApiPetCtrl} = require('../../../../controllers');
const router = new express.Router();

router.get('/api/pet/all', ApiPetCtrl.getAll);
router.get('/api/pet/allByUserID/:userID', ApiPetCtrl.getAllByUserID);
router.post('/api/pet/create', ApiPetCtrl.create);
router.post('/api/pet/update', ApiPetCtrl.update);
router.delete('/api/pet/delete', ApiPetCtrl.delete);
router.get('/api/pet/delete/:id', ApiPetCtrl.deleteByID);


module.exports = router;
