import { Sequelize } from "sequelize-typescript"
import models from "./models"

// Todo: Connect to actual database from .env
export const sequelize = new Sequelize({
    dialect: 'sqlite',
    database: 'development',
    storage: 'development.sqlite',
    models: models
})