"""Scan MariaDB stored-procedure signatures without connecting to a database."""

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Sequence, Tuple


EXCLUDED_DIRECTORIES = {".git", ".pytest_cache", "__pycache__", ".venv"}
PROCEDURE_RE = re.compile(
    r"\bCREATE\s+(?:(?:DEFINER\s*=\s*[^\s]+)\s+)?PROCEDURE\s+"
    r"(?P<name>`[^`]+`|[A-Za-z_][A-Za-z0-9_$]*)\s*\(",
    re.IGNORECASE,
)
WORD_RE = re.compile(r"\bBEGIN\b", re.IGNORECASE)
PARAMETER_MODE_RE = re.compile(r"^(INOUT|OUT|IN)\b\s*", re.IGNORECASE)
IDENTIFIER_RE = re.compile(r"^(?P<name>`[^`]+`|[A-Za-z_][A-Za-z0-9_$]*)\s+(?P<type>.+)$", re.IGNORECASE | re.DOTALL)


def _mask_code(source: str) -> str:
    """Blank comments and quoted literals while preserving positions/newlines."""
    chars = list(source)
    index = 0
    state = "code"
    while index < len(source):
        current = source[index]
        following = source[index + 1] if index + 1 < len(source) else ""
        if state == "code":
            if current == "'":
                state = "single"
                chars[index] = " "
            elif current == '"':
                state = "double"
                chars[index] = " "
            elif current == "-" and following == "-":
                state = "line_comment"
                chars[index] = chars[index + 1] = " "
                index += 1
            elif current == "#":
                state = "line_comment"
                chars[index] = " "
            elif current == "/" and following == "*":
                state = "block_comment"
                chars[index] = chars[index + 1] = " "
                index += 1
        elif state == "line_comment":
            if current == "\n":
                state = "code"
            else:
                chars[index] = " "
        elif state == "block_comment":
            if current == "*" and following == "/":
                chars[index] = chars[index + 1] = " "
                index += 1
                state = "code"
            elif current != "\n":
                chars[index] = " "
        elif state in {"single", "double"}:
            quote = "'" if state == "single" else '"'
            if current == "\\":
                chars[index] = " "
                if index + 1 < len(source) and source[index + 1] != "\n":
                    chars[index + 1] = " "
                    index += 1
            elif current == quote:
                chars[index] = " "
                if index + 1 < len(source) and source[index + 1] == quote:
                    chars[index + 1] = " "
                    index += 1
                else:
                    state = "code"
            elif current != "\n":
                chars[index] = " "
        index += 1
    return "".join(chars)


def _matching_parenthesis(masked: str, opening: int) -> Optional[int]:
    depth = 0
    for index in range(opening, len(masked)):
        if masked[index] == "(":
            depth += 1
        elif masked[index] == ")":
            depth -= 1
            if depth == 0:
                return index
    return None


def _split_parameters(raw: str) -> List[str]:
    parts: List[str] = []
    start = 0
    depth = 0
    quote: Optional[str] = None
    for index, character in enumerate(raw):
        if quote:
            if character == quote:
                quote = None
        elif character in {"'", '"', "`"}:
            quote = character
        elif character == "(":
            depth += 1
        elif character == ")":
            depth -= 1
        elif character == "," and depth == 0:
            parts.append(raw[start:index].strip())
            start = index + 1
    final = raw[start:].strip()
    if final:
        parts.append(final)
    return parts


def _clean_identifier(identifier: str) -> str:
    return identifier[1:-1] if identifier.startswith("`") and identifier.endswith("`") else identifier


def _parse_parameter(raw: str) -> Dict[str, Any]:
    text = " ".join(raw.split())
    mode_match = PARAMETER_MODE_RE.match(text)
    mode = mode_match.group(1).upper() if mode_match else "IN"
    remainder = text[mode_match.end():].strip() if mode_match else text
    identifier_match = IDENTIFIER_RE.match(remainder)
    if identifier_match is None:
        return {"mode": mode, "name": "<unparsed>", "type": remainder}
    return {
        "mode": mode,
        "name": _clean_identifier(identifier_match.group("name")),
        "type": identifier_match.group("type").strip(),
    }


def _signature_hash(name: str, parameters: List[Dict[str, Any]]) -> str:
    canonical = json.dumps(
        {"name": name, "parameters": parameters},
        ensure_ascii=True,
        sort_keys=True,
        separators=(",", ":"),
    )
    return "sha256:" + hashlib.sha256(canonical.encode("utf-8")).hexdigest()


def _scan_file(path: Path, root: Path) -> Tuple[List[Dict[str, Any]], List[Dict[str, Any]]]:
    relative_path = path.relative_to(root).as_posix()
    diagnostics: List[Dict[str, Any]] = []
    try:
        source = path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        return [], [{"file": relative_path, "error": type(error).__name__, "message": str(error)}]

    masked = _mask_code(source)
    procedures: List[Dict[str, Any]] = []
    for match in PROCEDURE_RE.finditer(masked):
        closing = _matching_parenthesis(masked, match.end() - 1)
        if closing is None:
            diagnostics.append(
                {"file": relative_path, "line": source.count("\n", 0, match.start()) + 1, "error": "UnclosedParameterList"}
            )
            continue
        name = _clean_identifier(match.group("name"))
        parameters = [_parse_parameter(item) for item in _split_parameters(source[match.end():closing])]
        body_match = WORD_RE.search(masked, closing + 1)
        if body_match is None:
            diagnostics.append(
                {"file": relative_path, "line": source.count("\n", 0, match.start()) + 1, "error": "MissingBegin"}
            )
        procedures.append(
            {
                "layer": "BE",
                "name": name,
                "file": relative_path,
                "line": source.count("\n", 0, match.start()) + 1,
                "parameters": parameters,
                "signatureHash": _signature_hash(name, parameters),
            }
        )
    return procedures, diagnostics


def _sql_files(root: Path) -> Iterable[Path]:
    for path in sorted(root.rglob("*")):
        if path.is_file() and path.suffix.lower() in {".sql", ".ddl"}:
            if not any(part in EXCLUDED_DIRECTORIES for part in path.parts):
                yield path


def scan(root: Path) -> Dict[str, Any]:
    functions: List[Dict[str, Any]] = []
    diagnostics: List[Dict[str, Any]] = []
    for path in _sql_files(root):
        found, issues = _scan_file(path, root)
        functions.extend(found)
        diagnostics.extend(issues)
    functions.sort(key=lambda item: (item["file"], item["line"], item["name"]))
    diagnostics.sort(key=lambda item: (item["file"], item.get("line", 0)))
    return {"component": "BE", "functions": functions, "diagnostics": diagnostics}


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", default=".", type=Path, help="Directory to scan")
    args = parser.parse_args(argv)
    result = scan(args.root.resolve())
    json.dump(result, sys.stdout, ensure_ascii=True, indent=2, sort_keys=True)
    sys.stdout.write("\n")
    return 0 if not result["diagnostics"] else 1


if __name__ == "__main__":
    raise SystemExit(main())