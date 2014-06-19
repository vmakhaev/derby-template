errorApp = require './'

module.exports = (err, req, res, next) ->
  if !err
    return next()

  message = err.message or err.toString()
  status = parseInt message
  if status < 400 or status >= 600
    status = 500

  if status < 500
    console.log err.message or err
  else
    console.log err.stack or err

  page = errorApp.createPage req, res, next
  page.renderStatic status, status.toString()