# @file api.coffee
# @brief API used to interact with the frontend of the application
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

requireLoggedIn = (req, res, next) ->
  if req.session.access_token? and Date.now() < req.session.expiration
    next()
  else
    res.redirect '/auth/login'

module.exports = (app, models, spotify) ->

  # GET /api/me/
  app.get '/api/me', requireLoggedIn, (req, res) ->
    spotify.getMe req.session.access_token, (err, me) ->
      if err?
        return models.err res, err
      spotify.getPlaylists req.session.access_token, req.session.user_id, (err, playlists) ->
        if err?
          return models.err res, err

        playlistIDs = playlists.playlists.map (p) -> p.id

        models.Snapshot.find
            Playlist:
              $in:
                playlistIDs
          , (err, snapshots) ->
            if err?
              return models.err res, err

            playlists = playlists.playlists.map (p) ->
              p.snapshots = snapshots
                .filter (s) -> s.Playlist == p.id
                .map (s) ->
                  val = {}
                  val.timestamp = s.Timestamp
                  val.id = s.id
                  val.count = s.Tracks.length
                  val.name = s.Name
                  return val
                .sort (a, b) ->
                  return a.Timestamp - b.Timestamp
              return p

            res.json
              user_id: me.id
              display_name: me.display_name
              playlists: playlists

  get = (req, res) ->
    models.Snapshot.findOne
        _id: req.params.snapId
      , (err, snap) ->
        if err?
          return models.err res, err
        if snap?
          val = {}
          val.id = snap.id
          val.name = snap.Name
          val.timestamp = snap.Timestamp
          val.count = snap.Tracks.length
          val.tracks = snap.Tracks
          res.json val
        else
          res.status = 404
          res.end()

  # GET /api/playlist/:playlistId/:snapId
  app.get '/api/playlist/:playlistId/:snapId', requireLoggedIn, get

  post = (req, res) ->
    unless req.body.name?
      res.status 400
      res.end 'Need name'
    else
      spotify.getSnapshot req.session.access_token, req.session.user_id, req.params.playlistId, (err, snap) ->
        if err?
          return models.err res, err

        s = new models.Snapshot
          Name: req.body.name
          Playlist: req.params.playlistId
          Tracks: snap.songs

        s.save (err) ->
          if err?
            return models.err res, err
          req.params.snapId = s.id
          get req, res

  # POST /api/playlist/:playlistId
  app.post '/api/playlist/:playlistId', post

  # PUT /api/playlist/:playlistId/:snapId
  app.put '/api/playlist/:playlistId/:snapId', (req, res) ->
    unless req.body.name?
      res.status 400
      res.end 'Need name'
    else
      models.Snapshot.findOne
        id: req.params.snapId
      , (err, snap) ->
        if err?
          return models.err res, err

        if snap?
          songs = snap.Tracks.map (s) -> s.id
          spotify.setSnapshot req.session.access_token, req.session.user_id, req.params.playlistId, songs, (err) ->
            if err?
              return models.err res, err

            # take a snapshot of the state of the new system
            post req, res

        else
          res.status 404
          res.end()

    res.status 200
    res.end()
