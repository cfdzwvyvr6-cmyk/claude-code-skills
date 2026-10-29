#!/bin/bash
# Installs jmo-skills, then this repository's skills, into ~/.claude/skills.
# This repository's skills are copied last, so its /interview replaces the jmo-skills one.
# Usage: bash install.sh            (from a clone of this repository)
#    or: curl -fsSL <raw url of install.sh> | DISCOVERY_REPO=<git url> bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
JMO_REPO="https://github.com/23jmo/jmo-skills"
DISCOVERY_REPO="${DISCOVERY_REPO:-}"  # e.g. https://github.com/cfdzwvyvr6-cmyk/claude-code-skills
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$SKILLS_DIR"

GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 1 "$JMO_REPO" "$TMP/jmo-skills"
cp -r "$TMP/jmo-skills/skills/"* "$SKILLS_DIR/"

if [ -n "$DISCOVERY_REPO" ]; then
  GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 1 "$DISCOVERY_REPO" "$TMP/discovery-skills"
  SRC="$TMP/discovery-skills"
else
  SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
cp -r "$SRC/skills/"* "$SKILLS_DIR/"

echo "Installed skills in $SKILLS_DIR:"
ls "$SKILLS_DIR"
