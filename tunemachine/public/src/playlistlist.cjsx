$ = require 'jquery'
_ = require 'underscore'
React = require 'react'

User = React.createClass
  render: ->
    <div className="tm-user">
      <img className="tm-user-avatar"
          src="https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xpf1/t31.0-8/p960x960/10848537_546033172204121_2712981497933985479_o.jpg" />
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
        snapshots = _.map playlist.snapshots, (snapshot) ->
          key: snapshot.id
          count: snapshot.count
          name: snapshot.name
          timestamp: snapshot.timestamp
        key: playlist.id
        name: playlist.name
        snapshots: snapshots

      selected = -1
      if playlists[0]?
        playlists[0]['selected'] = true
        selected = 0

      this.setState
        user_id: data.user_id
        display_name: data.display_name
        playlists: playlists
        selected: selected

      $('body').trigger
        type: 'tm:user'
        user_id: data.user_id
        display_name: data.display_name

      if selected
        playlist = playlists[selected]
      $('body').trigger
        type: 'tm:playlist'
        playlist: playlists[selected]

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
