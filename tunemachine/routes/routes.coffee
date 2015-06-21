# @file routes.coffee
# @brief Initializes the routes of the app.
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

routes = {}

routes.init = (app, models, spotify, config, next) ->
  delete routes.init

  routes.home = require('./home')(app)

  # Authenication
  routes.auth = require('./auth')(app, models, spotify, config)

  # API
  routes.api = require('./api')(app, models, spotify)

  next()

module.exports = routes
