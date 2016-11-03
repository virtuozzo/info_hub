#!/bin/bash

echo "*** Running presenter specs"

bundle install         || exit 1
bundle exec rspec spec || exit 1
