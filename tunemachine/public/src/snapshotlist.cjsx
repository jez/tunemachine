$ = require 'jquery'
_ = require 'underscore'
React = require 'react/addons'

addSnapshot = (playlist_id, newName) ->
  $.ajax
    type: 'POST'
    url: "/api/playlist/#{playlist_id}"
    data:
      name: "#{newName}"
    json: true
    success: (snapshot) ->
      $('body').trigger
        type: 'tm:snapshot'
        playlist_id: playlist_id
        snapshot: snapshot

      $('body').trigger
        type: 'tm:add-snapshot'
        snapshot: snapshot

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
    if this.props.selected == this.props.idx
      className += " active"

    <div className={className} onClick={this.props.onClick}>
      <div className="tm-snapshot-item-title">{this.props.name}</div>
      <div className="tm-snapshot-item-info">from {this.props.timestamp}</div>
      <div className="tm-snapshot-item-info">{this.props.count} songs</div>
    </div>

SnapshotList = React.createClass
  getInitialState: ->
    playlist:
      key: -1
      name: 'Party music'
    snapshots: [
        key: 1
        name: 'Too many parties'
        timestamp: '06/20/2015'
        count: 50
    ]
    selected: 0

  handleClick: (idx) ->
    this.setState
      selected: idx

    $('body').trigger
      type: 'tm:snapshot'
      playlist_id: this.state.playlist.key
      snapshot: this.state.snapshots[idx]

  componentDidMount: ->
    $('body').on 'tm:playlist', (e) =>
      selected = null
      if e.playlist.snapshots[0]?
        selected = e.playlist.snapshots.length - 1

      this.setState
        playlist:
          key: e.playlist.key
          name: e.playlist.name
        snapshots: e.playlist.snapshots
        selected: selected

      if selected != null
        $('body').trigger
          type: 'tm:snapshot'
          playlist_id: e.playlist.key
          snapshot: e.playlist.snapshots[selected]
      else
        addSnapshot(e.playlist.key, "Initial snapshot")


    $('body').on 'tm:add-snapshot', (e) =>
      oldLen = this.state.snapshots.length
      newState = React.addons.update this.state,
        snapshots:
          $push: [e.snapshot]

      this.setState newState
      this.setState
        selected: oldLen       # oldLen is final idx after pushing one

      $('body').trigger
        type: 'tm:snapshot'
        playlist_id: this.state.playlist.key
        snapshot: e.snapshot


  render: ->
    snapshotItems =  _.map this.state.snapshots, (snapshot, idx) =>
      <SnapshotItem {...snapshot} idx={idx} selected={this.state.selected}
          onClick={this.handleClick.bind(this, idx)} />

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
