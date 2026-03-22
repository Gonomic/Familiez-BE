-- Familiez Version Update - 2026-03-22
-- FE parent-child connector simplification and triangle top anchor point

USE humans;

INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.8', NOW(), 'Simplified parent-child connectors with partner midpoint routing and permanent top anchor points on triangles.');

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@fe_release_id, 'Draw one connector from partner midpoint to child top center when both parents are known as a pair', 'feature'),
(@fe_release_id, 'Added visible midpoint dot on partner connection lines for clearer routing', 'enhancement'),
(@fe_release_id, 'Added permanent top-center anchor dot on every person triangle, also when parents are unknown', 'enhancement'),
(@fe_release_id, 'Kept existing single-parent connector behavior unchanged when no valid parent pair exists', 'bugfix'),
(@fe_release_id, 'Updated connector rendering to remain stable during zoom, pan, and drag operations on SVG canvas', 'enhancement');

SELECT
    'Familiez FE Updated' AS Status,
    NOW() AS UpdateTime,
    'FE 0.9.8' AS Version,
    'Parent-child connector simplification and triangle anchor points applied' AS Summary;
