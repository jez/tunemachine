#!/usr/bin/env bash

# Use nodemon in development, if available, otherwise use node

if [ "$NODE_ENV" = "development" ] && which nodemon &> /dev/null ; then
  nodemon -e js,coffee server.js
else
  node server.js
fi
