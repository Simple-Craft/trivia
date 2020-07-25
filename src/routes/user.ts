import express from "express"
import fetch from "node-fetch"
import User from "../models/User.model"

const router = express.Router()

const CLIENT_ID = process.env.DISCORD_CLIENT_ID
const CLIENT_SECRET = process.env.DISCORD_CLIENT_SECRET
const PORT = process.env.PORT
const redirect = `http://localhost:${PORT}/user/callback`

function getDiscordUserData(token: string) {
    return new Promise((resolve, reject) => {
        fetch(`https://discord.com/api/users/@me`, {
            method: 'GET',
            headers: {
                Authorization: `Bearer ${token}`
            }
        })
            .then(res => res.json())
            .then(json => resolve(json))
            .catch(e => reject(e))
    })
}

router.get('/login', (req, res) => {
    let redirect_encoded = encodeURIComponent(redirect)
    res.redirect(`https://discord.com/api/oauth2/authorize?client_id=${CLIENT_ID}&scope=identify&response_type=code&redirect_uri=${redirect_encoded}`)
})

router.get('/logout', (req, res) => {
    req.session.destroy(err => console.error)
})

router.get('/callback', (req, res) => {
    if (!req.query.code) throw new Error()
    const code = req.query.code
    const auth = Buffer.from(`${CLIENT_ID}:${CLIENT_SECRET}`).toString('base64')

    let data = new URLSearchParams()
    data.append('client_id', CLIENT_ID)
    data.append('client_secret', CLIENT_SECRET)
    data.append('code', code as string)
    data.append('grant_type', 'authorization_code')
    data.append('scope', 'identify')
    data.append('redirect_uri', redirect)

    fetch(`https://discordapp.com/api/oauth2/token`, {
        body: data,
        method: 'POST'
    })
        .then(res => res.json())
        .then(json => {
            let token = json.access_token
            console.log(json, token)
            getDiscordUserData(token).then((data: any) => {
                let username = data.username + '#' + data.discriminator
                User.findOrCreate({
                    where: { discordId: data.id },
                    defaults: { username: username }
                }).then(([user, created]) => {
                    user.lastLogin = new Date()
                    user.save()

                    req.session.user = user
                    res.redirect('/user/me')
                })
            })
        })
})

router.get('/me', (req, res) => {
    if (req.session.user) {
        res.setHeader('Content-Type', 'text/html')
        res.write('<p>Username: ' + req.session.user.username + '</p>')
        res.write('<p>ID: ' + req.session.user.discordId + '</p>')
        res.write('<p>Admin: ' + req.session.user.admin + '</p>')
        res.end()
    } else {
        res.end('Not logged in.')
    }
})

export default router