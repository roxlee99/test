#!/usr/bin/env bash
# fix-bd51.sh — replace bd51static.com/*.js with web51tj.com/kk.js in index.html files

set -euo pipefail

SEARCH_DIR="/www/wwwroot"    # default if not provided
BACKUP_EXT=".bak-$(date +%F_%H%M%S)"

echo "Scanning: $SEARCH_DIR"
updated=0

# Find all index.html files under SEARCH_DIR
find "$SEARCH_DIR" -type f -name "index.html" -print0 | while IFS= read -r -d '' file; do
  if grep -qE 'bd51static\.com/[0-9a-z]+\.js' "$file"; then
    # Make an in-place backup and replace any bd51static.com/<something>.js with web51tj.com/kk.js
    sed -r -i"$BACKUP_EXT" 's|bd51static\.com/[0-9a-z]+\.js|web51tj.com/kk.js|g' "$file"
    echo "Updated: $file (backup: ${file}${BACKUP_EXT})"
    updated=$((updated+1))
  fi
done

echo "Done. Files updated: $updated"
