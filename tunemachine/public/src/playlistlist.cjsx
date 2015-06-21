$ = require 'jquery'
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
    <div className={className} onClick={this.props.onClick}>{this.props.name}</div>


PlaylistList = React.createClass
  getInitialState: ->
    playlists: [
        key: -1
        name: 'Loading playlists...'
        selected: true
      ,
    ]
    selected: 0

  handleClick: (idx) ->
    newPlaylists = this.state.playlists
    newPlaylists[this.state.selected]['selected'] = false
    newPlaylists[idx]['selected'] = true

    this.setState
      selected: idx
      playlists: newPlaylists

    $('body').trigger
      type: 'tm:playlist'
      playlist: newPlaylists[idx]

  componentDidMount: ->
    $.get '/api/me', (data) =>
      playlists = _.map data.playlists, (playlist) ->
        key: playlist.id
        name: playlist.name
        snapshots: playlist.snapshots
      if playlists[0]?
        playlists[0]['selected'] = true

      this.setState
        user_id: data.user_id
        display_name: data.display_name
        playlists: playlists
        selected: 0

      $('body').trigger
        type: 'tm:user'
        user_id: data.user_id
        display_name: data.display_name

      if data.playlists[0]?
        playlist = data.playlist[0]
      $('body').trigger
        type: 'tm:playlist'
        playlist: playlist

      null

  render: ->
    playlistItems = _.map this.state.playlists, (playlist, idx) =>
      <PlaylistItem {...playlist} onClick={this.handleClick.bind(this, idx)}/>

    <div className="tm-playlist-list">
      <User />
      <h1>Playlists</h1>
      {playlistItems}
    </div>

module.exports = PlaylistList
