$ = require 'jquery'
React = require 'react'
TuneMachine = require './tunemachine.cjsx'

$(document).ready () ->
  React.render <TuneMachine />, $('#tm-target')[0]
