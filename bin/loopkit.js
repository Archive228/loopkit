#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');

const args = process.argv.slice(2);
const cmd = args[0];
const FORCE = args.includes('--force');
const DRY = args.includes('--dry-run');
const HELP = args.includes('-h') || args.includes('--help');
const VERSION = args.includes('--version');

function help() {
  console.log(`claude-loopkit — drop-in .claude/ harness + 33 skills

Usage:
  npx claude-loopkit init [--force] [--dry-run]
  npx claude-loopkit --version

init copies into the current directory:
  .claude/CLAUDE.md
  .claude/settings.json
  .claude/agents/verifier.md
  .claude/skills/<33 skill dirs>
  .mcp.json
  MEMORY.md
  run.sh

Existing files are kept by default. Pass --force to overwrite,
or --dry-run to see what would change without writing.

Repo: https://github.com/Archive228/loopkit`);
}

if (VERSION) {
  console.log(require('../package.json').version);
  process.exit(0);
}

if (HELP) {
  help();
  process.exit(0);
}

if (!cmd) {
  help();
  process.exit(1);
}

if (cmd !== 'init') {
  console.error(`Unknown command: ${cmd}\n`);
  help();
  process.exit(1);
}

const PKG_ROOT = path.resolve(__dirname, '..');
const CWD = process.cwd();

const COPY = [
  ['.claude', '.claude'],
  ['skills', '.claude/skills'],
  ['.mcp.json', '.mcp.json'],
  ['MEMORY.md', 'MEMORY.md'],
  ['run.sh', 'run.sh'],
];

let wrote = 0;
let skipped = 0;
const plan = [];

function walk(srcAbs, dstAbs) {
  const st = fs.statSync(srcAbs);
  if (st.isDirectory()) {
    if (!DRY) fs.mkdirSync(dstAbs, { recursive: true });
    for (const entry of fs.readdirSync(srcAbs)) {
      walk(path.join(srcAbs, entry), path.join(dstAbs, entry));
    }
    return;
  }
  const exists = fs.existsSync(dstAbs);
  if (exists && !FORCE) {
    skipped++;
    plan.push(['skip', dstAbs]);
    return;
  }
  plan.push([exists ? 'overwrite' : 'write', dstAbs]);
  if (!DRY) {
    fs.mkdirSync(path.dirname(dstAbs), { recursive: true });
    fs.copyFileSync(srcAbs, dstAbs);
    if (srcAbs.endsWith('.sh')) fs.chmodSync(dstAbs, 0o755);
  }
  wrote++;
}

for (const [from, to] of COPY) {
  const src = path.join(PKG_ROOT, from);
  if (!fs.existsSync(src)) continue;
  walk(src, path.join(CWD, to));
}

const rel = p => path.relative(CWD, p) || '.';

if (DRY) {
  for (const [verb, p] of plan) {
    console.log(`${verb.padEnd(9)} ${rel(p)}`);
  }
  console.log(`\n[dry-run] ${wrote} would be written, ${skipped} would be skipped`);
  process.exit(0);
}

console.log(`claude-loopkit: init complete`);
console.log(`  ${wrote} files written, ${skipped} skipped${skipped ? ' (use --force to overwrite)' : ''}`);
console.log(`  installed into ${CWD}`);
console.log();
console.log(`Next: open Claude Code in this directory. Skills load on relevant triggers.`);
console.log(`Docs and full 33-skill list: https://github.com/Archive228/loopkit`);
