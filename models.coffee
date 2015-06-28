# @file models.coffee
# @brief Initialisation code for the database models.
# @since 20 June 2015
# @author Oscar Bezi, oscar@bezi.io
#===============================================================================

mongoose = require 'mongoose'
Schema = mongoose.Schema
models = {}

models.init = (config, next) ->
  mongoose.connect config.db.url, (err) ->
    if err?
      return console.log "Unable to connect to database at #{ config.db.url  }"

    console.log "Successfully connected to database at #{ config.db.url }."
    # mongoose.connection.db.dropDatabase()

#===============================================================================
# Snapshots
#===============================================================================
    SnapshotSchema = new Schema
      Name:
        type: String
        required: true

      Playlist:
        type: String
        required: true

      Timestamp:
        type: Date

      Tracks:
        type: Array
        default: []

    SnapshotSchema.pre 'save', (next) ->
      unless this.Timestamp?
        this.Timestamp = new Date()
      next()

    Snapshot = mongoose.model 'Snapshot', SnapshotSchema

#===============================================================================
# Users
#===============================================================================
    UserSchema = new Schema
      UserID:
        type: String
        required: true
        index:
          unique: true

    User = mongoose.model 'User', UserSchema

    models.Snapshot = Snapshot
    models.User = User

    # @function err
    # @brief Wrapper for database error handlers
    models.err = (res, err) ->
      res.status 500
      console.log "Database error: #{ err }"
      res.end "Database error: #{ err }"

    delete models.init

    next()

module.exports = models
