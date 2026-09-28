#!/bin/sh
set -e

output=$(./hello.sh)

if [ "$output" != "hello" ]; then
  echo "FAIL: expected 'hello', got '$output'"
  exit 1
fi

echo "PASS"
