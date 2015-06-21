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
default_db_url = 'mongodb://dev:devpassword@ds047682.mongolab.com:47682/tunemachine-dev'

config.db = {}
config.db.url = process.env.DB_URL
config.db.url ?= default_db_url

# auth magic

config.auth = {}
config.auth.clientId = process.env.CLIENT_ID
config.auth.clientId ?= '80336a1812ac49b4a2e09be91d45bfeb'
config.auth.secret = process.env.AUTH_SECRET
config.auth.secret ?= '2d91683130494b3ba4f6d420b87fe851'
module.exports = config
