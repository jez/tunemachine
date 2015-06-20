# @file spotify.coffee
# @brief Interface between the app and the Spotify API
# @author Justin Gallagher, justingallag@gmail.com
# @since 20 Jun 2015

spotify = {}

# @brief Authenticate a user.
# @param next: Callback function.
spotify.signIn = (next) ->
  next()

# @brief Retrieve a list of playlist ids owned by the user.
# @param userId: Id of user to retrieve playlists for.
# @param next: Callback function.
spotify.getPlaylists = (userId, next) ->
  next()

# @brief Retrieve current songs from a playlist.
# @param playlistId: Id of playlist to retrieve songs for.
# @param next: Callback function.
spotify.getCurrentSongs = (playlistId, next) ->
  next()

# @brief Deletes all songs from a playlist and adds the given list of songs.
# @param playlistId: Id of playlist to set.
# @param songs: Songs to write to playlist.
# @param next: Callback function.
spotify.applySnapshot = (playlistId, songs, next) ->
  next()

module.exports = spotify
