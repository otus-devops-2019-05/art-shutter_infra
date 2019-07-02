#!/bin/bash

log=deploy.log

git clone -b monolith https://github.com/express42/reddit.git
cd reddit 
echo $(pwd)
bundle install
