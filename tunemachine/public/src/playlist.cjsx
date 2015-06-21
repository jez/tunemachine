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

Song = React.createClass
  render: ->
    <tr>
      <td>{this.props.title}</td>
      <td>{this.props.artist}</td>
    </tr>

Playlist = React.createClass
  getInitialState: ->
    id: -1
    name: 'Too many parties'
    timestamp: '06/20/2015'
    count: 50
    songs: [
        key: 0
        title: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 1
        title: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 2
        title: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 3
        title: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 4
        title: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 5
        title: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 6
        title: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 7
        title: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 8
        title: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 9
        title: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
        key: 10
        title: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 11
        title: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 12
        title: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 13
        title: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 14
        title: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 15
        title: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 16
        title: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 17
        title: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 18
        title: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 19
        title: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
        key: 20
        title: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 21
        title: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 22
        title: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 23
        title: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 24
        title: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 25
        title: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 26
        title: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 27
        title: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 28
        title: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 29
        title: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
        key: 30
        title: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 31
        title: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 32
        title: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 33
        title: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 34
        title: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 35
        title: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 36
        title: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 37
        title: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 38
        title: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 39
        title: 'Brooklyn Baby'
        artist: 'Lana Del Rey'
      ,
        key: 40
        title: 'West Coast'
        artist: 'Lana Del Rey'
      ,
        key: 41
        title: 'Shut Up and Dance'
        artist: 'Walk the moon'
      ,
        key: 42
        title: 'Fight Song'
        artist: 'Rachel Platten'
      ,
        key: 43
        title: 'Reckless Serenade'
        artist: 'Artic Monkeys'
      ,
        key: 44
        title: "Why'd you only call me when you're high"
        artist: 'Artic Monkeys'
      ,
        key: 45
        title: 'Fluorescent Adolescent'
        artist: 'Artic Monkeys'
      ,
        key: 46
        title: 'Cruel World'
        artist: 'Lana Del Rey'
      ,
        key: 47
        title: 'Ultraviolence'
        artist: 'Lana Del Rey'
      ,
        key: 48
        title: 'Shade of Cool'
        artist: 'Lana Del Rey'
      ,
        key: 49
        title: 'Brooklyn Baby'
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
    songs = _.map this.state.songs, (song) ->
      <Song {...song} />

    <div className="tm-playlist">
      <h1>{this.state.title}</h1>
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
          {songs}
        </tbody>
      </table>
    </div>

module.exports = Playlist
