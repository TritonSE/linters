#!/bin/sh

set -eux

setup_test() {
  repo_dir="$(git rev-parse --show-toplevel)"
  test_name="$(basename "${0}" ".sh")"
  test_dir="${repo_dir}/secret-scan-tests/${test_name}"

  rm -rf "${test_dir}"
  mkdir "${test_dir}"

  # Keep this list of files in sync with the install instructions in the README.
  for file in \
    .secret-scan/.gitignore \
    .secret-scan/secret-scan-config.json \
    .secret-scan/secret-scan.js \
  ; do
    mkdir -p "$(dirname "${test_dir}/${file}")"
    cp -a "${repo_dir}/${file}" "${test_dir}/${file}"
  done

  cd "${test_dir}"
  git init
  git add .
  git commit -m "initial commit"
}

assert_scan_passes() {
  SECRET_SCAN_WRITE_REPORT=1 node .secret-scan/secret-scan.js
  diff .secret-scan/secret-scan-report.json "../empty-report.json"
}

assert_scan_fails() {
  if SECRET_SCAN_WRITE_REPORT=1 node .secret-scan/secret-scan.js; then
    echo "ERROR: secret scan passed when it should have failed!"
    diff .secret-scan/secret-scan-report.json "../${test_name}-${1}.json"
    exit 1
  else
    # The commit hashes are different every time, so replace them with XXXXXXX
    # to make diffing easier.
    sed -i 's/commit \\"....... /commit \\"XXXXXXX /g' .secret-scan/secret-scan-report.json
    diff .secret-scan/secret-scan-report.json "../${test_name}-${1}.json"
  fi
}
