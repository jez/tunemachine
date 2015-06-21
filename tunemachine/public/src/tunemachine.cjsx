$ = require 'jquery'
React = require 'react'
PlaylistList = require './playlistlist.cjsx'
SnapshotList = require './snapshotlist.cjsx'
Playlist = require './playlist.cjsx'

TMHeader = React.createClass
  getInitialState: ->
    display_name: 'Welcome'

  componentDidMount: ->
    $('body').on 'tm:user', (e) =>
      this.setState
        user_id: e.user_id
        display_name: e.display_name

  render: ->
    <header>
      <div className="tm-header-container">
        <img className="tm-brand-logo" src="/img/logo.png" />
        <div className="tm-user-header">
          <img src="/img/user.png" />
          <span className="tm-user-name">
            {this.state.display_name || this.state.user_id}
          </span>
        </div>
      </div>
    </header>

TuneMachine = React.createClass
  render: ->
    <div className="tm-wrapper">
      <TMHeader />
      <div className="tm-main">
        <PlaylistList />
        <SnapshotList />
        <Playlist />
      </div>
    </div>

module.exports = TuneMachine
