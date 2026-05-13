#!/usr/bin/env bash
set -euo pipefail

CODENAME=""
COMPONENT="main"
ARCH="amd64"
GPG_KEY=""
INCOMING=""
OUT=""

usage() {
  cat <<'EOF'
Usage: publish.sh --codename <codename> --gpg-key <KEYID> --incoming <dir> --out <dir> [--component main] [--arch amd64]

Example:
  ./publish.sh --codename soryos-26.04 --gpg-key ABCD1234... --incoming ./incoming --out ./public
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --codename) CODENAME="$2"; shift 2;;
    --component) COMPONENT="$2"; shift 2;;
    --arch) ARCH="$2"; shift 2;;
    --gpg-key) GPG_KEY="$2"; shift 2;;
    --incoming) INCOMING="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 2;;
  esac
done

if [ -z "$CODENAME" ] || [ -z "$GPG_KEY" ] || [ -z "$INCOMING" ] || [ -z "$OUT" ]; then
  usage
  exit 2
fi

command -v aptly >/dev/null || { echo "aptly is required (sudo apt-get install aptly)"; exit 1; }
command -v gpg >/dev/null || { echo "gpg is required"; exit 1; }

if [ ! -d "$INCOMING" ]; then
  echo "Incoming dir not found: $INCOMING"
  exit 1
fi

mkdir -p "$OUT"

# Use a local aptly root inside the repo.
APTLY_ROOT="$(pwd)/.aptly"
mkdir -p "$APTLY_ROOT"

REPO_NAME="soryos"

if ! aptly -config=/dev/null -rootDir="$APTLY_ROOT" repo show "$REPO_NAME" >/dev/null 2>&1; then
  aptly -config=/dev/null -rootDir="$APTLY_ROOT" repo create \
    -distribution="$CODENAME" \
    -component="$COMPONENT" \
    "$REPO_NAME"
fi

shopt -s nullglob
DEBS=("$INCOMING"/*.deb)
if [ ${#DEBS[@]} -eq 0 ]; then
  echo "No .deb files found in $INCOMING"
  exit 1
fi

aptly -config=/dev/null -rootDir="$APTLY_ROOT" repo add "$REPO_NAME" "$INCOMING"

aptly -config=/dev/null -rootDir="$APTLY_ROOT" publish \
  -batch=true \
  -gpg-key="$GPG_KEY" \
  -architectures="$ARCH" \
  repo "$REPO_NAME" filesystem:"$OUT":.

echo "Published to $OUT"
