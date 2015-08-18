$ = require 'jquery'
_ = require 'underscore'
Modal = require './modal.cjsx'
moment = require 'moment'
React = require 'react/addons'

addSnapshot = (playlist, newName) ->
  $.ajax
    type: 'POST'
    url: "/api/owner/#{playlist.owner}/playlist/#{playlist.key}"
    data:
      name: "#{newName}"
    json: true
    success: (snapshot) ->
      $('body').trigger
        type: 'tm:snapshot'
        playlist: playlist
        snapshot: snapshot

      $('body').trigger
        type: 'tm:add-snapshot'
        snapshot: snapshot

SnapshotCopyButton = React.createClass
  handleClick: (e) ->
    e.preventDefault()

    callback = (cancelled, name) =>
      React.unmountComponentAtNode $('#tm-modal-target')[0]
      if not cancelled
        addSnapshot @props.playlist, name

    React.render <Modal initialValue="Snap of #{this.props.playlist.name}"
        callback={callback}/>, $('#tm-modal-target')[0]

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
      <div className="tm-snapshot-item-info"
          title={moment(this.props.timestamp).format('MMMM Do YYYY, h:mm:ss a')}>
        from {moment(this.props.timestamp).fromNow()}
      </div>
      <div className="tm-snapshot-item-info">{this.props.count} songs</div>
    </div>

SnapshotList = React.createClass
  getInitialState: ->
    playlist:
      key: -1
      name: 'Loading snapshots'
    snapshots: []
    selected: 0

  handleClick: (idx) ->
    this.setState
      selected: idx

    $('body').trigger
      type: 'tm:snapshot'
      playlist: this.state.playlist
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
          owner: e.playlist.owner
        snapshots: e.playlist.snapshots
        selected: selected

      if selected != null
        $('body').trigger
          type: 'tm:snapshot'
          playlist: e.playlist
          snapshot: e.playlist.snapshots[selected]
      else
        addSnapshot e.playlist, 'Initial snapshot'


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
        playlist: this.state.playlist
        snapshot: e.snapshot


  render: ->
    snapshotItems =  _.map this.state.snapshots, (snapshot, idx) =>
      <SnapshotItem {...snapshot} idx={idx} selected={this.state.selected}
          onClick={this.handleClick.bind(this, idx)} />

    snapshotItems.reverse()

    <div className="tm-snapshot-list">
      <h1>Snapshots</h1>
      <div className="tm-snapshot-controls">
        <SnapshotCopyButton playlist={this.state.playlist} />
        <p>
          Copy the newest version of your playlist and go back to this version
          whenever you want to in the future.
        </p>
      </div>
      <h1>History of {this.state.playlist.name}</h1>
      <div className="tm-snapshot-items-wrapper">
        {snapshotItems}
      </div>
    </div>

module.exports = SnapshotList
