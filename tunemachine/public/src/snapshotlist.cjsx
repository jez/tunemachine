$ = require 'jquery'
_ = require 'underscore'
React = require 'react'

SnapshotCopyButton = React.createClass
  handleClick: (e) ->
    e.preventDefault()
    $.post "/playlists/#{this.props.playlist.id}",
      data:
        name: "Revert #{this.props.playlist.name}"
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
    <a href="/api/playlist/#{this.props.playlist_id}" className="tm-button"
        onClick={this.handleClick}>
      New
    </a>

SnapshotItem = React.createClass
  render: ->
    className = "tm-snapshot-item"
    if this.props.selected
      className += " active"

    <div className={className} onClick={this.props.onClick}>
      <div className="tm-snapshot-item-title">{this.props.title}</div>
      <div className="tm-snapshot-item-info">from {this.props.timestamp}</div>
      <div className="tm-snapshot-item-info">{this.props.count} songs</div>
    </div>

SnapshotList = React.createClass
  getInitialState: ->
    playlist:
      name: 'Party music'
    snapshots: [
        key: 1
        title: 'Too many parties'
        timestamp: '06/20/2015'
        count: 50
        selected: true
      ,
        key: 2
        title: 'My fifth party in June'
        timestamp: '06/17/2015'
        count: 87
      ,
        key: 3
        title: 'My fourth party in June'
        timestamp: '06/13/2015'
        count: 62
      ,
        key: 4
        title: 'My third party in June'
        timestamp: '06/09/2015'
        count: 59
      ,
        key: 5
        title: 'My second party in June'
        timestamp: '06/05/2015'
        count: 102
      ,
        key: 6
        title: 'My first party in June'
        timestamp: '06/01/2015'
        count: 93
      ,
        key: 7
        title: 'My second party in June'
        timestamp: '06/05/2015'
        count: 102
      ,
        key: 8
        title: 'My first party in June'
        timestamp: '06/01/2015'
        count: 93
      ,
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
      playlist: newSnapshots[idx]

  componentDidMount: ->
    $('body').on 'tm:playlist', (e) =>
      selected = -1
      if e.playlist.snapshots[0]?
        e.playlist.snapshots[0]['selected'] = true
        selected = 0

      this.setState
        playlist:
          key: e.playlist.id
          name: e.playlist.name
        snapshots: e.playlist.snapshots
        selected: selected

      if e.playlist.snapshots[0]?
        snapshot = e.playlist.snapshot[0]
      $('body').trigger
        type: 'tm:snapshot'
        playlist_id: e.playlist.id
        snapshot: snapshot

    $('body').on 'tm:add-playlist', (e) =>
      e.snapshot.selected = true
      newSnapshots = this.state.snapshots
      newSnapshots.unshift(e.snapshot)

      if this.state.selected >= 0
        newSnapshots[this.state.selected] = false
      this.setState
        snapshots: newSnapshots
        selected: 0


  render: ->
    snapshotItems = _.map this.state.snapshots, (snapshot, idx) =>
      <SnapshotItem {...snapshot} onClick={this.handleClick.bind(this, idx)}/>

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
