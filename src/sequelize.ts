import { Sequelize } from "sequelize-typescript"
import models from "./models"

// Todo: Connect to actual database from .env
export default new Sequelize({
    dialect: 'mysql',
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    username: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    models: models
})