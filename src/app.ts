import express from "express"
import session from "express-session"

import userRoutes from "./routes/user"
import adminRoutes from "./routes/admin"
import createRoutes from "./routes/create"
import listRoutes from "./routes/questions"

import apiRoutes from "./routes/api"

import SequelizeStore from "connect-session-sequelize"
import sequelize from "./sequelize"
import Question from "./models/Question.model"

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
/* Enable this again when HTTPS is setup
if (process.env.ENVIRONMENT === 'production') {
    sess.cookie.secure = true
}
*/

const app = express()
app.use(session(sess))

// Static files
app.use(express.static('resources'))

// Routing
app.use('/user', userRoutes)
app.use('/admin', adminRoutes)
app.use('/api', apiRoutes)
app.use('/create', createRoutes)
app.use('/questions', listRoutes)

export default app