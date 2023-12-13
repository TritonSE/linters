#!/bin/sh

# shellcheck source=./common.sh
. "$(dirname "${0}")/common.sh"

setup_test

cat > .env.example << EOF
COOL_SERVICE_TOKEN=coolservice:1234567890abcdef
EOF

assert_scan_passes

git add .env.example

assert_scan_passes

git commit -m "add .env.example"

assert_scan_passes

rm .env.example

assert_scan_passes

git add .

assert_scan_passes

git commit -m "remove .env.example"

assert_scan_passes

# Add a new regex to the config which matches a previously committed file.
# We need to ensure that the cache is invalidated when the config changes.
sed -i \
  's/"secretRegexes": {/& "coolServiceToken": "coolservice:[0-9a-f]+",/' \
  .secret-scan/secret-scan-config.json

assert_scan_fails 'committed'

# Assume we revoked the secret and decided not to rewrite the commit history.
sed -i \
  's/"allowedStrings": \[/&"coolservice:1234567890abcdef", /' \
  .secret-scan/secret-scan-config.json

assert_scan_passes
