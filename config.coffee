# @file config.coffee
# @brief Configuration for web application.
# @author Oscar Bezi, oscar@bezi.io
# @since 20 June 2015
#===============================================================================

# configuration object
config = {}

# default values
default_port = 8080
default_domain = 'http://localhost:8080/'
default_db_url = 'mongodb://localhost:27017'

# routing
config.port = process.env.PORT
config.port ?= default_port
config.domain = process.env.DOMAIN
config.domain ?= default_domain

# database
config.db = {}
config.db.url = process.env.DB_URL
config.db.url ?= default_db_url

# auth magic
config.auth = {}
config.auth.clientId = process.env.SPOTIFY_CLIENT_ID
config.auth.secret = process.env.SPOTIFY_CLIENT_SECRET

module.exports = config
