$ = require 'jquery'
_ = require 'underscore'
React = require 'react'

addSnapshot = (playlist_id, newName) ->
  $.ajax
    type: 'POST'
    url: "/api/playlist/#{playlist_id}"
    data:
      name: "#{newName}"
    json: true
    success: (snapshot) ->
      tracks = _.map snapshot.tracks, (track) ->
        key: track.id
        name: track.name
        artist: track.artist

      $('body').trigger
        type: 'tm:snapshot'
        playlist_id: playlist_id
        snapshot:
          key: snapshot.id
          name: snapshot.name
          timestamp: snapshot.timestamp
          count: snapshot.count
          tracks: tracks

      $('body').trigger
        type: 'tm:add-snapshot'
        snapshot:
          key: snapshot.id
          count: snapshot.count
          name: snapshot.name
          timestamp: snapshot.timestamp

SnapshotCopyButton = React.createClass
  handleClick: (e) ->
    e.preventDefault()
    addSnapshot(this.props.playlist.key, "Snap of #{this.props.playlist.name}")

  render: ->
    <a href="/api/playlist/#{this.props.playlist.key}" className="tm-button"
        onClick={this.handleClick}>
      New
    </a>

SnapshotItem = React.createClass
  render: ->
    className = "tm-snapshot-item"
    if this.props.selected
      className += " active"

    <div className={className} onClick={this.props.onClick}>
      <div className="tm-snapshot-item-title">{this.props.name}</div>
      <div className="tm-snapshot-item-info">from {this.props.timestamp}</div>
      <div className="tm-snapshot-item-info">{this.props.count} songs</div>
    </div>

SnapshotList = React.createClass
  getInitialState: ->
    playlist:
      name: 'Party music'
    snapshots: [
        key: 1
        name: 'Too many parties'
        timestamp: '06/20/2015'
        count: 50
        selected: true
    ]
    selected: 0

  handleClick: (idx) ->
    newSnapshots = this.state.snapshots
    newSnapshots[this.state.selected]['selected'] = false
    newSnapshots[idx]['selected'] = true

    this.setState
      selected: idx
      snapshots: newSnapshots

    $('body').trigger
      type: 'tm:snapshot'
      playlist_id: this.state.playlist.key
      snapshot: newSnapshots[idx]

  componentDidMount: ->
    $('body').on 'tm:playlist', (e) =>
      selected = -1
      if e.playlist.snapshots[0]?
        selected = e.playlist.snapshots.length - 1
        e.playlist.snapshots[selected]['selected'] = true

      this.setState
        playlist:
          key: e.playlist.key
          name: e.playlist.name
        snapshots: e.playlist.snapshots
        selected: selected

      if selected >= 0
        $('body').trigger
          type: 'tm:snapshot'
          playlist_id: e.playlist.key
          snapshot: e.playlist.snapshots[selected]
      else
        addSnapshot(e.playlist.key, "Initial snapshot")


    $('body').on 'tm:add-snapshot', (e) =>
      newSnapshots = this.state.snapshots
      newSnapshots.push
        selected: true
        key: e.snapshot.key
        name: e.snapshot.name
        timestamp: e.snapshot.name
        count: e.snapshot.count
        tracks: e.snapshot.tracks

      if this.state.selected >= 0
        newSnapshots[this.state.selected]['selected'] = false
      this.setState
        snapshots: newSnapshots
        selected: 0

      $('body').trigger
        type: 'tm:snapshot'
        playlist_id: this.state.playlist.key
        snapshot: e.snapshot


  render: ->
    snapshotItems =  _.map this.state.snapshots, (snapshot, idx) =>
      <SnapshotItem {...snapshot} onClick={this.handleClick.bind(this, idx)}/>

    snapshotItems.reverse()

    <div className="tm-snapshot-list">
      <h1>Snapshots</h1>
      <SnapshotCopyButton playlist={this.state.playlist} />
      <p>
        Copy the newest version of your playlist and go back to this version
        whenever you want to in the future.
      </p>
      <h1>History of {this.state.playlist.name}</h1>
      {snapshotItems}
    </div>

module.exports = SnapshotList
