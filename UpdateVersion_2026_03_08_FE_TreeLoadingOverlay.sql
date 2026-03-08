-- Familiez Version Update - 2026-03-08
-- FE tree loading overlay animation

INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.5', NOW(), 'Loading overlay animation for family tree rendering to provide feedback during large tree builds.');

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@fe_release_id, 'Show animated overlay on tree canvas while data is fetched and SVG is built', 'feature'),
(@fe_release_id, 'Add loading message and animated progress dots for better user feedback', 'enhancement'),
(@fe_release_id, 'Prevent stale async tree build state updates using request-id guard', 'bugfix');

SELECT
    'Familiez FE Updated' AS Status,
    NOW() AS UpdateTime,
    'FE 0.9.5' AS Version,
    'Tree loading overlay animation deployed' AS Summary;
