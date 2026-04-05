-- Familiez Version Update - 2026-04-05
-- FE picklist labels with birth date + BE sprocs return normalized PersonDateOfBirth

-- FE release entry
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES (
    '1.0.1',
    NOW(),
    'Person add/edit picklists tonen nu naam plus geboortedatum voor mogelijke vader/moeder/partner.'
);

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@fe_release_id, 'Voeg formatBirthDate helper toe voor consistente datumweergave in picklists', 'enhancement'),
(@fe_release_id, 'Toon in Persoon Toevoegen picklists: Naam (dd-mm-jjjj)', 'ui'),
(@fe_release_id, 'Toon in Persoon Bewerken picklists: Naam (dd-mm-jjjj)', 'ui'),
(@fe_release_id, 'Gebruik uniforme labelopbouw voor mogelijke vaders/moeders/partners', 'enhancement');

-- BE release entry
INSERT INTO be_releases (ReleaseNumber, ReleaseDate, Description)
VALUES (
    '1.0.1',
    NOW(),
    'Possible parent/partner sprocs geven PersonDateOfBirth als losse datumkolom terug voor FE picklist labels.'
);

SET @be_release_id = LAST_INSERT_ID();

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@be_release_id, 'GetPossibleFathersBasedOnAge retourneert PersonDateOfBirth', 'enhancement'),
(@be_release_id, 'getPossibleMothersBasedOnAge retourneert PersonDateOfBirth', 'enhancement'),
(@be_release_id, 'getPossiblePartnersBasedOnAge retourneert genormaliseerde PersonDateOfBirth zonder extra haakjes', 'bugfix');

-- Summary
SELECT
    'Familiez Updated' AS Status,
    NOW() AS UpdateTime,
    'FE 1.0.1 / BE 1.0.1' AS Version,
    'Picklist labels with birth dates + normalized date output from possible parent/partner sprocs' AS Summary;
