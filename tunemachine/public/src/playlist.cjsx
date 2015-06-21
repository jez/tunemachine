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
      ,
        key: 7
        name: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 8
        name: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 9
        name: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
        key: 10
        name: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 11
        name: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 12
        name: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 13
        name: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 14
        name: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 15
        name: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 16
        name: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 17
        name: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 18
        name: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 19
        name: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
        key: 20
        name: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 21
        name: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 22
        name: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 23
        name: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 24
        name: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 25
        name: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 26
        name: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 27
        name: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 28
        name: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 29
        name: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
        key: 30
        name: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 31
        name: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 32
        name: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 33
        name: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 34
        name: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 35
        name: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 36
        name: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 37
        name: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 38
        name: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 39
        name: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
        key: 40
        name: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 41
        name: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 42
        name: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 43
        name: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 44
        name: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 45
        name: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 46
        name: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 47
        name: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 48
        name: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 49
        name: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
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
