#!/bin/sh

# shellcheck source=./common.sh
. "$(dirname "${0}")/common.sh"

setup_test

path_to_node="$(which node)"
oldpath="${PATH}"
# shellcheck disable=SC2123
PATH=''
if "${path_to_node}" .secret-scan/secret-scan.js -- --check-git-hooks > expect-no-git.txt 2>&1; then
  echo "ERROR: check for git hooks passed when git is not available!"
  exit 1
fi
PATH="${oldpath}"

grep 'Could not run git from the command line' expect-no-git.txt

if node .secret-scan/secret-scan.js -- --check-git-hooks > expect-not-installed.txt 2>&1; then
  echo "ERROR: check for git hooks passed when hooks are not installed!"
  exit 1
fi

grep 'Husky has not installed the required Git hooks' expect-not-installed.txt

git config core.hooksPath .wrong-hooks-path

if node .secret-scan/secret-scan.js -- --check-git-hooks > expect-wrong-path.txt 2>&1; then
  echo "ERROR: check for git hooks passed when hooks path is incorrect!"
  exit 1
fi

grep 'returned ".wrong-hooks-path", expected ".husky"' expect-wrong-path.txt

git config core.hooksPath .husky

node .secret-scan/secret-scan.js -- --check-git-hooks > expect-ok.txt 2>&1

grep 'Git hooks are correctly installed' expect-ok.txt
