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

# Ensure getTranNo loads first as other functions depend on it
sorted_files=()
for f in "${files[@]}"; do
  if [[ "$f" == "getTranNo.sql" ]]; then
    sorted_files=("$f" "${sorted_files[@]}")
  else
    sorted_files+=("$f")
  fi
done

# Write header
cat > "$outfile" << 'EOF'
-- Combined stored procedures and functions
-- Source files: all files in this folder starting with 'f' or 'get'
-- Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

DELIMITER $$

EOF

for f in "${sorted_files[@]}"; do
  echo >> "$outfile"
  echo "-- ===== FILE: $f =====" >> "$outfile"
  
  # Process: remove DEFINER, strip DELIMITER lines
  # Use tac to work from end: convert only the first (=last in original) bare END to END$$
  cat "$f" | \
    sed 's/DEFINER=[^ ]* //g' | \
    grep -v "^DELIMITER" | \
    tac | \
    awk 'BEGIN {fixed=0} 
         /^[[:space:]]*END[[:space:]]*$/ && fixed==0 {sub(/END[[:space:]]*$/, "END$$"); fixed=1}
         /^[[:space:]]*END;[[:space:]]*$/ && fixed==0 {sub(/END;[[:space:]]*$/, "END$$"); fixed=1}
         {print}' | \
    tac >> "$outfile"
done

echo >> "$outfile"
echo "DELIMITER ;" >> "$outfile"

rm -f /tmp/clean_func.sql

echo "Wrote $outfile (files: ${#files[@]})"
