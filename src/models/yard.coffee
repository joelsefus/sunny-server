module.exports = (sequelize, DataTypes) ->
  sequelize.define 'yard',
    client_id:
      type: DataTypes.INTEGER
      references:
        model: 'client'
        key: 'id'
    name:
      type: DataTypes.STRING
      unique: true
    description:
      type: DataTypes.TEXT
    jobdetails:
      type: DataTypes.TEXT
