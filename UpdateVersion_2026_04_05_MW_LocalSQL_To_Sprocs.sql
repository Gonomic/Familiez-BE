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

INSERT INTO be_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.8', NOW(), 'Start migration of MW local SQL to BE sprocs (GetPersonDetails_v2).');

SET @be_release_id = LAST_INSERT_ID();

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@be_release_id, 'Added GetPersonDetails_v2 sproc with person status fields and parent/partner output.', 'feature'),
    (@be_release_id, 'Made partner read logic defensive for both relation directions during migration.', 'enhancement'),
    (@be_release_id, 'Added GetPartnerForPerson sproc to replace MW inline partner query.', 'feature'),
    (@be_release_id, 'Added GetFileMeta sproc for file metadata reads used by download and thumbnail endpoints.', 'feature'),
    (@be_release_id, 'Added GetPersonFiles and GetFamilyFiles sprocs for file list endpoints.', 'feature'),
    (@be_release_id, 'Added GetReleasesByComponent sproc with component whitelist for fe/mw/be.', 'feature');

INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.8', NOW(), 'GetPersonDetails endpoint now calls GetPersonDetails_v2.');

SET @mw_release_id = LAST_INSERT_ID();

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@mw_release_id, 'Replaced inline SQL in /GetPersonDetails endpoint with CALL GetPersonDetails_v2.', 'refactor'),
    (@mw_release_id, 'Replaced inline SQL in /GetPartners endpoint with CALL GetPartnerForPerson.', 'refactor'),
    (@mw_release_id, 'Replaced inline SQL in fetch_releases with CALL GetReleasesByComponent.', 'refactor'),
    (@mw_release_id, 'Replaced inline SQL in /api/files/{file_id} and /api/files/{file_id}/thumbnail with CALL GetFileMeta.', 'refactor'),
    (@mw_release_id, 'Replaced inline SQL in /api/person/{person_id}/files and /api/family/{father_id}/{mother_id}/files with sprocs.', 'refactor');

SELECT
    'Familiez BE + MW Updated' AS Status,
    NOW() AS UpdateTime,
    'BE 0.9.8 / MW 0.9.8' AS Version,
    'Phase 1 migration in progress: person, partner, release, and file read endpoints now use stored procedures' AS Summary;
