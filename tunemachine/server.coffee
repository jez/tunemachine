# @file server.coffee
# @brief Glues together all of the logic from the rest of the system.
# @author Oscar Bezi, oscar@bezi.io
# @since 20 Jun 2015
#===============================================================================
console.log 'Initializing TuneMachine server instance.'

app = {}
app.config = require './config'

console.log "Server successfully initialized and listening on port #{ app.config.port }"
