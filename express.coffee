# @file express.coffee
# @brief Initializes the express logic
# @author Oscar Bezi, oscar@bezi.io
# @since 20 Jun 2015
#===============================================================================

web = {}

express = require 'express'
path = require 'path'

morgan = require 'morgan'
bodyParser = require 'body-parser'
session = require 'express-session'
favicon = require 'serve-favicon'
MongoStore = require 'connect-mongo'
MongoStore = MongoStore session

# initialise
web.init = (config, next) ->
  delete web.init
  web.express = express()
  web.express.use express.static(path.join(__dirname, 'public'))

  # view engine setup
  web.express.set 'views', path.join(__dirname, 'views')
  web.express.set 'view engine', 'jade'

  # session initialisation
  mongoStore = new MongoStore
    url: config.db.url

  web.express.use session
    secret: config.auth.secret
    resave: true
    saveUninitialized: false
    cookie:
      secure: false
    store: mongoStore

  # Utility function for checking whether we're logged in
  web.express.use (req, res, next) ->
    req.isLoggedIn = ->
      this.session.access_token? and Date.now() < this.session.expiration
    next()

  # logging
  web.express.use morgan 'dev'

  web.express.use(favicon(__dirname + '/public/img/favicon.ico'))
  web.express.use bodyParser.json()
  web.express.use bodyParser.urlencoded
    extended: true

  next()

module.exports = web
