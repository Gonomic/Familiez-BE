import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch

from versioning.next_version import compute_next_version


class ComputeNextVersionTests(unittest.TestCase):
    def setUp(self):
        self.tmp_dir = tempfile.TemporaryDirectory()
        self.bump_engine_stub = Path(self.tmp_dir.name) / "bump_engine.py"
        self.bump_engine_stub.write_text("", encoding="utf-8")

    def tearDown(self):
        self.tmp_dir.cleanup()

    def test_raises_when_no_previous_manifest(self):
        with self.assertRaises(ValueError):
            compute_next_version(Path("."), Path(self.tmp_dir.name) / "missing.json", self.bump_engine_stub)

    @patch("versioning.next_version.scan")
    @patch("versioning.next_version.subprocess.run")
    def test_returns_bump_engine_proposal(self, mock_run, mock_scan):
        manifest_path = Path(self.tmp_dir.name) / "manifest.json"
        manifest_path.write_text(json.dumps({
            "version": "1.0.0",
            "sourceCommit": "abc123",
            "functions": [{"name": "foo", "signatureHash": "sha256:aaa"}],
        }), encoding="utf-8")
        mock_scan.return_value = {"functions": [{"name": "foo", "signatureHash": "sha256:bbb"}]}
        mock_run.return_value = MagicMock(stdout=json.dumps({
            "components": {
                "DB": {
                    "status": "ok",
                    "from": "1.0.0",
                    "to": "2.0.0",
                    "bump": "major",
                    "reasons": ["public signature hash changed"],
                }
            }
        }), stderr="")
        result = compute_next_version(Path("."), manifest_path, self.bump_engine_stub)
        self.assertEqual(result["to"], "2.0.0")

    def test_raises_when_bump_engine_missing(self):
        manifest_path = Path(self.tmp_dir.name) / "manifest.json"
        manifest_path.write_text(json.dumps({"version": "1.0.0", "functions": []}), encoding="utf-8")
        with self.assertRaises(ValueError):
            compute_next_version(Path("."), manifest_path, Path("/nonexistent/bump_engine.py"))


if __name__ == "__main__":
    unittest.main()
