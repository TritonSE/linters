#!/bin/sh

# shellcheck source=./common.sh
. "$(dirname "${0}")/common.sh"

setup_test

cat > .env.example << EOF
BE_SUPER_AWESOME=true
MONGODB_URL=mongodb+srv://username:password@cluster0.abcdef7.mongodb.net/?retryWrites=true&w=majority
PASSWORD_RESET_EXPIRATION_SEC=3600
EOF

assert_scan_fails 'working-tree'

git add .env.example
sed -i 's/password/newpassword/' .env.example

assert_scan_fails 'working-tree-and-index'

rm .env.example

assert_scan_fails 'index'

git restore --staged .env.example

assert_scan_passes
