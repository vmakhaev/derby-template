coffeeify = require 'coffeeify'
express = require 'express'
session = require 'express-session'
serveStatic = require 'serve-static'
compression = require 'compression'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
RedisStore = require('connect-redis')(session)
derby = require 'derby'
racerBrowserChannel = require 'racer-browserchannel'
liveDbMongo = require 'livedb-mongo'
redis = require 'redis'
app = require '../app'
errorMiddleware = require '../error/middleware'

derby.use require 'racer-bundle'

redisClient = redis.createClient process.env.REDIS_PORT, process.env.REDIS_HOST
redisClient.auth process.env.REDIS_PASSWORD
redisClient.select process.env.REDIS_DATABASE

sessionStore = new RedisStore client: redisClient

store = derby.createStore
  db: liveDbMongo process.env.MONGO_URL + '?auto_reconnect', safe: true
  redis: redisClient

store.on 'bundle', (browserify) ->
  browserify.transform global: true, coffeeify

  pack = browserify.pack
  browserify.pack = (options) ->
    detectTransform = options.globalTransform.shift()
    options.globalTransform.push detectTransform
    pack.apply this, arguments

publicDir = __dirname + '/../public'

createUserId = (err, req, res, next) ->
  model = req.getModel()
  userId = req.session.userId
  if !userId
    userId = req.session.userId = model.id()
  model.set '_session.userId', userId
  next()

expressApp = module.exports = express()
  .use compression()
  .use serveStatic publicDir
  .use cookieParser process.env.SESSION_SECRET
  .use session
    secret: process.env.SESSION_SECRET
    store: sessionStore
  .use racerBrowserChannel store
  .use store.modelMiddleware()
  .use createUserId
  .use bodyParser()
  .use app.router()

expressApp.all '*', (req, res, next) ->
  next '403: ' + req.url

expressApp.use errorMiddleware

app.writeScripts store, publicDir, {extensions: ['.coffee']}, ->