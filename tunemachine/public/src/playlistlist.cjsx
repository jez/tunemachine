_ = require 'underscore'
React = require 'react'

User = React.createClass
  render: ->
    <div className="tm-user">
      <img className="tm-user-avatar"
          src="https://avatars1.githubusercontent.com/u/10713430?v=3&s=400" />
    </div>

PlaylistItem = React.createClass
  render: ->
    className = "tm-playlist-item"
    if this.props.selected
      className += " active"
    <div className={className}>{this.props.name}</div>


PlaylistList = React.createClass
  getInitialState: ->
    playlists: [
        key: 1
        name: 'Beyonce'
      ,
        key: 2
        name: 'Lana Del Rey'
      ,
        key: 3
        name: 'Party music'
        selected: true
      ,
        key: 4
        name: 'Rock & roll'
      ,
        key: 5
        name: 'Country music'
      ,
        key: 6
        name: 'Workout music'
    ]

  render: ->
    playlistItems = _.map this.state.playlists, (playlist) ->
      <PlaylistItem {...playlist} />

    <div className="tm-playlist-list">
      <User />
      <h1>Playlists</h1>
      {playlistItems}
    </div>

module.exports = PlaylistList
