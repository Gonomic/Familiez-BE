-- Familiez Version Update - 2026-03-29
-- FE family tree layout centering and compact horizontal spacing improvements

USE humans;

INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.9', NOW(), 'Improved family tree layout: centered descendant generations on anchor person, stable generation ordering, and reduced horizontal spacing without partner overlap.');

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@fe_release_id, 'Fixed descendant generation positioning to center horizontally under the anchor person', 'bugfix'),
(@fe_release_id, 'Kept bloodline-first ordering and sibling sorting by birth date stable within generations', 'enhancement'),
(@fe_release_id, 'Reduced horizontal spacing between non-partner persons/blocks to make the tree less wide', 'enhancement'),
(@fe_release_id, 'Restored partner spacing so partners touch without overlapping', 'bugfix'),
(@fe_release_id, 'Preserved drag, connector line stability, zoom, and reset-view behavior after layout changes', 'stability');

SELECT
    'Familiez FE Updated' AS Status,
    NOW() AS UpdateTime,
    'FE 0.9.9' AS Version,
    'Tree layout centering and spacing update applied' AS Summary;
