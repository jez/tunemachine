$ = require 'jquery'
_ = require 'underscore'
Modal = require './modal.cjsx'
React = require 'react'

PlaylistRestoreButton = React.createClass
  handleClick: (e) ->
    e.preventDefault()

    callback = (cancelled, name) =>
      React.unmountComponentAtNode $('#tm-modal-target')[0]
      if not cancelled
        $.ajax
          type: 'PUT'
          url: "/api/owner/#{@props.playlist.owner}/playlist/#{@props.playlist.key}/#{@props.key_}"
          data:
            name: name
          json: true
          success: (snapshot) =>
            $('body').trigger
              type: 'tm:snapshot'
              playlist: this.props.playlist
              snapshot: snapshot

            $('body').trigger
              type: 'tm:add-snapshot'
              snapshot: snapshot

    React.render <Modal initialValue="Revert to '#{this.props.name}'"
        callback={callback}/>, $('#tm-modal-target')[0]


  render: ->
    <a href="/api/playlist/#{this.props.playlist.key}/#{this.props.key_}"
        className="tm-button" onClick={this.handleClick}>
      Restore
    </a>

Track = React.createClass
  render: ->
    <tr>
      <td><a href={this.props.url}>{this.props.name}</a></td>
      <td><a href={this.props.url}>{this.props.artist}</a></td>
    </tr>

Playlist = React.createClass
  getInitialState: ->
    key: -1
    playlist:
      key: ''
      name: ''
      owner: ''
    timestamp: ''
    count: 0
    tracks: []

  componentDidMount: ->
    $('body').on 'tm:snapshot', (e) =>
      $.get "/api/playlist/#{e.playlist.key}/#{e.snapshot.key}", (snapshot) =>
        this.setState snapshot
        this.setState
          playlist: e.playlist

  render: ->
    tracks = _.map this.state.tracks, (track) ->
      <Track {...track} />

    <div className="tm-playlist">
      <h1>{this.state.name}</h1>
      <div className="tm-playlist-controls">
        <PlaylistRestoreButton {...this.state} key_={this.state.key}/>
        <p>
          Restore your playlist back in time. Restoring will create a new
          snapshot for your convenience.
        </p>
      </div>
      <div className="tm-songs-table-wrapper">
        <table className="tm-songs-table">
          <thead>
            <th>Song</th>
            <th>Artists</th>
          </thead>
          <tbody>
            {tracks}
          </tbody>
        </table>
      </div>
    </div>

module.exports = Playlist
