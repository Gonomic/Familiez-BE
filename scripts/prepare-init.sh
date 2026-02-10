#!/usr/bin/env bash
set -euo pipefail
# Regenerate init/stored-procedures.sql from f*.sql and get*.sql files in this folder

cd "$(dirname "$0")/.." || exit 1

mkdir -p init
# Use numbered filename so docker runs schema before sprocs
outfile="init/02-stored-procedures.sql"

cat > "$outfile" <<'HEADER'
-- Combined stored procedures and functions
-- Source files: all files in this folder starting with 'f' or 'get'
-- Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
HEADER

shopt -s nullglob
files=(f*.sql get*.sql)
if [ ${#files[@]} -eq 0 ]; then
  echo "No matching files found"
  exit 0
fi

for f in "${files[@]}"; do
  echo >> "$outfile"
  echo "-- ===== FILE: $f =====" >> "$outfile"
  cat "$f" >> "$outfile"
done

echo "Wrote $outfile (files: ${#files[@]})"
