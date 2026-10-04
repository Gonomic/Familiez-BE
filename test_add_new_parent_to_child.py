"""Opt-in integration tests for the parent-creation routines on dev."""

import ipaddress
import os
import unittest
import uuid
from pathlib import Path


@unittest.skipUnless(
    os.getenv("FAMILIEZ_RUN_DB_TESTS") == "1",
    "Set FAMILIEZ_RUN_DB_TESTS=1 in the local BE .env to run dev database tests",
)
class AddNewParentToChildDatabaseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from dotenv import dotenv_values
        import pymysql

        family_root = Path(__file__).resolve().parents[1]
        config_path = family_root / "Deploy" / "synology" / "deploy.env"
        config = dotenv_values(config_path)
        database_host = config.get("DEV_DB_HOST")
        database_name = config.get("DEV_DB_NAME")

        try:
            is_loopback = database_host == "localhost" or ipaddress.ip_address(database_host).is_loopback
        except (ValueError, TypeError):
            is_loopback = False
        if not is_loopback or database_name != "humans":
            raise RuntimeError("Refusing DB tests unless DEV_DB_HOST is loopback and DEV_DB_NAME is humans")

        cls.connection = pymysql.connect(
            host=database_host,
            port=int(config.get("DEV_DB_PORT", 3306)),
            user=config["DEV_DB_USER"],
            password=config["DEV_DB_PASSWORD"],
            database=database_name,
            connect_timeout=5,
            autocommit=True,
        )
        with cls.connection.cursor() as cursor:
            cursor.execute("SELECT DATABASE()")
            actual_database = cursor.fetchone()[0]
        if actual_database != "humans":
            cls.connection.close()
            raise RuntimeError(f"Refusing DB tests against unexpected database {actual_database!r}")

    @classmethod
    def tearDownClass(cls):
        cls.connection.close()

    def setUp(self):
        self.person_ids = []
        self.token = uuid.uuid4().hex[:8]
        self.family_name = f"DbTest{self.token}"

    def tearDown(self):
        if not self.person_ids:
            return

        placeholders = ",".join(["%s"] * len(self.person_ids))
        with self.connection.cursor() as cursor:
            cursor.execute(
                f"DELETE FROM humans.marriages WHERE PartnerAID IN ({placeholders}) OR PartnerBID IN ({placeholders})",
                self.person_ids + self.person_ids,
            )
            cursor.execute(
                f"DELETE FROM humans.relations WHERE RelationPerson IN ({placeholders}) OR RelationWithPerson IN ({placeholders})",
                self.person_ids + self.person_ids,
            )
            cursor.execute(
                f"DELETE FROM humans.persons WHERE PersonID IN ({placeholders})",
                self.person_ids,
            )

    def _create_person(self, gender, given_name=None):
        given_name = given_name or f"Db{self.token}{len(self.person_ids)}"
        with self.connection.cursor() as cursor:
            cursor.execute(
                """INSERT INTO humans.persons (
                       PersonGivvenName, PersonFamilyName, PersonDateOfBirth,
                       PersonPlaceOfBirth, PersonIsMale, PersonDateOfBirthStatus
                   ) VALUES (%s, %s, '1900-01-01', 'Testplaats', %s, 1)""",
                (given_name, self.family_name, gender),
            )
            person_id = cursor.lastrowid
        self.person_ids.append(person_id)
        return person_id

    def _call_sproc(
        self,
        child_id,
        gender,
        given_name,
        partner_id=None,
        marriage_date=None,
        marriage_place=None,
    ):
        with self.connection.cursor() as cursor:
            cursor.execute(
                "CALL AddNewParentToChild(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (
                    child_id,
                    gender,
                    given_name,
                    self.family_name,
                    "1890-02-03",
                    "Testgeboorteplaats",
                    None,
                    None,
                    partner_id,
                    marriage_date,
                    marriage_place,
                ),
            )
            columns = [column[0] for column in cursor.description]
            row = cursor.fetchone()
            result = dict(zip(columns, row)) if row else {}
            while cursor.nextset():
                cursor.fetchall()

        if result.get("NewPersonID") is not None:
            self.person_ids.append(result["NewPersonID"])
        return result

    def _scalar(self, query, parameters):
        with self.connection.cursor() as cursor:
            cursor.execute(query, parameters)
            return cursor.fetchone()[0]

    def test_missing_child_id_returns_validation_result(self):
        result = self._call_sproc(None, 1, "TestVader")

        self.assertEqual(result["CompletedOk"], 1)
        self.assertEqual(result["Result"], 400)
        self.assertIsNone(result["NewPersonID"])

    def test_identity_function_matches_all_fields_including_gender(self):
        person_id = self._create_person(1, "IdentityTest")

        self.assertEqual(
            self._scalar(
                "SELECT fPersonExistsByIdentity(%s, %s, %s, %s)",
                (1, "IdentityTest", self.family_name, "1900-01-01"),
            ),
            1,
        )
        self.assertEqual(
            self._scalar(
                "SELECT fPersonExistsByIdentity(%s, %s, %s, %s)",
                (0, "IdentityTest", self.family_name, "1900-01-01"),
            ),
            0,
        )
        self.assertIn(person_id, self.person_ids)

    def test_duplicate_parent_identity_is_rejected_without_second_insert(self):
        child_id = self._create_person(0)
        parent_name = f"Parent{self.token}"
        first = self._call_sproc(child_id, 1, parent_name)
        duplicate = self._call_sproc(child_id, 1, parent_name)

        self.assertEqual(first["CompletedOk"], 0)
        self.assertEqual(duplicate["CompletedOk"], 1)
        self.assertEqual(duplicate["Result"], 409)
        self.assertEqual(
            duplicate["ErrorMessage"],
            "De toe te voegen Vader bestaat al als persoon in de database.",
        )
        self.assertEqual(
            self._scalar(
                "SELECT COUNT(*) FROM humans.persons WHERE PersonIsMale=1 AND PersonGivvenName=%s AND PersonFamilyName=%s AND PersonDateOfBirth='1890-02-03'",
                (parent_name, self.family_name),
            ),
            1,
        )

    def test_same_identity_with_other_gender_is_not_a_duplicate(self):
        child_id = self._create_person(0)
        parent_name = f"Parent{self.token}"

        father = self._call_sproc(child_id, 1, parent_name)
        mother = self._call_sproc(child_id, 0, parent_name)

        self.assertEqual(father["CompletedOk"], 0)
        self.assertEqual(mother["CompletedOk"], 0)
        self.assertNotEqual(father["NewPersonID"], mother["NewPersonID"])
        self.assertEqual(
            self._scalar(
                "SELECT COUNT(*) FROM humans.relations WHERE RelationPerson=%s AND RelationWithPerson=%s AND RelationName=2",
                (child_id, mother["NewPersonID"]),
            ),
            1,
        )

    def test_free_partner_creates_parent_relationship_and_marriage(self):
        child_id = self._create_person(0)
        partner_id = self._create_person(0)

        result = self._call_sproc(
            child_id,
            1,
            f"Parent{self.token}",
            partner_id=partner_id,
            marriage_date="1942-07-08",
            marriage_place=" Testplaats huwelijk ",
        )
        new_parent_id = result["NewPersonID"]

        self.assertEqual(result["CompletedOk"], 0)
        self.assertEqual(result["Result"], 200)
        self.assertIsNone(result["ErrorMessage"])
        self.assertEqual(
            self._scalar(
                "SELECT COUNT(*) FROM humans.relations WHERE RelationPerson=%s AND RelationWithPerson=%s AND RelationName=1",
                (child_id, new_parent_id),
            ),
            1,
        )
        self.assertEqual(
            self._scalar(
                "SELECT COUNT(*) FROM humans.relations WHERE RelationName=3 AND ((RelationPerson=%s AND RelationWithPerson=%s) OR (RelationPerson=%s AND RelationWithPerson=%s))",
                (new_parent_id, partner_id, partner_id, new_parent_id),
            ),
            2,
        )
        self.assertEqual(
            self._scalar(
                "SELECT COUNT(*) FROM humans.relations WHERE RelationPerson=%s AND RelationWithPerson=%s AND RelationName=2",
                (child_id, partner_id),
            ),
            1,
        )
        self.assertEqual(
            self._scalar(
                "SELECT COUNT(*) FROM humans.marriages WHERE PartnerAID=%s AND PartnerBID=%s AND StartDate=%s AND MarriagePlace=%s",
                (min(new_parent_id, partner_id), max(new_parent_id, partner_id), "1942-07-08", "Testplaats huwelijk"),
            ),
            1,
        )

    def test_partner_without_marriage_date_does_not_create_marriage(self):
        child_id = self._create_person(0)
        partner_id = self._create_person(1)

        result = self._call_sproc(
            child_id,
            0,
            f"Parent{self.token}",
            partner_id=partner_id,
        )

        self.assertEqual(result["CompletedOk"], 0)
        self.assertEqual(
            self._scalar(
                "SELECT COUNT(*) FROM humans.marriages WHERE PartnerAID=%s AND PartnerBID=%s",
                (min(result["NewPersonID"], partner_id), max(result["NewPersonID"], partner_id)),
            ),
            0,
        )

    def test_partner_relation_is_not_duplicated_as_parent(self):
        child_id = self._create_person(0)
        partner_id = self._create_person(0)
        with self.connection.cursor() as cursor:
            cursor.execute(
                "INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson) VALUES (2, %s, %s)",
                (child_id, partner_id),
            )

        result = self._call_sproc(child_id, 1, f"Parent{self.token}", partner_id=partner_id)

        self.assertEqual(result["CompletedOk"], 0)
        self.assertEqual(
            self._scalar(
                "SELECT COUNT(*) FROM humans.relations WHERE RelationPerson=%s AND RelationWithPerson=%s AND RelationName=2",
                (child_id, partner_id),
            ),
            1,
        )

    def test_partner_with_existing_relationship_in_either_direction_is_skipped(self):
        for reverse_direction in (False, True):
            with self.subTest(reverse_direction=reverse_direction):
                child_id = self._create_person(0)
                partner_id = self._create_person(0)
                other_partner_id = self._create_person(1)
                first_id, second_id = (
                    (other_partner_id, partner_id)
                    if reverse_direction
                    else (partner_id, other_partner_id)
                )
                with self.connection.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson) VALUES (3, %s, %s)",
                        (first_id, second_id),
                    )

                self.assertEqual(self._scalar("SELECT fPersonHasOtherPartner(%s)", (partner_id,)), 1)
                result = self._call_sproc(
                    child_id,
                    1,
                    f"Parent{self.token}{len(self.person_ids)}",
                    partner_id=partner_id,
                    marriage_date="1942-07-08",
                )
                new_parent_id = result["NewPersonID"]

                self.assertEqual(result["CompletedOk"], 0)
                self.assertEqual(result["Result"], 200)
                self.assertIn("heeft al een partnerrelatie", result["ErrorMessage"])
                self.assertEqual(
                    self._scalar(
                        "SELECT COUNT(*) FROM humans.relations WHERE RelationPerson=%s AND RelationWithPerson=%s AND RelationName=1",
                        (child_id, new_parent_id),
                    ),
                    1,
                )
                self.assertEqual(
                    self._scalar(
                        "SELECT COUNT(*) FROM humans.relations WHERE RelationName=3 AND ((RelationPerson=%s AND RelationWithPerson=%s) OR (RelationPerson=%s AND RelationWithPerson=%s))",
                        (new_parent_id, partner_id, partner_id, new_parent_id),
                    ),
                    0,
                )
                self.assertEqual(
                    self._scalar(
                        "SELECT COUNT(*) FROM humans.relations WHERE RelationPerson=%s AND RelationWithPerson=%s AND RelationName=2",
                        (child_id, partner_id),
                    ),
                    0,
                )
                self.assertEqual(
                    self._scalar(
                        "SELECT COUNT(*) FROM humans.marriages WHERE PartnerAID=%s AND PartnerBID=%s",
                        (min(new_parent_id, partner_id), max(new_parent_id, partner_id)),
                    ),
                    0,
                )


if __name__ == "__main__":
    unittest.main()