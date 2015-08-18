# @file spotify.coffee
# @brief Interface between the app and the Spotify API
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

spotify = {}
request = require 'request'

# @brief Retrieve the userID and display name of a user.
# @param oAuthToken: the oAuthToken needed to authenticate the request.
# @param next: Callback function.
spotify.getMe = (oAuthToken, next) ->
  request.get 'https://api.spotify.com/v1/me',
    auth:
      bearer: oAuthToken
    json: true
    , (err, res, body) ->
      if err?
        return next(err, null)
      values = {}
      values.id = body.id
      values.display_name = body.display_name

      if body.images.length > 0
        values.image = body.images[0].url
      next(null, values)

# @brief Retrieve a list of playlist ids owned by the user.  Will paginate
# through all of the requests to return a full list.
# @param oAuthToken: the oAuthToken needed to authenticate the request.
# @param userId: Id of user to retrieve playlists for.
# @param next: Callback function.
spotify.getPlaylists = (oAuthToken, userId, next) ->
  values = {}
  values.playlists = []
  repeat = (url, next) ->
    request.get url,
      auth:
        bearer: oAuthToken
      json: true
      , (err, res, body) ->
        if err?
          return next(err, null)

        items = []
        if body.items?
          items = body.items.map (p) ->
            result = {}
            result.id = p.id
            result.name = p.name
            result.owner = p.owner.id
            return result

        values.playlists = values.playlists.concat items

        if body.next?
          repeat body.next, next
        else
          next null, values

  repeat "https://api.spotify.com/v1/users/#{ userId }/playlists?limit=50", next

# @brief Retrieve current songs from a playlist.
# @param oAuthToken: the oAuthToken needed to authenticate the request.
# @param playlistId: Id of playlist to retrieve songs for.
# @param next: Callback function.
spotify.getSnapshot = (oAuthToken, userId, playlistId, next) ->
  values = {}
  values.songs = []
  repeat = (url, next) ->
    request.get url,
      auth:
        bearer: oAuthToken
      json: true
      , (err, res, body) ->
        if err?
          return next(err, null)

        items = []
        if body.items?
          items = body.items.map (p) ->
            result = {}
            result.id = p.track.id
            result.name = p.track.name
            result.artist = p.track.artists.map (a) -> a.name
              .join ", "
            return result

        values.songs = values.songs.concat items

        if body.next?
          repeat body.next, next
        else
          next null, values

  repeat "https://api.spotify.com/v1/users/#{ userId }/playlists/#{ playlistId }/tracks?limit=100", next

# @brief Deletes all songs from a playlist and adds the given list of songs.
# @param oAuthToken: the oAuthToken needed to authenticate the request.
# @param playlistId: Id of playlist to set.
# @param songs: Songs to write to playlist.
# @param next: Callback function.
spotify.setSnapshot = (oAuthToken, userId, playlistId, songs, next) ->
  chunk = (arr) -> arr.slice i, i + 100 for i in [0..arr.length] by 100

  songs = chunk songs.map((i) -> "spotify:track:#{i}")
  songs.reverse()

  s = songs.pop()
  request
      method: 'PUT'
      auth:
        bearer: oAuthToken
      json:
        uris: s
      uri: "https://api.spotify.com/v1/users/#{ userId }/playlists/#{ playlistId }/tracks"
    , (err, res, body) ->
      if err?
        return next(err, null)
      if songs.length == 0
        return next null

      recurse = () ->
        if songs.length == 0
          return next null
        s = songs.pop()
        request
            method: 'POST'
            auth:
              bearer: oAuthToken
            json:
              uris: s
            uri: "https://api.spotify.com/v1/users/#{ userId }/playlists/#{ playlistId }/tracks"
          , recurse

      recurse()

module.exports = spotify
