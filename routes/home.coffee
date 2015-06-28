# @file home.coffee
# @brief Main routing for the app
# @author Jake Zimmerman <zimmerman.jake@gmail.com>
# @since 20 Jun 2015

module.exports = (app) ->

  # GET /login
  app.get '/', (req, res) ->
    if req.isLoggedIn()
      res.render 'app'
    else
      res.render 'login'
