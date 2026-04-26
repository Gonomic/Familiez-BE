-- ===================================================================
-- Release Information for user-linked tree preferences
-- Date: 2026-04-26
-- ===================================================================

USE humans;

SOURCE CreateUserPreferencesTable.sql;
SOURCE GetUserPreferences.sql;
SOURCE SetUserPreferences.sql;

SET @be_release_number = '0.9.11';
SET @be_release_description = 'Add user preferences table and sprocs for linked tree defaults.';

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
SELECT @be_release_id, 'Added familiez_user_preferences table with nullable FK to persons and defaults for tree generations.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added familiez_user_preferences table with nullable FK to persons and defaults for tree generations.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added GetUserPreferences and SetUserPreferences sprocs for per-user linked tree settings.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added GetUserPreferences and SetUserPreferences sprocs for per-user linked tree settings.'
            AND ChangeType = 'feature'
);

SELECT
    'Familiez BE Updated' AS Status,
    NOW() AS UpdateTime,
    'BE 0.9.11' AS Version,
    'User-linked tree preferences installed' AS Summary;
