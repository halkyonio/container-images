#!/bin/bash

if [[ $cmd = "build" ]]; then
  source /usr/local/bin/build.sh
else
  source /usr/local/bin/run.sh
fi
