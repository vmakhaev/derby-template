require 'coffeeify'
http = require 'http'
derby = require 'derby'

try
  for key, value of require './config'
    process.env[key] = value

port = process.env.PORT

listenCallback = (err) ->
  console.log '%d listening. Go to: http://localhost:%d/', process.pid, port

createServer = ->
  expressApp = require './server/index'
  server = http.createServer expressApp
  server.listen port, listenCallback

derby.run createServer

process.on 'uncaughtException', (err) ->
  console.log 'Uncaught exception: ' + err.stack