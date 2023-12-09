#!/bin/sh

# shellcheck source=./common.sh
. "$(dirname "${0}")/common.sh"

setup_test

cat > .env.example << EOF
MONGODB_URL_1=mongodb://127.0.0.1:27107/demo
MONGODB_URL_2=mongodb://localhost
EOF

assert_scan_passes

git add .env.example
assert_scan_passes

git commit -m "add .env.example"
assert_scan_passes
