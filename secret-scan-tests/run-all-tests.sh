#!/bin/sh

set -eux

for test in "$(dirname "${0}")"/test-*.sh; do
  echo "Running test: ${test}"
  if ! "${test}"; then
    echo "Test ${test} failed!"
    exit 1
  fi
done

echo "All tests succeeded."
