-- Familiez Version Update - 2026-03-08
-- Person add/edit flow improvements, relation editing support, and latin1 input safeguards

-- MW release entry
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.3', NOW(), 'UpdatePerson supports full relation and gender updates via ChangePerson with complete parameter set.');

SET @mw_release_id = LAST_INSERT_ID();

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@mw_release_id, 'Fix ChangePerson invocation to pass all 13 required parameters from middleware', 'bugfix'),
(@mw_release_id, 'Add support for updating PersonIsMale through UpdatePerson', 'feature'),
(@mw_release_id, 'Add support for updating MotherId, FatherId and PartnerId through UpdatePerson', 'feature'),
(@mw_release_id, 'Preserve and pass date status fields (PersonDateOfBirthStatus, PersonDateOfDeathStatus)', 'enhancement');

-- FE release entry
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.4', NOW(), 'Person add/edit UX improvements: relation editing, gender editing, and safer input handling for latin1 database charset.');

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@fe_release_id, 'Allow editing of person gender in Persoon Bewerken form', 'feature'),
(@fe_release_id, 'Allow editing of father, mother and partner in Persoon Bewerken form', 'feature'),
(@fe_release_id, 'Initialize edit form relation values from current person relations', 'enhancement'),
(@fe_release_id, 'Normalize accented/special characters in person text fields to latin1-safe equivalents', 'bugfix'),
(@fe_release_id, 'Validate person text fields against allowed latin1-friendly character set', 'validation'),
(@fe_release_id, 'Fix Persoon toevoegen flow when no person is selected (null instead of undefined)', 'bugfix'),
(@fe_release_id, 'Align add form labels: use Vader and Moeder without ID suffix', 'ui');

-- Summary
SELECT
    'Familiez Updated' AS Status,
    NOW() AS UpdateTime,
    'FE 0.9.4 / MW 0.9.3' AS Version,
    'Person relation editing + UpdatePerson fix + input normalization' AS Summary;
