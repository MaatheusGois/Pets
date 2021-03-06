/* eslint-disable max-len */
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const Person = new Schema(
    {
      name: {type: String, required: true},
      image: {type: String, required: true},
      pets: [{type: mongoose.Schema.Types.ObjectId, ref: 'pet', autopopulate: true}],
    },
    {timestamps: true},
);

Person.methods.addPet = async function(pet, next) {
  try {
    const person = this;
    person.pets.push(pet.id);
    await person.save();
    next();
  } catch (error) {
    return next(error);
  }
};

Person.plugin(require('mongoose-autopopulate'));
module.exports = mongoose.model('person', Person);
