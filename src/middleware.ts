import express from "express"

interface ResponseError extends Error {
    status?: number;
}

// Middleware that can be used for authentication in other routes
export function requireLogin(req: express.Request, res: express.Response, next: express.NextFunction) {
    if (!req.session.user) {
        let err = new Error('Unauthorized') as ResponseError
        err.status = 401
        throw err
    }
    next()
}

export function requireAdmin(req: express.Request, res: express.Response, next) {
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