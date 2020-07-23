import express from "express"
import fetch from "node-fetch"

const router = express.Router()

const CLIENT_ID = process.env.DISCORD_CLIENT_ID
const CLIENT_SECRET = process.env.DISCORD_CLIENT_SECRET
const PORT = process.env.PORT
const redirect = `http://localhost:${PORT}/api/discord/callback`

function tokenUrl(code) {
    return `https://discord.com/api/oauth2/token?grant_type=authorization_code&code=${code}&redirect_uri=${redirect}`
}

function userDataUrl() {
    return
}

function getUserData(token) {
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

    console.log(redirect)

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
            getUserData(token).then((user: any) => {
                req.session.loggedIn = true
                req.session.discordUsername = user.username + '#' + user.discriminator
                req.session.discordId = user.id
                res.redirect('/api/discord/test')
            })
        })
})

router.get('/test', (req, res) => {
    if (req.session.loggedIn) {
        res.setHeader('Content-Type', 'text/html')
        res.write('<p>Username: ' + req.session.discordUsername + '</p>')
        res.write('<p>ID: ' + req.session.discordId + '</p>')
        res.end()
    } else {
        res.end('Not logged in.')
    }
})

export default router