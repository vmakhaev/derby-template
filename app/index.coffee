derby = require 'derby'

app = module.exports = derby.createApp 'app', __filename

if not derby.util.isProduction
  global.app = app

app.serverUse module, 'derby-jade', coffee: true
app.serverUse module, 'derby-stylus'

app.loadViews __dirname + '/../views/app'
app.loadStyles __dirname + '/../styles'

app.get '/', (page) ->
  page.render 'home'