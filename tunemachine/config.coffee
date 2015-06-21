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
default_clientId = '80336a1812ac49b4a2e09be91d45bfeb'
default_oauthSecret = '2d91683130494b3ba4f6d420b87fe851'
default_db_url = 'mongodb://dev:devpassword@ds047682.mongolab.com:47682/tunemachine-dev'

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
config.auth.clientId = process.env.CLIENT_ID
config.auth.clientId ?= default_clientId
config.auth.secret = process.env.AUTH_SECRET
config.auth.secret ?= default_oauthSecret

module.exports = config
