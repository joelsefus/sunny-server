fs = require 'fs'
path = require 'path'
Sequelize = require 'sequelize'
env = process.env.NODE_ENV or 'development'
config = require('../config')[env]

sequelize = new Sequelize(config.database, config.username, config.password, config)
db = {}

# import models
sequelize.import './user'
sequelize.import './document'
sequelize.import './client'
sequelize.import './yard'

#fs.readdirSync(__dirname).filter((file) ->
#  file.indexOf('.') != 0 and file != 'index.js'
#).forEach (file) ->
#  model = sequelize.import(path.join(__dirname, file))
#  db[model.name] = model
#  return
#Object.keys(db).forEach (modelName) ->
#  if 'associate' of db[modelName]
#    db[modelName].associate db
#  return

# FIXME get this from config
sequelize.models.user.findOrCreate
  where:
    name: 'admin'
  defaults:
    password: 'admin'
    config:
      theme: 'BlanchedAlmond'
      foo: 'bar'
      cat: 'dog'
      
.then (user, created) ->
  return
  

db.sequelize = sequelize
db.Sequelize = Sequelize
module.exports = db
