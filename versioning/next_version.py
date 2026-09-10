"""Compute the next DB/BE manifest version by feeding the shared bump-engine
with the previous manifest's functions/version and commits since then."""

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence

from versioning.scan_be_functions import scan


COMPONENT = "DB"
DEFAULT_BUMP_ENGINE = Path(__file__).resolve().parents[2] / "Deploy" / "versioning" / "bump_engine.py"


def _commits_since(commit: Optional[str]) -> List[str]:
    if not commit:
        return []
    try:
        output = subprocess.run(
            ["git", "log", f"{commit}..HEAD", "--format=%B%x00"],
            check=True, capture_output=True, text=True,
        ).stdout
    except subprocess.CalledProcessError:
        return []
    return [message.strip() for message in output.split("\x00") if message.strip()]


def compute_next_version(
    root: Path,
    manifest_path: Path,
    bump_engine: Path = DEFAULT_BUMP_ENGINE,
) -> Dict[str, Any]:
    if not manifest_path.exists():
        raise ValueError(f"No previous manifest found at {manifest_path}; bootstrap it manually first")
    previous_manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    previous_version = previous_manifest.get("version")
    if not previous_version:
        raise ValueError(f"No version found in {manifest_path}")
    if not bump_engine.exists():
        raise ValueError(f"bump_engine.py not found at {bump_engine}; pass --bump-engine explicitly")

    payload = {
        "components": {
            COMPONENT: {
                "version": previous_version,
                "previousFunctions": previous_manifest.get("functions", []),
                "currentFunctions": scan(root)["functions"],
                "commits": _commits_since(previous_manifest.get("sourceCommit")),
            }
        }
    }
    result = subprocess.run(
        [sys.executable, str(bump_engine)],
        input=json.dumps(payload),
        capture_output=True,
        text=True,
    )
    try:
        proposal = json.loads(result.stdout)
    except json.JSONDecodeError as error:
        raise RuntimeError(
            f"bump_engine did not return valid JSON: {result.stderr.strip() or result.stdout.strip()}"
        ) from error
    return proposal["components"][COMPONENT]


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path("."))
    parser.add_argument("--manifest", type=Path, default=Path("versioning/manifest.json"))
    parser.add_argument("--bump-engine", type=Path, default=DEFAULT_BUMP_ENGINE)
    args = parser.parse_args(argv)
    proposal = compute_next_version(args.root.resolve(), args.manifest, args.bump_engine)
    json.dump(proposal, sys.stdout, indent=2, sort_keys=True)
    sys.stdout.write("\n")
    if proposal["status"] == "manual_review":
        return 3
    if proposal["status"] == "invalid_input":
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
