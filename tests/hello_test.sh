#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

output="$(./hello.sh)"

if [ "$output" != "hello" ]; then
  echo "FAIL: expected 'hello', got '$output'"
  exit 1
fi

echo "PASS"
