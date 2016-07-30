module.exports = (sequelize, DataTypes) ->
  sequelize.define 'client',
    name:
      type: DataTypes.STRING
      unique: true
    fullname:
      type: DataTypes.TEXT
    description:
      type: DataTypes.TEXT
