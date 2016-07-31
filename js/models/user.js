module.exports = function(sequelize, DataTypes) {
  return sequelize.define('user', {
    name: {
      type: DataTypes.STRING,
      unique: true
    },
    password: {
      type: DataTypes.STRING
    }
  });
};
