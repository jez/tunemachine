# @file routes.coffee
# @brief Initializes the routes of the app.
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

routes = {}

routes.init = (app, next) ->
  delete routes.init

  # Authenication
  routes.auth = require('./auth')(app)

  next()

module.exports = routes
