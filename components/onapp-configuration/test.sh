#!/bin/bash

echo "*** Running OnApp configuration specs"

bundle install         || exit 1
bundle exec rspec spec || exit 1
