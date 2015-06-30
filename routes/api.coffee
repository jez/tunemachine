# @file api.coffee
# @brief API used to interact with the frontend of the application
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

requireLoggedIn = (req, res, next) ->
  if req.isLoggedIn()
    next()
  else
    res.status(401).json
      error: "logged_out"
      message: "You are not logged in, or your session has expired."

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
              key: p.id
              name: p.name
              snapshots: snapshots
                .filter (s) -> s.Playlist == p.id
                .map (s) ->
                  timestamp: s.Timestamp
                  key: s.id
                  count: s.Tracks.length
                  name: s.Name
                .sort (a, b) -> a.Timestamp - b.Timestamp

            res.json
              user: me
              playlists: playlists

  get = (req, res) ->
    models.Snapshot.findOne
        _id: req.params.snapId
      , (err, snap) ->
        if err?
          return models.err res, err
        if snap?
          tracks = snap.Tracks.map (track) ->
            key: track.id
            url: "https://open.spotify.com/track/#{track.id}"
            artist: track.artist
            name: track.name

          res.json
            key: snap.id
            name: snap.Name
            timestamp: snap.Timestamp
            count: snap.Tracks.length
            tracks: tracks
        else
          res.status(404).end()

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
        _id: req.params.snapId
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
