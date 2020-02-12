#!/usr/bin/env bash
set -eu

readonly _THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
cd "$_THIS_DIR"/test || exit 1
for test_script in *.bats; do
  ./"$test_script"
done
