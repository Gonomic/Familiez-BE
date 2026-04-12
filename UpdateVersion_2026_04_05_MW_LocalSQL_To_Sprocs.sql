-- ===================================================================
-- Release Information for MW local SQL to BE sprocs migration (phase 1)
-- Date: 2026-04-05
-- ===================================================================

USE humans;

SOURCE GetPersonDetails_v2.sql;
SOURCE GetPartnerForPerson.sql;
SOURCE GetFileMeta.sql;
SOURCE GetPersonFiles.sql;
SOURCE GetFamilyFiles.sql;
SOURCE GetReleasesByComponent.sql;
SOURCE AddFileForPerson.sql;
SOURCE AddFileForFamily.sql;
SOURCE ChangePerson_v2.sql;
SOURCE AddPerson_v2.sql;

SET @be_release_number = '0.9.8';
SET @be_release_description = 'Start migration of MW local SQL to BE sprocs (GetPersonDetails_v2).';

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
SELECT @be_release_id, 'Added GetPersonDetails_v2 sproc with person status fields and parent/partner output.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added GetPersonDetails_v2 sproc with person status fields and parent/partner output.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Made partner read logic defensive for both relation directions during migration.', 'enhancement'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Made partner read logic defensive for both relation directions during migration.'
            AND ChangeType = 'enhancement'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added GetPartnerForPerson sproc to replace MW inline partner query.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added GetPartnerForPerson sproc to replace MW inline partner query.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added GetFileMeta sproc for file metadata reads used by download and thumbnail endpoints.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added GetFileMeta sproc for file metadata reads used by download and thumbnail endpoints.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added GetPersonFiles and GetFamilyFiles sprocs for file list endpoints.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added GetPersonFiles and GetFamilyFiles sprocs for file list endpoints.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added GetReleasesByComponent sproc with component whitelist for fe/mw/be.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added GetReleasesByComponent sproc with component whitelist for fe/mw/be.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added AddFileForPerson and AddFileForFamily write sprocs for atomic file metadata linking.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added AddFileForPerson and AddFileForFamily write sprocs for atomic file metadata linking.'
            AND ChangeType = 'feature'
);

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @be_release_id, 'Added ChangePerson_v2 and AddPerson_v2 to remove remaining MW person write SQL lookups.', 'feature'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM be_release_changes
        WHERE ReleaseID = @be_release_id
            AND ChangeDescription = 'Added ChangePerson_v2 and AddPerson_v2 to remove remaining MW person write SQL lookups.'
            AND ChangeType = 'feature'
);

SET @mw_release_number = '0.9.8';
SET @mw_release_description = 'GetPersonDetails endpoint now calls GetPersonDetails_v2.';

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
SELECT @mw_release_id, 'Replaced inline SQL in /GetPersonDetails endpoint with CALL GetPersonDetails_v2.', 'refactor'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM mw_release_changes
        WHERE ReleaseID = @mw_release_id
            AND ChangeDescription = 'Replaced inline SQL in /GetPersonDetails endpoint with CALL GetPersonDetails_v2.'
            AND ChangeType = 'refactor'
);

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'Replaced inline SQL in /GetPartners endpoint with CALL GetPartnerForPerson.', 'refactor'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM mw_release_changes
        WHERE ReleaseID = @mw_release_id
            AND ChangeDescription = 'Replaced inline SQL in /GetPartners endpoint with CALL GetPartnerForPerson.'
            AND ChangeType = 'refactor'
);

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'Replaced inline SQL in fetch_releases with CALL GetReleasesByComponent.', 'refactor'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM mw_release_changes
        WHERE ReleaseID = @mw_release_id
            AND ChangeDescription = 'Replaced inline SQL in fetch_releases with CALL GetReleasesByComponent.'
            AND ChangeType = 'refactor'
);

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'Replaced inline SQL in /api/files/{file_id} and /api/files/{file_id}/thumbnail with CALL GetFileMeta.', 'refactor'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM mw_release_changes
        WHERE ReleaseID = @mw_release_id
            AND ChangeDescription = 'Replaced inline SQL in /api/files/{file_id} and /api/files/{file_id}/thumbnail with CALL GetFileMeta.'
            AND ChangeType = 'refactor'
);

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'Replaced inline SQL in /api/person/{person_id}/files and /api/family/{father_id}/{mother_id}/files with sprocs.', 'refactor'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM mw_release_changes
        WHERE ReleaseID = @mw_release_id
            AND ChangeDescription = 'Replaced inline SQL in /api/person/{person_id}/files and /api/family/{father_id}/{mother_id}/files with sprocs.'
            AND ChangeType = 'refactor'
);

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'Migrated /api/files/upload DB writes to CALL AddFileForPerson/AddFileForFamily with disk cleanup on DB failure.', 'refactor'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM mw_release_changes
        WHERE ReleaseID = @mw_release_id
            AND ChangeDescription = 'Migrated /api/files/upload DB writes to CALL AddFileForPerson/AddFileForFamily with disk cleanup on DB failure.'
            AND ChangeType = 'refactor'
);

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'Removed pre-SELECT from /UpdatePerson by switching to ChangePerson_v2.', 'refactor'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM mw_release_changes
        WHERE ReleaseID = @mw_release_id
            AND ChangeDescription = 'Removed pre-SELECT from /UpdatePerson by switching to ChangePerson_v2.'
            AND ChangeType = 'refactor'
);

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
SELECT @mw_release_id, 'Removed fallback SELECT from /AddPerson by switching to AddPerson_v2 returning PersonID.', 'refactor'
FROM DUAL
WHERE NOT EXISTS (
        SELECT 1 FROM mw_release_changes
        WHERE ReleaseID = @mw_release_id
            AND ChangeDescription = 'Removed fallback SELECT from /AddPerson by switching to AddPerson_v2 returning PersonID.'
            AND ChangeType = 'refactor'
);

SELECT
    'Familiez BE + MW Updated' AS Status,
    NOW() AS UpdateTime,
    'BE 0.9.8 / MW 0.9.8' AS Version,
    'Phase 1 reads, Phase 2 uploads, and Phase 3 person writes migrated to stored procedures' AS Summary;
