import express from "express"
import session from "express-session"

import discordRoutes from "./api/discord"

const app = express()

// Configure session
const sess = {
    secret: process.env.SESSION_SECRET,
    cookie: {}
}
app.use(session(sess))

// API
app.use('/api/discord', discordRoutes)

export { app }