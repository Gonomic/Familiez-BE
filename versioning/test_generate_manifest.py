import unittest
from pathlib import Path

from versioning.generate_manifest import build_manifest


class GenerateManifestTests(unittest.TestCase):
    def test_manifest_contract_is_deterministic_when_metadata_is_injected(self):
        first = build_manifest(Path("."), source_commit="abc123", generated_at="2026-09-10T00:00:00Z")
        second = build_manifest(Path("."), source_commit="abc123", generated_at="2026-09-10T00:00:00Z")
        self.assertEqual(first, second)
        self.assertEqual(first["component"], "DB")
        self.assertEqual(first["version"], "1.0.0")
        self.assertEqual(first["dockerImageTag"], "familiez-db:1.0.0")
        self.assertGreater(len(first["functions"]), 0)

    def test_invalid_version_is_rejected(self):
        with self.assertRaises(ValueError):
            build_manifest(Path("."), version="1.0")


if __name__ == "__main__":
    unittest.main()