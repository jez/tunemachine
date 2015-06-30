$ = require 'jquery'
_ = require 'underscore'
React = require 'react/addons'

User = React.createClass
  render: ->
    <div className="tm-user">
      <img className="tm-user-avatar"
          src={this.props.image || '/img/user.png'} />
      <div className="tm-user-name">
        {this.props.display_name || this.props.id}
      </div>
    </div>


PlaylistItem = React.createClass
  render: ->
    className = "tm-playlist-item"
    if this.props.selected == this.props.idx
      className += " active"

    <div className={className} onClick={this.props.onClick}>
      {this.props.name}
    </div>


PlaylistList = React.createClass
  getInitialState: ->
    user:
      id: ''
      display_name: 'Welcome'
      image: ''
    playlists: [
        key: -1
        name: 'Loading playlists...'
        snapshots: []
      ,
    ]
    selected: 0

  handleClick: (idx) ->
    this.setState
      selected: idx

    $('body').trigger
      type: 'tm:playlist'
      playlist: this.state.playlists[idx]

  componentDidMount: ->
    $.get '/api/me', (data) =>
      selected = null
      if data.playlists[0]?
        selected = 0

      this.setState data
      this.setState
        selected: selected

      if selected != null
        $('body').trigger
          type: 'tm:playlist'
          playlist: data.playlists[selected]

    $('body').on 'tm:add-snapshot', (e) =>
      # This whold function is kind of a hack because there are two sources of
      # truth for lists of snapshots. Ideally, they'd be either all entirely
      # managed in one place instead of both by PlaylistList and SnapshotList

      # Push the new snapshot onto the current playlist

      playlist = this.state.playlists[this.state.selected]

      if playlist
        operation =
          $push: [e.snapshot]
      else
        operation =
          $set: [e.snapshot]

      newPlaylist = React.addons.update playlist,
        snapshots: operation

      # Set the new playlist as the real playlist

      update = {}
      update[this.state.selected] =
        $set: newPlaylist

      newState = React.addons.update this.state,
        playlists: update

      this.setState newState

  render: ->
    playlistItems = _.map this.state.playlists, (playlist, idx) =>
      <PlaylistItem {...playlist} idx={idx} selected={this.state.selected}
          onClick={this.handleClick.bind(this, idx)} />

    <div className="tm-playlist-list">
      <User {...this.state.user} />
      <h1>Playlists</h1>
      <div className="tm-playlist-list-wrapper">
        {playlistItems}
      </div>
    </div>

module.exports = PlaylistList
