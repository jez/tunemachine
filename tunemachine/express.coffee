# @file express.coffee
# @brief Initializes the express logic
# @author Oscar Bezi, oscar@bezi.io
# @since 20 Jun 2015
#===============================================================================

web = {}

express = require 'express'

morgan = require 'morgan'
bodyParser = require 'body-parser'
session = require 'express-session'
MongoStore = require 'connect-mongo'
MongoStore = MongoStore session

# initialise
web.init = (config, next) ->
  delete web.init
  web.express = express()

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

  web.express.use morgan 'dev'

  web.express.use bodyParser.urlencoded
    extended: true

  next()

module.exports = web
