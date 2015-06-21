# @file server.coffee
# @brief Glues together all of the logic from the rest of the system.
# @author Oscar Bezi, oscar@bezi.io
# @since 20 Jun 2015
#===============================================================================
console.log 'Initializing TuneMachine server instance.'

app = {}
app.config = require './config'
app.web = require './express'
app.routes = require './routes/routes'
app.models = require './models'

app.web.init app.config, () ->
  app.routes.init app.web.express, app.config, () ->
    app.models.init app.config, () ->
      app.web.express.listen app.config.port
      console.log "Server listening on port #{ app.config.port }"
