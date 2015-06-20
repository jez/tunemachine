# @file config.coffee
# @brief Configuration for web application.
# @author Oscar Bezi, oscar@bezi.io
# @since 20 June 2015
#===============================================================================

# configuration object
config = {}

# the port to listen on
default_port = 8080

config.port = process.env.PORT
config.port ?= default_port

# database
default_db_url = 'mongodb://development:ThisIsAShittyPassword@ds047742.mongolab.com:47742/tunemachine'

config.db = {}
config.db.url = process.env.DB_URL
config.db.url ?= default_db_url

# auth magic

config.auth = {}
config.auth.secret ?= process.env.AUTH_SECRET
config.auth.secret = 'THISISASHITTYAUTHSECRET'
module.exports = config
