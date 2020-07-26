import express from "express"
import { requireAdmin } from "../middleware"
import path from "path"

import Question from "../models/Question.model"
import { ApprovalState, Difficulty } from "../models/Question.model"
import User from "../models/User.model"
import Category from "../models/Category.model"

const router = express.Router()
router.use(requireAdmin)

function mapQuestion(question: Question) {
    return {
        id: question.id,
        question: question.question,
        correctAnswer: question.correctAnswer,
        wrongAnswers: question.wrongAnswers,
        submitter: question.submitter.username,
        category: question.category.name,
        difficulty: Difficulty[question.difficulty],
        submissionTime: question.createdAt
    }
}

router.get('/queue/:page', async (req, res) => {
    let page = Number(req.params.page)
    let size = 50

    const questions = await Question.findAll({
        where: { approvalState: ApprovalState.Pending },
        limit: size,
        offset: size * page,
        include: [{ model: User, attributes: ['username'] }, { model: Category, attributes: ['name'] }],
        order: [['createdAt', 'DESC']]
    })

    let page_count = await Question.count({ where: { approvalState: ApprovalState.Pending } })
    page_count = Math.ceil(page_count / size)

    res.json({
        page_count: page_count,
        questions: questions.map(mapQuestion)
    })
})

// Internal routing handled by Elm
router.get('/', (req, res) => {
    res.sendFile(path.resolve(__dirname, '../../resources/index.html'))
})

export default router