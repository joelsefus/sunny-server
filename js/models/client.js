module.exports = function(sequelize, DataTypes) {
  return sequelize.define('client', {
    name: {
      type: DataTypes.STRING,
      unique: true
    },
    fullname: {
      type: DataTypes.TEXT
    },
    description: {
      type: DataTypes.TEXT
    }
  });
};
