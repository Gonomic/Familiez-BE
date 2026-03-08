-- Familiez Version Update - 2026-03-08
-- MW auth/session stability in production after short-lived JWT expiry

-- MW release entry
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.4', NOW(), 'Enable stable server-side session fallback in production by passing ENVIRONMENT and USE_SERVER_SESSIONS to middleware runtime.');

SET @mw_release_id = LAST_INSERT_ID();

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@mw_release_id, 'Use SameSite=None with Secure cookies in production for cross-site auth callback/session cookie flow', 'bugfix'),
(@mw_release_id, 'Allow expired JWT fallback to valid server-side session during authenticated requests', 'bugfix'),
(@mw_release_id, 'Pass ENVIRONMENT and USE_SERVER_SESSIONS explicitly via production compose for mw service', 'configuration'),
(@mw_release_id, 'Prevent AddPerson 401 after JWT expiry when valid session exists', 'stability');

-- Summary
SELECT
    'Familiez MW Updated' AS Status,
    NOW() AS UpdateTime,
    'MW 0.9.4' AS Version,
    'Production session fallback and compose runtime env wiring fixed' AS Summary;
