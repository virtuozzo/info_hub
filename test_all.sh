exit_code=0
failing_components=''

for test_script in $(find . -name test.sh); do
  pushd `dirname $test_script` > /dev/null

  sh ./test.sh

  if [ $? -ne 0 ]; then
    failing_components="$failing_components\\n${PWD##*/}"
    exit_code=1;
  fi

  popd > /dev/null
done

if [ $exit_code -eq 0 ]; then
  echo "SUCCESS"
else
  echo "FAILING COMPONENTS: $failing_components"
fi

exit $exit_code
