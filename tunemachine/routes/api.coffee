# @file api.coffee
# @brief API used to interact with the frontend of the application
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

module.exports = (app) ->

  # GET /api/me/
  app.get '/api/me', (req, res) ->
    res.end 'Unimplemented'

  # GET /api/playlist/:playlistId/:snapId
  app.get '/api/playlist/:playlistId/:snapId', (req, res) ->
    res.end "Unimplemented. Playlist: #{req.params.playlistId} Snap: #{req.params.snapId}"

  # POST /api/playlist/:playlistId
  app.post '/api/playlist/:playlistId', (req, res) ->
    res.end "Unimplemented. Playlist: #{req.params.playlistId}"

  # PUT /api/playlist/:playlistId/:snapId
  app.put '/api/playlist/:playlistId/:snapId', (req, res) ->
    res.end "Unimplemented. Playlist: #{req.params.playlistId} Snap: #{req.params.snapId}"
