# @file config.coffee
# @brief Configuration for web application.
# @author Oscar Bezi, oscar@bezi.io
# @since 20 June 2015
#===============================================================================

# configuration object
config = {}

# default values
default_port = 5000
default_domain = 'http://localhost:5000/'
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

# verify config a bit
unless config.auth.clientId?
  console.warn "Looks like you don't have a Spotify client ID."
  console.warn 'Check the README for how to get one.'
unless config.auth.secret?
  console.warn "Looks like you don't have a Spotify client secret."
  console.warn 'Check the README for how to get one.'
if process.env.NODE_ENV == 'production' and not process.env.DB_URL
  console.warn "You're in production but you're using the default localhost DB."
  console.warn "You might want to make sure you've configured this correctly."
  console.warn 'Check the README if you need to.'

module.exports = config
