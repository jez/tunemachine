# @file auth.coffee
# @brief Implements routing for the app's authenication procedures
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

module.exports = (app) ->

  # GET /login
  app.get '/login', (req, res) ->
    res.write 'Log in'
    res.end()
