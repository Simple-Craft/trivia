import "dotenv/config"
import { app } from "./app"
import { sequelize } from "./sequelize"

async function main() {
    await sequelize.sync({ force: true })

    const server = app.listen(process.env.PORT, () => {
        console.log("Server started on port %d", process.env.PORT)
    })
}
main()