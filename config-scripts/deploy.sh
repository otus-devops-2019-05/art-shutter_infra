#!/bin/bash

log=deploy.log

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

puma -d 2>&1 | tee -a $log

ps aux | grep puma | tee -a $log

