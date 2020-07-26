import express from "express"
import { requireLogin } from "../middleware"
import path from "path"
import Question from "../models/Question.model"

const router = express.Router()
router.use(requireLogin)
router.use(express.json())

// Internal routing handled by Elm
router.get('/', (req, res) => {
    res.sendFile(path.resolve(__dirname, '../../resources/index.html'))
})

router.post('/create', async (req, res) => {
    const q = new Question({
        question: req.body.question,
        correctAnswer: req.body.correct,
        wrongAnswers: req.body.wrong,
        categoryId: req.body.category,
        submitter: req.session.user
    })

    await q.save()
    res.sendStatus(200)
})


export default router