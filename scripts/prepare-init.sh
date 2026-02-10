#!/usr/bin/env bash
set -euo pipefail
# Regenerate init/stored-procedures.sql from ALL .sql files containing CREATE PROCEDURE or CREATE FUNCTION

cd "$(dirname "$0")/.." || exit 1

mkdir -p init
# Use numbered filename prefix so docker runs schema before routines
outdir="init"

shopt -s nullglob
# Get all .sql files that contain CREATE PROCEDURE or CREATE FUNCTION (excluding humans*.sql)
mapfile -t files < <(
  grep -l "CREATE.*PROCEDURE\|CREATE.*FUNCTION" *.sql 2>/dev/null | \
  grep -v "^humans" | \
  grep -v "^InitialDB\.sql$" | \
  grep -v "^OnlyStructureSprocsAndFuncs" | \
  grep -v "^StructureDataSprocsAndFuncs" | \
  sort
)
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
rm -f "$outdir"/02-stored-procedures.sql
rm -f "$outdir"/02-*.sql

index=0
for f in "${sorted_files[@]}"; do
  out_file=$(printf "%s/02-%03d-%s" "$outdir" "$index" "$f")
  index=$((index + 1))

  cat > "$out_file" <<EOF
-- Generated from: $f
-- Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

  if grep -qi "^[[:space:]]*delimiter" "$f"; then
    # Keep file delimiters as-is to preserve multi-routine files.
    sed 's/DEFINER=[^ ]* //g' "$f" | \
      sed 's/END\$\$\$[[:space:]]*$/END$$/g' | \
      awk '
        BEGIN { delim = ";" }
        /^[[:space:]]*DELIMITER[[:space:]]*\$\$/ { delim = "$$"; print; next }
        /^[[:space:]]*DELIMITER[[:space:]]*;/ { delim = ";"; print; next }
        /^[[:space:]]*CREATE[[:space:]]+(PROCEDURE|FUNCTION)[[:space:]]+/ {
          line = $0
          type = (line ~ /PROCEDURE/) ? "PROCEDURE" : "FUNCTION"
          sub(/^[[:space:]]*CREATE[[:space:]]+(PROCEDURE|FUNCTION)[[:space:]]+/, "", line)
          gsub(/`/, "", line)
          split(line, parts, /[ (]/)
          name = parts[1]
          if (name != "") {
            drop = "DROP " type " IF EXISTS `" name "`"
            if (delim == "$$") {
              drop = drop "$$"
            } else {
              drop = drop ";"
            }
            print drop
          }
        }
        { print }
      ' >> "$out_file"
  else
    # No delimiters: wrap the routine and normalize the final END.
    echo "DELIMITER \$\$" >> "$out_file"
    sed 's/DEFINER=[^ ]* //g' "$f" | \
      sed 's/END\$\$\$[[:space:]]*$/END$$/g' | \
      awk '
        { lines[NR] = $0 }
        END {
          last_end = 0
          last_end_is_dollar = 0
          for (i = 1; i <= NR; i++) {
            if (lines[i] ~ /^[[:space:]]*END\$\$[[:space:]]*$/ ||
                lines[i] ~ /^[[:space:]]*END;[[:space:]]*$/ ||
                lines[i] ~ /^[[:space:]]*END[[:space:]]*$/) {
              last_end = i
              last_end_is_dollar = (lines[i] ~ /^[[:space:]]*END\$\$[[:space:]]*$/)
            }
          }
          for (i = 1; i <= NR; i++) {
            if (i != last_end && lines[i] ~ /^[[:space:]]*END\$\$[[:space:]]*$/) {
              continue
            }
            if (!last_end_is_dollar && i == last_end && lines[i] ~ /^[[:space:]]*END;*[[:space:]]*$/) {
              sub(/END;*[[:space:]]*$/, "END$$", lines[i])
            }
            if (lines[i] ~ /^[[:space:]]*CREATE[[:space:]]+(PROCEDURE|FUNCTION)[[:space:]]+/) {
              line = lines[i]
              type = (line ~ /PROCEDURE/) ? "PROCEDURE" : "FUNCTION"
              sub(/^[[:space:]]*CREATE[[:space:]]+(PROCEDURE|FUNCTION)[[:space:]]+/, "", line)
              gsub(/`/, "", line)
              split(line, parts, /[ (]/)
              name = parts[1]
              if (name != "") {
                print "DROP " type " IF EXISTS `" name "`$$"
              }
            }
            print lines[i]
          }
        }
      ' >> "$out_file"
    echo "DELIMITER ;" >> "$out_file"
  fi
done

echo "Wrote $outdir/02-*.sql (files: ${#files[@]})"
