_ = require 'underscore'
React = require 'react'

SnapshotCopyButton = React.createClass
  render: ->
    <a href="#" className="tm-button">
      Copy
    </a>

SnapshotItem = React.createClass
  render: ->
    className = "tm-snapshot-item"
    if this.props.selected
      className += " active"

    <div className={className}>
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

  render: ->
    snapshotItems = _.map this.state.snapshots, (snapshot) ->
      <SnapshotItem {...snapshot} />

    <div className="tm-snapshot-list">
      <h1>Copy {this.state.playlist.name}</h1>
      <SnapshotCopyButton />
      <p>
        Copy the newest version of your playlist and go back to this version
        whenever you want to in the future.
      </p>
      <h1>History of {this.state.playlist.name}</h1>
      {snapshotItems}
    </div>

module.exports = SnapshotList
