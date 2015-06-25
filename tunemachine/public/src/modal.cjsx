$ = require 'jquery'
_ = require 'underscore'
React = require 'react'

Modal = React.createClass
  getInitialState: ->
    value: this.props.initialValue || ''
    state: 'active'

  blur: () ->
    this.setState
      state: ''
    cancelled = true
    this.props.callback cancelled

  nop: (e) ->
    # Prevent click from bubbling up to blur
    e.stopPropagation()

  change: (e) ->
    this.setState
      value: e.target.value

  submit: (e) ->
    e.preventDefault()
    this.blur()
    cancelled = false
    this.props.callback cancelled, this.state.value

  render: ->
    <div className="tm-modal-canvas #{this.state.state}" onClick={this.blur}>
      <div className="tm-modal" onClick={this.nop}>
        <h1>Name your snapshot</h1>
        <form className="tm-modal-form" onSubmit={this.submit}>
          <input className="tm-modal-input" type="text" name="snapshotName"
              placeholder="My awesome snapshot" value={this.state.value}
              onChange={this.change} />
          <button className="tm-modal-button">Create</button>
        </form>
      </div>
    </div>

module.exports = Modal
