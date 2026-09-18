import unittest
from pathlib import Path
from tempfile import TemporaryDirectory

from versioning.scan_be_functions import scan


class ScanBeFunctionsTests(unittest.TestCase):
    def test_scans_parameter_modes_and_ignores_comments_and_literals(self):
        with TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "procedures.sql").write_text(
                """
DELIMITER $$
/* CREATE PROCEDURE ignored(IN fake INT) */
CREATE DEFINER=`svc`@`%` PROCEDURE `UpdatePerson`(
    IN `PersonIdIn` INT,
    OUT ResultOut VARCHAR(20),
    INOUT `ValueInOut` DECIMAL(10, 2)
)
    SQL SECURITY INVOKER
BEGIN
    SET ResultOut = 'CREATE PROCEDURE fake(IN ignored INT)';
END$$
DELIMITER ;
""",
                encoding="utf-8",
            )

            result = scan(root)

        self.assertEqual(result["diagnostics"], [])
        self.assertEqual(len(result["functions"]), 1)
        function = result["functions"][0]
        self.assertEqual(function["name"], "UpdatePerson")
        self.assertEqual(
            function["parameters"],
            [
                {"mode": "IN", "name": "PersonIdIn", "type": "INT"},
                {"mode": "OUT", "name": "ResultOut", "type": "VARCHAR(20)"},
                {"mode": "INOUT", "name": "ValueInOut", "type": "DECIMAL(10, 2)"},
            ],
        )
        self.assertTrue(function["signatureHash"].startswith("sha256:"))

    def test_reports_unclosed_parameter_list_without_crashing(self):
        with TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "broken.sql").write_text("CREATE PROCEDURE broken(IN value INT\nBEGIN\nEND;\n", encoding="utf-8")
            result = scan(root)

        self.assertEqual(result["functions"], [])
        self.assertEqual(result["diagnostics"][0]["error"], "UnclosedParameterList")

    def test_scan_is_deterministic_and_ignores_non_procedure_sql(self):
        with TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "tables.sql").write_text("CREATE TABLE example (id INT);\n", encoding="utf-8")
            (root / "a.sql").write_text(
                "CREATE PROCEDURE First(IN value INT) BEGIN SELECT value; END;\n",
                encoding="utf-8",
            )
            first = scan(root)
            second = scan(root)

        self.assertEqual(first, second)
        self.assertEqual([item["name"] for item in first["functions"]], ["First"])


if __name__ == "__main__":
    unittest.main()