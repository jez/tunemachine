$ = require 'jquery'
_ = require 'underscore'
React = require 'react/addons'

User = React.createClass
  getInitialState: ->
    image: '/img/user.png'

  componentDidMount: ->
    $('body').on 'tm:user', (e) =>
      this.setState
        image: e.image

  render: ->
    <div className="tm-user">
      <img className="tm-user-avatar"
          src={this.state.image} />
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

      $('body').trigger
        type: 'tm:user'
        user_id: data.user_id
        display_name: data.display_name
        image: data.image

      if selected != null
        $('body').trigger
          type: 'tm:playlist'
          playlist: data.playlists[selected]

    # TODO: listen to add-snapshot event

  render: ->
    playlistItems = _.map this.state.playlists, (playlist, idx) =>
      <PlaylistItem {...playlist} idx={idx} selected={this.state.selected}
          onClick={this.handleClick.bind(this, idx)} />

    <div className="tm-playlist-list">
      <User />
      <h1>Playlists</h1>
      {playlistItems}
    </div>

module.exports = PlaylistList
