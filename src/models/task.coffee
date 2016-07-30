'use strict'

module.exports = (sequelize, DataTypes) ->
  Task = sequelize.define('Task', { title: DataTypes.STRING }, classMethods: associate: (models) ->
    Task.belongsTo models.User,
      onDelete: 'CASCADE'
      foreignKey: allowNull: false
    return
  )
  Task
