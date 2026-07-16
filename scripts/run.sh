#!/usr/bin/env bash
# Local run with secrets from .env (not bundled as assets).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  echo "Missing .env — copy .env.example and fill in keys:" >&2
  echo "  cp .env.example .env" >&2
  exit 1
fi

exec flutter run --dart-define-from-file=.env "$@"
