#!/bin/sh

# shellcheck source=./common.sh
. "$(dirname "${0}")/common.sh"

setup_test

cat > credentials.json << EOF
{
  "type": "service_account",
  "project_id": "my-cool-project",
  "private_key_id": "0123456789abcdef0123456789abcdef01234567",
  "private_key": "-----BEGIN PRIVATE KEY-----\nblahblahblahblah\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-abcd5@my-cool-project.iam.gserviceaccount.com",
  "client_id": "123456789012345678901",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-abcd5%40my-cool-project.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
EOF

assert_scan_fails 'working-tree'

git add .

assert_scan_fails 'working-tree-and-index'

echo 'credentials.json' > .gitignore

assert_scan_fails 'working-tree-and-index'

git restore --staged credentials.json

assert_scan_passes
