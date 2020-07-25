import express from "express"
import session from "express-session"

import userRoutes from "./routes/user"
import adminRoutes from "./routes/admin"
import apiRoutes from "./routes/api"

const app = express()

// Configure session
const sess = {
    secret: process.env.SESSION_SECRET,
    cookie: {}
}
app.use(session(sess))

// Routing
app.use('/user', userRoutes)
app.use('/admin', adminRoutes)
app.use('/api', apiRoutes)

export { app }