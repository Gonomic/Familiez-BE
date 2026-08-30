-- ===================================================================
-- Release Information for tracking last added person per user
-- Date: 2026-08-30
-- ===================================================================

USE humans;

SOURCE CreateUserPreferencesTable.sql;
SOURCE GetUserPreferences.sql;
SOURCE SetUserPreferences.sql;

SET @be_release_number = '0.9.12';
SET @be_release_description = 'Add last_added_person_id tracking to user preferences.';

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
SELECT @be_release_id, 'Added last_added_person_id column to familiez_user_preferences with ON DELETE SET NULL FK to persons.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added last_added_person_id column to familiez_user_preferences with ON DELETE SET NULL FK to persons.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Updated GetUserPreferences and SetUserPreferences sprocs to manage last_added_person_id.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Updated GetUserPreferences and SetUserPreferences sprocs to manage last_added_person_id.'
            AND ChangeType = 'feature'
);

SELECT
    'Familiez BE Updated' AS Status,
    NOW() AS UpdateTime,
    'BE 0.9.12' AS Version,
    'Last added person preferences support installed' AS Summary;
