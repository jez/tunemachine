$ = require 'jquery'
React = require 'react'
TuneMachine = require './tunemachine.cjsx'

React.render <TuneMachine />, $('#tm-target')[0]
