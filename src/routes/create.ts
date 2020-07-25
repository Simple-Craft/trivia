import express from "express"
import { requireLogin } from "../middleware"
import path from "path"

const router = express.Router()
router.use(requireLogin)

// Internal routing handled by Elm
router.get('/', (req, res) => {
    res.sendFile(path.resolve(__dirname, '../../resources/index.html'))
})

export default router