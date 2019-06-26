#!/bin/bash

apt update && apt install -y ruby-full ruby-bundler build-essential
ruby -v 2>&1  | tee -a check-ruby-version.log
bundler -v 2>&1 | tee -a check-ruby-version.log
exit
