#!/bin/bash

echo "*** Running info_hub specs"

bundle install         || exit 1
bundle exec rspec spec || exit 1
