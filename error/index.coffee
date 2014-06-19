derby = require 'derby'

errorApp = module.exports = derby.createApp()

errorApp.serverUse module, 'derby-jade', coffee: true
errorApp.serverUse module, 'derby-stylus'

errorApp.loadViews __dirname + '/views'
errorApp.loadStyles __dirname + '/styles/reset'
errorApp.loadStyles __dirname + '/styles/index'