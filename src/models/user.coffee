bcrypt = require 'bcryptjs'

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user',
    name:
      type: DataTypes.STRING
      unique: true
    password:
      type: DataTypes.STRING
      set: (value) ->
        salt_rounds = 10
        @setDataValue 'password', bcrypt.hashSync(value, salt_rounds)
    config:
      # FIXME
      # this should be json on postgresql
      # should use config to determine if get/set and text are needed
      type: DataTypes.TEXT
      get: ->
        JSON.parse @getDataValue 'config'
      set: (value) ->
        @setDataValue 'config', JSON.stringify(value)

    set_password: (password) ->
      
