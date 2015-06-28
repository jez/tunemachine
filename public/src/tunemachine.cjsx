$ = require 'jquery'
React = require 'react'
PlaylistList = require './playlistlist.cjsx'
SnapshotList = require './snapshotlist.cjsx'
Playlist = require './playlist.cjsx'

TuneMachine = React.createClass
  render: ->
    <div className="tm-wrapper">
      <header>
        <div className="tm-header-container">
          <img className="tm-brand-logo" src="/img/logo-black-text.png" />
          <a className="tm-sign-out" href="/auth/logout">Sign out</a>
        </div>
      </header>
      <div className="tm-main">
        <PlaylistList />
        <SnapshotList />
        <Playlist />
      </div>
    </div>

module.exports = TuneMachine
