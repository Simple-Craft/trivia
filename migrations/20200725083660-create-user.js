'use strict';
module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable('Users', {
      discordId: {
        primaryKey: true,
        allowNull: false,
        type: Sequelize.STRING(64)
      },
      username: {
        type: Sequelize.STRING
      },
      admin: {
        type: Sequelize.BOOLEAN
      },
      firstLogin: {
        allowNull: false,
        type: Sequelize.DATE
      },
      lastLogin: {
        allowNull: false,
        type: Sequelize.DATE
      },
    });
  },
  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable('Users');
  }
};