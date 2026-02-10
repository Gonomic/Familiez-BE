#!/usr/bin/env bash
set -euo pipefail
# Regenerate init/schema.sql from files starting with "humans"

cd "$(dirname "$0")/.." || exit 1

mkdir -p init
# Use numbered filename so docker runs schema before sprocs
outfile="init/01-schema.sql"

cat > "$outfile" <<'HEADER'
-- Combined schema from files starting with 'humans'
-- Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
HEADER

shopt -s nullglob
files=(humans*.sql)
if [ ${#files[@]} -eq 0 ]; then
  echo "No matching 'humans' files found"
  exit 0
fi

for f in "${files[@]}"; do
  echo >> "$outfile"
  echo "-- ===== FILE: $f =====" >> "$outfile"
  # Replace MySQL 8 collations with MariaDB-compatible ones
  sed -n '1,99999p' "$f" | sed 's/utf8mb4_0900_ai_ci/utf8mb4_unicode_ci/g' >> "$outfile"
done

echo "Wrote $outfile (files: ${#files[@]})"
