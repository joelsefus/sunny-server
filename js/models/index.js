var Sequelize, config, db, env, fs, path, sequelize;

fs = require('fs');

path = require('path');

Sequelize = require('sequelize');

env = process.env.NODE_ENV || 'development';

config = require('../config')[env];

sequelize = new Sequelize(config.database, config.username, config.password, config);

db = {};

db.sequelize = sequelize;

db.Sequelize = Sequelize;

module.exports = db;
