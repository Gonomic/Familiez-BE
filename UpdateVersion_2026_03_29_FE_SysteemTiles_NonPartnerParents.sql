-- FE versie 1.0.0 - Systeemscherm herindeling + conditionele niet-partner ouders in stamboom
-- Datum: 29 maart 2026

INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES (
    '1.0.0',
    NOW(),
    'Systeemscherm herontworpen met MUI-tegels voor Ping MW, Ping DB en Systeeminstellingen. Stamboom toont nu conditioneel ouders die geen partners (meer) zijn, instelbaar via systeeminstellingen.'
);

SET @ReleaseID = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@ReleaseID, 'Systeemscherm herontworpen met afzonderlijke MUI-tegels voor Ping Middleware, Ping Database en Systeeminstellingen', 'feature'),
(@ReleaseID, 'Ping-uitvoer per tegel uitgelijnd op langste label voor betere leesbaarheid', 'enhancement'),
(@ReleaseID, 'Instelling toegevoegd: "Toon ook ouders die geen partners (meer) zijn" - wordt opgeslagen in localStorage', 'feature'),
(@ReleaseID, 'Stamboom toont standaard alleen ouders die een bevestigd koppel zijn; instelling breidt dit uit naar alle biologische ouders', 'feature'),
(@ReleaseID, 'Kinderen van een getekend ouderpaar worden altijd samengevat (ook kinderen van de partner), ongeacht de instelling', 'enhancement');
