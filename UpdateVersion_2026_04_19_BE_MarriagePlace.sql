-- ===================================================================
-- Release Information for marriage place field in BE
-- Date: 2026-04-19
-- ===================================================================

USE humans;

SET @column_exists := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'humans'
      AND TABLE_NAME = 'marriages'
      AND COLUMN_NAME = 'MarriagePlace'
);

SET @ddl := IF(
    @column_exists = 0,
    'ALTER TABLE humans.marriages ADD COLUMN MarriagePlace VARCHAR(100) DEFAULT NULL COMMENT ''Place where marriage took place'' AFTER StartDate',
    'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SOURCE AddMarriage_v2.sql;
SOURCE UpdateMarriageStartDate_v2.sql;
SOURCE AddMarriage.sql;
SOURCE UpdateMarriageStartDate.sql;
SOURCE GetActiveMarriageForPerson.sql;
SOURCE GetActiveMarriageForPair.sql;
SOURCE GetMarriageHistoryForPerson.sql;

SET @be_release_number = '0.9.10';
SET @be_release_description = 'Add marriage place field with backward compatible marriage procedures.';

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
SELECT @be_release_id, 'Added marriages.MarriagePlace column for place of marriage.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added marriages.MarriagePlace column for place of marriage.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Updated marriage sprocs to store and return MarriagePlace with legacy compatibility wrappers.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Updated marriage sprocs to store and return MarriagePlace with legacy compatibility wrappers.'
            AND ChangeType = 'feature'
);

SELECT
    'Familiez BE Updated' AS Status,
    NOW() AS UpdateTime,
    'BE 0.9.10' AS Version,
    'Marriage place support installed in backend database' AS Summary;
