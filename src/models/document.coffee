module.exports = (sequelize, DataTypes) ->
  sequelize.define 'document',
    name:
      type: DataTypes.STRING
      unique: true
    title: DataTypes.STRING
    description: DataTypes.TEXT
    # FIXME - make this an enum
    doctype: DataTypes.STRING
    content: DataTypes.TEXT
    
