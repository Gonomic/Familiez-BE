"""Generate the database component manifest from the local procedure scanner."""

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Optional, Sequence

from versioning.next_version import compute_next_version
from versioning.scan_be_functions import scan


COMPONENT = "DB"
DEFAULT_VERSION = "1.0.0"
VERSION_PREFIX = "familiez-db:"


def _source_commit() -> str:
    return subprocess.run(
        ["git", "rev-parse", "HEAD"], check=True, capture_output=True, text=True
    ).stdout.strip()


def _generated_at() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def _valid_version(version: str) -> bool:
    parts = version.split(".")
    return len(parts) == 3 and all(part.isdigit() and int(part) >= 0 for part in parts)


def build_manifest(root: Path, version: str = DEFAULT_VERSION, source_commit: Optional[str] = None,
                   generated_at: Optional[str] = None) -> Dict[str, Any]:
    if not _valid_version(version):
        raise ValueError(f"Invalid component version: {version}")
    result = scan(root)
    if result["diagnostics"]:
        raise ValueError(f"Scanner diagnostics present: {result['diagnostics']}")
    return {
        "component": COMPONENT,
        "version": version,
        "dockerImageTag": VERSION_PREFIX + version,
        "generatedAt": generated_at or _generated_at(),
        "sourceCommit": source_commit or _source_commit(),
        "functions": result["functions"],
    }


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path("."))
    parser.add_argument("--version", default=None)
    parser.add_argument("--source-commit")
    parser.add_argument("--generated-at")
    parser.add_argument("--output", type=Path, default=Path("versioning/manifest.json"))
    args = parser.parse_args(argv)
    version = args.version
    if version is None:
        if args.output.exists():
            proposal = compute_next_version(args.root.resolve(), args.output)
            if proposal["status"] != "ok":
                print(
                    f"Bump engine requires manual review, refusing to auto-generate: {proposal}",
                    file=sys.stderr,
                )
                return 3 if proposal["status"] == "manual_review" else 2
            version = proposal["to"]
            print(
                f"Bump engine proposes {proposal['from']} -> {version} "
                f"({proposal['bump']}: {', '.join(proposal.get('reasons', []))})"
            )
        else:
            version = DEFAULT_VERSION
            print(f"No previous manifest found; bootstrapping at {DEFAULT_VERSION}")
    manifest = build_manifest(args.root.resolve(), version, args.source_commit, args.generated_at)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())