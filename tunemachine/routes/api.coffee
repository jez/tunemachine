# @file api.coffee
# @brief API used to interact with the frontend of the application
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

requireLoggedIn = (req, res, next) ->
  if req.session.access_token?
    next()
  else
    res.status 403
    res.end 'Forbidden: Not logged in.'

module.exports = (app, models, spotify) ->

  # GET /api/me/
  app.get '/api/me', requireLoggedIn, (req, res) ->
    spotify.getMe req.session.access_token, (err, me) ->
      if err?
        return res.end 'Failed'
      spotify.getPlaylists req.session.access_token, req.session.user_id, (err, playlists) ->
        if err?
          return res.end 'Failed'
        res.json
          user_id: me.id
          display_name: me.display_name
          playlists: playlists.playlists


  # GET /api/playlist/:playlistId/:snapId
  app.get '/api/playlist/:playlistId/:snapId', (req, res) ->
    res.end "Unimplemented. Playlist: #{req.params.playlistId} Snap: #{req.params.snapId}"

  # POST /api/playlist/:playlistId
  app.post '/api/playlist/:playlistId', (req, res) ->
    res.end "Unimplemented. Playlist: #{req.params.playlistId}"

  # PUT /api/playlist/:playlistId/:snapId
  app.put '/api/playlist/:playlistId/:snapId', (req, res) ->
    res.end "Unimplemented. Playlist: #{req.params.playlistId} Snap: #{req.params.snapId}"
