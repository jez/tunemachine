# @file auth.coffee
# @brief Implements routing for the app's authenication procedures
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

querystring = require 'querystring'
request = require 'request'

module.exports = (app, config) ->

  # GET /login
  app.get '/login', (req, res) ->
    res.redirect 'https://accounts.spotify.com/authorize?' +
      querystring.stringify
        response_type: 'code'
        client_id:     config.auth.clientId
        redirect_uri:  'http://localhost:8080/finishlogin'

  # GET /finishlogin
  app.get '/finishlogin', (req, res) ->
    if req.query.error? then res.end 'Error'
    else
      authOptions =
        url: 'https://accounts.spotify.com/api/token'
        form:
          code: req.query.code
          redirect_uri: 'http://localhost:8080/finishlogin'
          grant_type: 'authorization_code'
          client_id: config.auth.clientId
          client_secret: config.auth.secret
        json: true

      request.post authOptions, (error, res, body) ->
        console.log body

      res.redirect 'http://localhost:8080'
