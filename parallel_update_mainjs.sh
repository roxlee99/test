#!/usr/bin/env bash
# parallel_update_mainjs.sh
# Update all main.js files under wwwroot in parallel on CentOS

set -euo pipefail

# ====== CONFIG ======
BASE_DIR="/www/wwwroot"   # <-- change this
GITHUB_FILE_URL="https://raw.githubusercontent.com/roxlee99/test/main/main.js"  # <-- change this

# Optional: PAT for private repos (leave empty if public)
GITHUB_TOKEN=""

# Behavior flags
DRY_RUN=0        # set to 1 for a dry run (no changes)
BACKUP=1         # set to 0 to skip creating .bak backups
JOBS="$(nproc)"  # number of parallel workers; tweak if you want
# ====================

header() { printf "\n=== %s ===\n" "$*"; }
log()    { printf "[%s] %s\n" "$(date +'%F %T')" "$*"; }

# --- Preconditions ---
command -v curl >/dev/null 2>&1 || { echo "curl is required"; exit 1; }
command -v xargs >/dev/null 2>&1 || { echo "xargs is required"; exit 1; }
[ -d "$BASE_DIR" ] || { echo "BASE_DIR not found: $BASE_DIR"; exit 1; }

# --- Fetch once to temp ---
header "Downloading new main.js"
TMP_JS="$(mktemp)"
HDRS=()
[ -n "$GITHUB_TOKEN" ] && HDRS=(-H "Authorization: token ${GITHUB_TOKEN}")

if (( DRY_RUN )); then
  log "DRY_RUN=1 -> skipping download. (Would fetch: $GITHUB_FILE_URL)"
else
  curl -fsSL "${HDRS[@]}" "$GITHUB_FILE_URL" -o "$TMP_JS"
  # quick sanity check
  if ! grep -q . "$TMP_JS"; then
    echo "Downloaded file seems empty. Aborting."; rm -f "$TMP_JS"; exit 1;
  fi
  log "Downloaded to $TMP_JS ($(wc -c < "$TMP_JS") bytes)"
fi

# --- Find all target files ---
header "Finding main.js files under $BASE_DIR"
# Use -print0 in case of spaces in paths
mapfile -d '' FILES < <(find "$BASE_DIR" -type f -name "main.js" -print0)

if (( ${#FILES[@]} == 0 )); then
  echo "No main.js files found under $BASE_DIR."
  rm -f "$TMP_JS"
  exit 0
fi

log "Found ${#FILES[@]} file(s). Updating with $JOBS parallel job(s)."

# --- The worker function (runs once per file) ---
worker() {
  local FILE="$1"
  local DIR
  DIR="$(dirname "$FILE")"

  if (( DRY_RUN )); then
    echo "DRY-RUN: Would update $FILE"
    return 0
  fi

  # Backup (optional)
  if (( BACKUP )) && [ -f "$FILE" ]; then
    cp -p "$FILE" "$FILE.bak" || true
  fi

  # Replace atomically: write to temp in dir, then mv
  local TMP_DIR_FILE
  TMP_DIR_FILE="$(mktemp --tmpdir="$DIR" .main.js.new.XXXXXX)"
  # Copy the single downloaded file into this dir
  cp -f "$TMP_JS" "$TMP_DIR_FILE"

  # Preserve perms/owner of old file if it exists; else set sane defaults
  if [ -f "$FILE" ]; then
    # keep mode and owner/group
    chmod --reference="$FILE" "$TMP_DIR_FILE" || true
    chown --reference="$FILE" "$TMP_DIR_FILE" 2>/dev/null || true
  else
    chmod 0644 "$TMP_DIR_FILE"
  fi

  # Atomic swap
  mv -f "$TMP_DIR_FILE" "$FILE"

  # If SELinux is enforcing, restore context (no-op otherwise)
  command -v restorecon >/dev/null 2>&1 && restorecon "$FILE" || true

  echo "Updated: $FILE"
}

export -f worker
export TMP_JS DRY_RUN BACKUP

# --- Run in parallel with xargs ---
printf '%s\0' "${FILES[@]}" \
  | xargs -0 -n1 -P "$JOBS" bash -c 'worker "$0"' 

# cleanup
rm -f "$TMP_JS" || true

header "Done ✅"
