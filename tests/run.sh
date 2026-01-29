#!/bin/bash
# Run all tests for treesitter-rails
# Usage: ./tests/run.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Running treesitter-rails tests..."
echo "================================="
echo ""

cd "$PROJECT_DIR"

# Run each test file
for test_file in tests/*_spec.lua; do
  echo "Running $test_file..."
  echo ""
  nvim --headless -u NONE \
    -c "set runtimepath+=$PROJECT_DIR" \
    -c "luafile $test_file" \
    -c "q"
  echo ""
done

echo "================================="
echo "All tests completed!"
