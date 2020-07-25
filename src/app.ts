import express from "express"
import session from "express-session"

import userRoutes from "./routes/user"
import adminRoutes from "./routes/admin"
import apiRoutes from "./routes/api"

import SequelizeStore from "connect-session-sequelize"
import sequelize from "./sequelize"

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

interface ResponseError extends Error {
    status?: number;
}

// Middleware that can be used for authentication in other routes
function requireLogin(req: express.Request, res: express.Response, next: express.NextFunction) {
    if (!req.session.user) {
        let err = new Error('Unauthorized') as ResponseError
        err.status = 401
        throw err
    }
    next()
}

function requireAdmin(req: express.Request, res: express.Response, next: express.NextFunction) {
    if (!req.session.user) {
        let err = new Error() as ResponseError
        err.status = 404
        throw err
    }

    if (!req.session.user.admin) {
        let err = new Error() as ResponseError
        err.status = 404
        throw err
    }
    next()
}

const app = express()
app.use(session(sess))

// Routing
app.use('/user', userRoutes)
app.use('/admin', adminRoutes)
app.use('/api', apiRoutes)

export { app, requireLogin, requireAdmin }