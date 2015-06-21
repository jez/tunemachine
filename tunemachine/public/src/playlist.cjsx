$ = require 'jquery'
_ = require 'underscore'
React = require 'react'

PlaylistRestoreButton = React.createClass
  handleClick: (e) ->
    e.preventDefault()
    $.put "/playlists/#{this.props.playlist_id}/#{this.props.id}",
      (snapshot) ->
        $('body').trigger
          type: 'tm:snapshot'
          playlist_id: this.props.playlist_id
          snapshot: snapshot

        $('body').trigger
          type: 'tm:add-snapshot'
          snapshot:
            id: snapshot.id
            count: snapshot.count
            name: snapshot.name
            timestamp: snapshot.timestamp


  render: ->
    <a href="/playlists/#{this.props.playlist_id}/#{this.props.id}"
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
    id: -1
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
      $.get "/api/playlist/#{e.playlist_id}/#{e.snapshot.id}", (snapshot) =>
        tracks = _.map snapshot.tracks, (track) ->
          key: track.id
          name: track.name
          artist: track.artist

        this.setState
          name: snapshot.name
          timestamp: snapshot.timestamp
          count: snapshot.count
          tracks: tracks

  render: ->
    tracks = _.map this.state.tracks, (track) ->
      <Track {...track} />

    <div className="tm-playlist">
      <h1>{this.state.name}</h1>
      <PlaylistRestoreButton {...this.state}/>
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
