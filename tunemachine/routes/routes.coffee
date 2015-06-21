# @file routes.coffee
# @brief Initializes the routes of the app.
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

routes = {}

routes.init = (app, spotify, config, next) ->
  delete routes.init

  routes.home = require('./home')(app)

  # Authenication
  routes.auth = require('./auth')(app, spotify, config)

  next()

module.exports = routes
