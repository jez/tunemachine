# @file routes.coffee
# @brief Initializes the routes of the app.
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

routes = {}

routes.init = (app, config, next) ->
  delete routes.init

  routes.home = require('./home')(app)

  # Authentication
  routes.auth = require('./auth')(app, config)

  # API
  routes.api = require('./api')(app)

  next()

module.exports = routes
