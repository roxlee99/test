#!/usr/bin/env bash
# parallel_update_mainjs_userdir.sh
# Usage: ./parallel_update_mainjs_userdir.sh <BASE_DIR> <GITHUB_FILE_URL>

set -euo pipefail

# Check args
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <BASE_DIR> <GITHUB_FILE_URL>"
    exit 1
fi

BASE_DIR="$1"
GITHUB_FILE_URL="$2"

# Validate
[ -d "$BASE_DIR" ] || { echo "Directory not found: $BASE_DIR"; exit 1; }
[ -n "$GITHUB_FILE_URL" ] || { echo "URL cannot be empty"; exit 1; }

# Download once
TMP_JS="$(mktemp)"
curl -fsSL "$GITHUB_FILE_URL" -o "$TMP_JS"

# Replace in parallel
find "$BASE_DIR" -type f -name "main.js" -print0 |
  xargs -0 -n1 -P "$(nproc)" bash -c '
    FILE="$0"
    cp -f "'"$TMP_JS"'" "$FILE"
    echo "Updated: $FILE"
  '

rm -f "$TMP_JS"
echo "✅ Done updating all main.js files under $BASE_DIR"
