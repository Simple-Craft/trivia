import { Sequelize } from "sequelize-typescript"
import path from "path"

// Todo: Connect to actual database from .env
export const sequelize = new Sequelize({
    dialect: 'sqlite',
    database: 'development',
    storage: 'development.sqlite',
    modelPaths: [path.join(__dirname, 'models')]
})