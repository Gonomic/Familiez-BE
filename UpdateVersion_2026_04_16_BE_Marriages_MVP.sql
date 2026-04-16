-- ===================================================================
-- Release Information for explicit marriages MVP in BE
-- Date: 2026-04-16
-- ===================================================================

USE humans;

SOURCE CreateMarriagesTable.sql;
SOURCE AddMarriage.sql;
SOURCE EndMarriage.sql;
SOURCE UpdateMarriageStartDate.sql;
SOURCE GetActiveMarriageForPerson.sql;
SOURCE GetActiveMarriageForPair.sql;
SOURCE GetMarriageHistoryForPerson.sql;

SET @be_release_number = '0.9.9';
SET @be_release_description = 'Introduce explicit marriages table and marriage stored procedures.';

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
SELECT @be_release_id, 'Added marriages table for explicit huwelijkregistratie met start-, eind- en redenvelden.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added marriages table for explicit huwelijkregistratie met start-, eind- en redenvelden.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added AddMarriage and EndMarriage sprocs with overlap validation per persoon.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added AddMarriage and EndMarriage sprocs with overlap validation per persoon.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added GetActiveMarriageForPerson, GetActiveMarriageForPair en GetMarriageHistoryForPerson.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added GetActiveMarriageForPerson, GetActiveMarriageForPair en GetMarriageHistoryForPerson.'
            AND ChangeType = 'feature'
);

SELECT
    'Familiez BE Updated' AS Status,
    NOW() AS UpdateTime,
    'BE 0.9.9' AS Version,
    'Explicit marriages MVP installed in backend database' AS Summary;