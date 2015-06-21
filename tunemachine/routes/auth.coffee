# @file auth.coffee
# @brief Implements routing for the app's authenication procedures
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

querystring = require 'querystring'
request = require 'request'

module.exports = (app, spotify, config) ->

  # GET /auth/login/
  app.get '/auth/login', (req, res) ->
    res.redirect 'https://accounts.spotify.com/authorize?' +
      querystring.stringify
        response_type: 'code'
        client_id:     config.auth.clientId
        redirect_uri:  config.domain + 'auth/oauth2callback'
        scope:        'playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private'

  # GET /auth/oauth2callback
  app.get '/auth/oauth2callback', (req, res) ->
    if req.query.error? then res.end 'Error'
    else
      authOptions =
        url: 'https://accounts.spotify.com/api/token'
        form:
          code: req.query.code
          redirect_uri: config.domain + 'auth/oauth2callback'
          grant_type: 'authorization_code'
          client_id: config.auth.clientId
          client_secret: config.auth.secret
        json: true

      request.post authOptions, (error, _res, body) ->
        spotify.getMe body.access_token, (err, values) ->
          if err?
            return res.end 'Error'
          req.session.access_token = body.access_token
          res.redirect config.domain
