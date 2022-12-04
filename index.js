const Gpio = require('pigpio').Gpio;
const cors = require('cors')
const motor = new Gpio(13, {mode: Gpio.OUTPUT});
const express = require('express')
let pulseWidth = 2500;
let extended = false
let seconds
const db = require('block.db')

async function updateSeconds(){
seconds = await db.get('seconds')
if (seconds == null) {
db.set('seconds', 3)
seconds = 3
}
}

/*
setInterval(() => {
  motor.servoWrite(1000);
}, 1000);
*/

const app = express()
app.use(cors())
app.use(express.json())

app.get('/', async (req, res) => {
res.send('welcome to the reer api')
})

app.get('/extended', async (req,res) => {
res.json({ extended: extended })
})

app.get('/seconds', async (req,res) => {
updateSeconds()
res.json({ seconds: seconds })
})

app.post('/cut', async (req,res) => {
motor.servoWrite(0)
res.json({ success: true })
})

app.post('/setseconds/:seconds', async (req,res) => {
updateSeconds()
if (!req.params.seconds) return res.sendStatus(400)
await db.set('seconds', req.params.seconds)
seconds = req.params.seconds
await res.json({ seconds: seconds })
})

app.post('/extend', async (req,res) => {
updateSeconds()
motor.servoWrite(750)
setTimeout(function () {
motor.servoWrite(0)
extended = true
res.json({ extended: true, success: true })
}, seconds * 1000)
})

app.post('/retract', async (req,res) => {
updateSeconds()
motor.servoWrite(2250)
setTimeout(function () {
motor.servoWrite(0)
extended = false
res.json({ extended: false, success: true })
}, seconds * 1000)
})

app.listen(3000)

