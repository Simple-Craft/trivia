import express from "express"
import session from "express-session"

import userRoutes from "./routes/user"
import adminRoutes from "./routes/admin"
import apiRoutes from "./routes/api"

import SequelizeStore from "connect-session-sequelize"
import sequelize from "./sequelize"

const app = express()

// Configure session
let SequelizeSessionStore = SequelizeStore(session.Store)
let seq_store = new SequelizeSessionStore({ db: sequelize })
seq_store.sync()

let sess = {
    secret: process.env.SESSION_SECRET,
    cookie: { secure: false },
    store: seq_store,
    resave: false,
    saveUninitialized: false
}
if (process.env.ENVIRONMENT === 'production') {
    sess.cookie.secure = true
}
app.use(session(sess))

// Routing
app.use('/user', userRoutes)
app.use('/admin', adminRoutes)
app.use('/api', apiRoutes)

export { app }