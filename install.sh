#!/usr/bin/env bash
# claude-loopkit installer
#
#   curl -fsSL https://raw.githubusercontent.com/Archive228/loopkit/main/install.sh | bash
#
# Env vars:
#   FORCE=1              overwrite existing files (default: skip)
#   BACKUP=1             snapshot existing .claude/ to .claude.bak-<ts>/ first
#   DEST=/path           install target (default: $PWD)
#   LOOPKIT_REF=<ref>    branch/tag to install from (default: main)
#   LOOPKIT_REPO=<r>     override source repo (default: Archive228/loopkit)
#   QUIET=1              silence per-file logging (still prints summary)
set -euo pipefail

REPO="${LOOPKIT_REPO:-Archive228/loopkit}"
REF="${LOOPKIT_REF:-main}"
DEST="${DEST:-$PWD}"
FORCE="${FORCE:-0}"
BACKUP="${BACKUP:-0}"
QUIET="${QUIET:-0}"

# --- pretty printing (falls back to plain on non-tty) --------------------------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_DIM=$'\033[2m'; C_BOLD=$'\033[1m'; C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'; C_RED=$'\033[31m'; C_CYAN=$'\033[36m'; C_RESET=$'\033[0m'
else
  C_DIM=""; C_BOLD=""; C_GREEN=""; C_YELLOW=""; C_RED=""; C_CYAN=""; C_RESET=""
fi

say()  { printf "%s\n" "$*"; }
step() { printf "${C_CYAN}==>${C_RESET} ${C_BOLD}%s${C_RESET}\n" "$*"; }
ok()   { printf "  ${C_GREEN}✓${C_RESET} %s\n" "$*"; }
skip() { [ "$QUIET" = "1" ] || printf "  ${C_DIM}·${C_RESET} ${C_DIM}%s${C_RESET}\n" "$*"; }
warn() { printf "  ${C_YELLOW}!${C_RESET} %s\n" "$*"; }
fail() { printf "${C_RED}xx${C_RESET} ${C_BOLD}%s${C_RESET}\n" "$*" >&2; }

# --- preflight ----------------------------------------------------------------
step "claude-loopkit installer"
say  "  repo   : ${C_BOLD}${REPO}${C_RESET}@${REF}"
say  "  dest   : ${C_BOLD}${DEST}${C_RESET}"
say  "  mode   : $([ "$FORCE" = "1" ] && echo overwrite || echo "skip-existing")$([ "$BACKUP" = "1" ] && echo " + backup" || echo "")"
say  ""

for cmd in curl tar mktemp find; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    fail "required command not found: $cmd"
    exit 1
  fi
done

if [ ! -d "$DEST" ]; then
  fail "DEST does not exist: $DEST"
  exit 1
fi

# --- backup existing .claude if requested -------------------------------------
if [ "$BACKUP" = "1" ] && [ -e "$DEST/.claude" ]; then
  ts=$(date +%Y%m%d-%H%M%S)
  bak="$DEST/.claude.bak-$ts"
  step "backing up existing .claude/"
  cp -R "$DEST/.claude" "$bak"
  ok "backup written to $bak"
  say ""
fi

# --- download tarball ---------------------------------------------------------
step "downloading loopkit"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

if ! curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF" \
     | tar -xz --strip-components=1 -C "$TMP"; then
  fail "download failed — check network and that $REPO@$REF exists"
  exit 1
fi
ok "extracted to $TMP"
say ""

# --- copy loop ----------------------------------------------------------------
wrote=0
skipped=0

copy_file() {
  src=$1
  dst=$2
  rel=${dst#"$DEST/"}
  if [ -e "$dst" ] && [ "$FORCE" != "1" ]; then
    skip "keep    $rel"
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  case "$src" in *.sh) chmod +x "$dst" ;; esac
  [ "$QUIET" = "1" ] || ok "write   $rel"
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

step "installing files"
copy_tree "$TMP/.claude" "$DEST/.claude"
copy_tree "$TMP/skills"  "$DEST/.claude/skills"
for f in .mcp.json MEMORY.md run.sh AGENTS.md; do
  [ -f "$TMP/$f" ] && copy_file "$TMP/$f" "$DEST/$f"
done
say ""

# --- summary ------------------------------------------------------------------
step "summary"
ok  "$wrote files written"
if [ "$skipped" -gt 0 ]; then
  warn "$skipped files kept (re-run with FORCE=1 to overwrite)"
fi
say ""

# --- verify claude cli --------------------------------------------------------
step "verifying claude CLI"
if command -v claude >/dev/null 2>&1; then
  claude_ver=$(claude --version 2>/dev/null | head -n1 || echo "unknown")
  ok "claude found: $claude_ver"
else
  warn "claude CLI not on PATH — skills will still work in Cursor/Codex/Gemini"
  warn "install Claude Code: https://claude.ai/download"
fi
say ""

# --- next steps ---------------------------------------------------------------
step "next"
say "  1. ${C_BOLD}cd $DEST${C_RESET}"
say "  2. open your agent (claude, cursor, codex, gemini)"
say "  3. write a spec:  ${C_DIM}echo 'STATUS: not-started' > IMPLEMENTATION_PLAN.md${C_RESET}"
say "  4. drive the loop: ${C_DIM}./run.sh${C_RESET}"
say ""
say "  full 33-skill list + docs: ${C_CYAN}https://github.com/$REPO${C_RESET}"
