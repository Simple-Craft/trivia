/*
    Because I'm kind (and somewhat stupid) I'm not enforcing any authentication on this API
    I'm pretty sure we're not gonna get big enough for that to be a problem
    If I end up regretting that I'll add an API key or something
*/
import express from "express"

const router = express.Router()
export default router