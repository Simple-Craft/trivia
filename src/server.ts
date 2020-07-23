import "dotenv/config"
import { app } from "./app"
import { sequelize } from "./sequelize"

sequelize.sync({ force: true }).then(_ => {
    const server = app.listen(process.env.PORT, () => {
        console.log("Server started on port %d", process.env.PORT)
    })
})