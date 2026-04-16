-- ===================================================================
-- Release notes sync for FE, MW, and BE
-- Date: 2026-04-16
-- Purpose: persist release metadata so app release view is consistent
-- ===================================================================

USE humans;

-- ------------------------------
-- FE release 1.0.2
-- ------------------------------
SET @fe_release_number = '1.0.2';
SET @fe_release_description = 'Huwelijk startdatum opslaan verbeterd; geen onnodige persoonsupdate; canvas datumweergave gecorrigeerd.';

INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
SELECT @fe_release_number, NOW(), @fe_release_description
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM fe_releases
    WHERE ReleaseNumber = @fe_release_number
      AND Description = @fe_release_description
);

SELECT ReleaseID INTO @fe_release_id
FROM fe_releases
WHERE ReleaseNumber = @fe_release_number
  AND Description = @fe_release_description
ORDER BY ReleaseID DESC
LIMIT 1;

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @fe_release_id, 'PersonEditForm slaat bij alleen trouwdatum-wijziging geen UpdatePerson meer op (vermijdt valse foutmelding).', 'fix'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM fe_release_changes
    WHERE ReleaseID = @fe_release_id
      AND ChangeDescription = 'PersonEditForm slaat bij alleen trouwdatum-wijziging geen UpdatePerson meer op (vermijdt valse foutmelding).'
      AND ChangeType = 'fix'
);

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @fe_release_id, 'FamilyTreeCanvas datum parsing voor huwelijk startdatum timezone-safe gemaakt zodat canvas dezelfde datum toont als opgeslagen.', 'fix'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM fe_release_changes
    WHERE ReleaseID = @fe_release_id
      AND ChangeDescription = 'FamilyTreeCanvas datum parsing voor huwelijk startdatum timezone-safe gemaakt zodat canvas dezelfde datum toont als opgeslagen.'
      AND ChangeType = 'fix'
);

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @fe_release_id, 'Regressietests toegevoegd/aangepast voor PersonEditForm en mogelijke ouder/partner endpoints.', 'test'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM fe_release_changes
    WHERE ReleaseID = @fe_release_id
      AND ChangeDescription = 'Regressietests toegevoegd/aangepast voor PersonEditForm en mogelijke ouder/partner endpoints.'
      AND ChangeType = 'test'
);

-- ------------------------------
-- MW release 0.9.9
-- ------------------------------
SET @mw_release_number = '0.9.9';
SET @mw_release_description = 'Marriages API uitgebreid en testdekking aangepast aan auth-middleware gedrag.';

INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
SELECT @mw_release_number, NOW(), @mw_release_description
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM mw_releases
    WHERE ReleaseNumber = @mw_release_number
      AND Description = @mw_release_description
);

SELECT ReleaseID INTO @mw_release_id
FROM mw_releases
WHERE ReleaseNumber = @mw_release_number
  AND Description = @mw_release_description
ORDER BY ReleaseID DESC
LIMIT 1;

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'Nieuwe/uitgebreide marriage endpoints gebruikt voor actief huwelijk, historie, aanmaken, beëindigen en startdatum wijzigen.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM mw_release_changes
    WHERE ReleaseID = @mw_release_id
      AND ChangeDescription = 'Nieuwe/uitgebreide marriage endpoints gebruikt voor actief huwelijk, historie, aanmaken, beëindigen en startdatum wijzigen.'
      AND ChangeType = 'feature'
);

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'API tests geactualiseerd voor auth-verplichte endpoints (Authorization header + verify_sso_token mocks).', 'test'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM mw_release_changes
    WHERE ReleaseID = @mw_release_id
      AND ChangeDescription = 'API tests geactualiseerd voor auth-verplichte endpoints (Authorization header + verify_sso_token mocks).'
      AND ChangeType = 'test'
);

-- ------------------------------
-- BE release 1.0.0
-- ------------------------------
SET @be_release_number = '1.0.0';
SET @be_release_description = 'Stored procedure diagnostics verbeterd en huwelijksfunctionaliteit (MVP) afgerond.';

INSERT INTO be_releases (ReleaseNumber, ReleaseDate, Description)
SELECT @be_release_number, NOW(), @be_release_description
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM be_releases
    WHERE ReleaseNumber = @be_release_number
      AND Description = @be_release_description
);

SELECT ReleaseID INTO @be_release_id
FROM be_releases
WHERE ReleaseNumber = @be_release_number
  AND Description = @be_release_description
ORDER BY ReleaseID DESC
LIMIT 1;

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'EXIT HANDLER diagnostics (SQLSTATE, errno, message) gehard in prioritaire sprocs zodat testlog echte SQL-fouten toont.', 'fix'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM be_release_changes
    WHERE ReleaseID = @be_release_id
      AND ChangeDescription = 'EXIT HANDLER diagnostics (SQLSTATE, errno, message) gehard in prioritaire sprocs zodat testlog echte SQL-fouten toont.'
      AND ChangeType = 'fix'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Marriages tabel en sprocs toegevoegd voor expliciete huwelijken (start/einde/reden, actief huwelijk, historie).', 'feature'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM be_release_changes
    WHERE ReleaseID = @be_release_id
      AND ChangeDescription = 'Marriages tabel en sprocs toegevoegd voor expliciete huwelijken (start/einde/reden, actief huwelijk, historie).'
      AND ChangeType = 'feature'
);

SELECT
    'Release notes synced' AS Status,
    NOW() AS UpdateTime,
    'FE 1.0.2 | MW 0.9.9 | BE 1.0.0' AS Versions;
