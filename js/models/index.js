var Sequelize, config, db, env, fs, path, sequelize;

fs = require('fs');

path = require('path');

Sequelize = require('sequelize');

env = process.env.NODE_ENV || 'development';

config = require('../config')[env];

sequelize = new Sequelize(config.database, config.username, config.password, config);

db = {};

sequelize["import"]('./user');

sequelize["import"]('./client');

sequelize["import"]('./document');

sequelize.models.user.findOrCreate({
  where: {
    name: 'admin'
  },
  defaults: {
    password: 'admin'
  }
}).then(function(user, created) {});

db.sequelize = sequelize;

db.Sequelize = Sequelize;

module.exports = db;
