-- ===================================================================
-- Release Information for File Management Feature
-- Date: 2026-03-05
-- ===================================================================

USE humans;

-- BE Release: Database tables for file management
INSERT INTO be_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.0', NOW(), 'Database tables for file management system');

SET @be_release_id = LAST_INSERT_ID();

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@be_release_id, 'Created files table for storing file metadata', 'feature'),
    (@be_release_id, 'Created person_files junction table for person-file links', 'feature'),
    (@be_release_id, 'Created family_files junction table for family-file links', 'feature'),
    (@be_release_id, 'Added indexes for optimized file queries', 'enhancement'),
    (@be_release_id, 'Added foreign key constraints for data integrity', 'enhancement');

-- MW Release: File management API endpoints
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.0', NOW(), 'Complete file management API with upload, download, and thumbnail support');

SET @mw_release_id = LAST_INSERT_ID();

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@mw_release_id, 'Implemented POST /api/files/upload endpoint with file storage', 'feature'),
    (@mw_release_id, 'Implemented GET /api/files/{file_id} download endpoint', 'feature'),
    (@mw_release_id, 'Implemented GET /api/files/{file_id}/thumbnail with on-the-fly generation', 'feature'),
    (@mw_release_id, 'Implemented GET /api/person/{person_id}/files query endpoint', 'feature'),
    (@mw_release_id, 'Implemented GET /api/family/{father_id}/{mother_id}/files query endpoint', 'feature'),
    (@mw_release_id, 'Added file_utils.py with slugify and path generation utilities', 'feature'),
    (@mw_release_id, 'Added Pillow dependency for image thumbnail generation', 'dependency'),
    (@mw_release_id, 'Added python-multipart dependency for file uploads', 'dependency'),
    (@mw_release_id, 'Added storage configuration (STORAGE_BASE_PATH, MAX_FILE_UPLOAD_SIZE)', 'configuration'),
    (@mw_release_id, 'File uploads support person and family scopes', 'feature'),
    (@mw_release_id, 'Automatic directory structure creation based on entity IDs', 'feature'),
    (@mw_release_id, 'File size validation (max 50MB by default)', 'validation');
