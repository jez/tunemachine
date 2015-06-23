$ = require 'jquery'
_ = require 'underscore'
React = require 'react'

PlaylistRestoreButton = React.createClass
  handleClick: (e) ->
    e.preventDefault()
    $.ajax
      type: 'PUT'
      url: "/api/playlist/#{this.props.playlist_id}/#{this.props.key_}"
      data:
        name: "Revert to '#{this.props.name}'"
      json: true
      success: (snapshot) =>
        $('body').trigger
          type: 'tm:snapshot'
          playlist_id: this.props.playlist_id
          snapshot: snapshot

        $('body').trigger
          type: 'tm:add-snapshot'
          snapshot: snapshot

  render: ->
    <a href="/api/playlist/#{this.props.playlist_id}/#{this.props.key_}"
        className="tm-button" onClick={this.handleClick}>
      Restore
    </a>

Track = React.createClass
  render: ->
    <tr>
      <td>{this.props.name}</td>
      <td>{this.props.artist}</td>
    </tr>

Playlist = React.createClass
  getInitialState: ->
    key: -1
    name: 'Too many parties'
    timestamp: '06/20/2015'
    count: 50
    tracks: [
        key: 0
        name: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 1
        name: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 2
        name: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 3
        name: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 4
        name: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 5
        name: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 6
        name: 'Cruel World'
        artist: 'Lana Del Rey'
    ]

  componentDidMount: ->
    $('body').on 'tm:snapshot', (e) =>
      $.get "/api/playlist/#{e.playlist_id}/#{e.snapshot.key}", (snapshot) =>
        this.setState snapshot
        this.setState
          playlist_id: e.playlist_id

  render: ->
    tracks = _.map this.state.tracks, (track) ->
      <Track {...track} />

    <div className="tm-playlist">
      <h1>{this.state.name}</h1>
      <PlaylistRestoreButton {...this.state} key_={this.state.key}/>
      <p>
        Restore your playlist back in time. Restoring will create a new
        snapshot for your convenience.
      </p>
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

module.exports = Playlist
