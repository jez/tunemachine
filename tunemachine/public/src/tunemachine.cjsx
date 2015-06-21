React = require 'react'
PlaylistList = require './playlistlist.cjsx'
SnapshotList = require './snapshotlist.cjsx'
Playlist = require './playlist.cjsx'

TMHeader = React.createClass
  render: ->
    <header>
      <div className="tm-header-container">
        <img className="tm-brand-logo" src="/img/logo.png" />
        <div className="tm-user-header">
          <img src="/img/user.png" />
          <span className="tm-user-name">{this.props.user.name}</span>
        </div>
      </div>
    </header>

TuneMachine = React.createClass
  getInitialState: ->
    user:
      name: 'Jake Zimmerman'

  render: ->
    console.log typeof(this.state.user)

    <div className="tm-wrapper">
      <TMHeader user={this.state.user} />
      <div className="tm-main">
        <PlaylistList />
        <SnapshotList />
        <Playlist />
      </div>
    </div>

module.exports = TuneMachine
