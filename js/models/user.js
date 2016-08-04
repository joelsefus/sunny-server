var bcrypt;

bcrypt = require('bcrypt');

module.exports = function(sequelize, DataTypes) {
  return sequelize.define('user', {
    name: {
      type: DataTypes.STRING,
      unique: true
    },
    password: {
      type: DataTypes.STRING,
      set: function(value) {
        var salt_rounds;
        salt_rounds = 10;
        return this.setDataValue('password', bcrypt.hashSync(value, salt_rounds));
      }
    },
    config: {
      type: DataTypes.TEXT,
      get: function() {
        return JSON.parse(this.getDataValue('config'));
      },
      set: function(value) {
        return this.setDataValue('config', JSON.stringify(value));
      }
    },
    set_password: function(password) {}
  });
};
