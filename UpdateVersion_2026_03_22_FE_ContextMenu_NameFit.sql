-- Familiez Version Update - 2026-03-22
-- FE context menu wording + robust SVG name fitting in person triangle

USE humans;

INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.7', NOW(), 'Person context menu label updated and person-name rendering improved to fit triangle width across environments.');

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@fe_release_id, 'Changed person context menu action label from "Persoon toevoegen" to "Kind toevoegen"', 'enhancement'),
(@fe_release_id, 'Replaced fixed character truncation with measured SVG text-width fitting for names in person triangles', 'feature'),
(@fe_release_id, 'Added dynamic font downscaling for long names before fallback ellipsis truncation', 'feature'),
(@fe_release_id, 'Reduced horizontal name safety margin to 2px per side for better use of available triangle width', 'enhancement');

SELECT
    'Familiez FE Updated' AS Status,
    NOW() AS UpdateTime,
    'FE 0.9.7' AS Version,
    'Context menu and robust name fitting update applied' AS Summary;
