$ = require 'jquery'
React = require 'react'
TuneMachine = require './tunemachine.cjsx'

Modal = require './modal.cjsx'

$(document).ready () ->
  React.render <TuneMachine />, $('#tm-target')[0]
