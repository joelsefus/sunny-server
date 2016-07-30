module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user',
    name:
      type: DataTypes.STRING
      unique: true
