module.exports = (sequelize, DataTypes) ->
  sequelize.define 'todo',
    name:
      type: DataTypes.STRING
    description:
      type: DataTypes.TEXT
    completed:
      type: DataTypes.BOOLEAN
