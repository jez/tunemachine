# @file home.coffee
# @brief Main routing for the app
# @author Jake Zimmerman <zimmerman.jake@gmail.com>
# @since 20 Jun 2015

module.exports = (app) ->

  # GET /login
  app.get '/', (req, res) ->
    res.render 'app',
      title: 'TuneMachine'
    res.end()
