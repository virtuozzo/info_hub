#!/bin/bash

exit_code=0

echo "*** Running info_hub specs"
bundle exec rspec spec
exit_code+=$?

exit $exit_code
