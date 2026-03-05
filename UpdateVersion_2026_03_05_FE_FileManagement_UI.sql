-- ===================================================================
-- Release Information for Frontend File Management UI (Step 3)
-- Date: 2026-03-05
-- ===================================================================

USE humans;

INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.1', NOW(), 'Frontend UI for file management: upload flow, grouped document grids, and preview popup');

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@fe_release_id, 'Added context menu option Bestanden on person triangle actions', 'feature'),
    (@fe_release_id, 'Added drawer files mode with dedicated PersonFilesForm component', 'feature'),
    (@fe_release_id, 'Implemented upload UI with scope picker (person/family)', 'feature'),
    (@fe_release_id, 'Implemented document type dropdown with required genealogical document categories', 'feature'),
    (@fe_release_id, 'Implemented optional year input and file picker/upload action', 'feature'),
    (@fe_release_id, 'Implemented grouped document sections: persoonlijke documenten and familiedocumenten', 'feature'),
    (@fe_release_id, 'Implemented thumbnail grid rendering via /api/files/{id}/thumbnail', 'feature'),
    (@fe_release_id, 'Implemented popup preview via window.open for /api/files/{id}', 'feature'),
    (@fe_release_id, 'Integrated frontend service calls for upload and document list endpoints', 'enhancement'),
    (@fe_release_id, 'Added graceful fallback icon for non-image thumbnail responses', 'enhancement');
