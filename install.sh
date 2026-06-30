#!/usr/bin/env bash
# claude-loopkit installer
# usage:  curl -fsSL https://raw.githubusercontent.com/Archive228/loopkit/main/install.sh | bash
#         FORCE=1 ... | bash   # overwrite existing files
#         DEST=/path/... | bash  # install elsewhere
set -euo pipefail

REPO="${LOOPKIT_REPO:-Archive228/loopkit}"
REF="${LOOPKIT_REF:-main}"
DEST="${DEST:-$PWD}"
FORCE="${FORCE:-0}"

echo "claude-loopkit: installing into $DEST"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF" \
  | tar -xz --strip-components=1 -C "$TMP"

wrote=0
skipped=0

copy_file() {
  src=$1
  dst=$2
  if [ -e "$dst" ] && [ "$FORCE" != "1" ]; then
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  case "$src" in *.sh) chmod +x "$dst" ;; esac
  wrote=$((wrote + 1))
}

copy_tree() {
  src_root=$1
  dst_root=$2
  [ -d "$src_root" ] || return 0
  while IFS= read -r f; do
    rel=${f#"$src_root"/}
    copy_file "$f" "$dst_root/$rel"
  done < <(find "$src_root" -type f)
}

copy_tree "$TMP/.claude" "$DEST/.claude"
copy_tree "$TMP/skills" "$DEST/.claude/skills"
for f in .mcp.json MEMORY.md run.sh; do
  [ -f "$TMP/$f" ] && copy_file "$TMP/$f" "$DEST/$f"
done

echo
echo "claude-loopkit: install complete"
echo "  $wrote files written, $skipped skipped${skipped:+ (set FORCE=1 to overwrite)}"
echo
echo "Next: open Claude Code in $DEST. Skills load on relevant triggers."
echo "Docs and full 33-skill list: https://github.com/$REPO"
