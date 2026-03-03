-- Familiez Version Update - 2026-03-03
-- LDAP Group Mapping Fix & OAuth State Persistence Improvements

-- Create releases and changelog entries for MW (Middleware)
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description) 
VALUES ('1.1.0', NOW(), 'LDAP group mapping and OAuth state persistence fixes');

SET @mw_release_id = LAST_INSERT_ID();

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@mw_release_id, 'Implement robust LDAP group member attribute checking (member, uniqueMember, memberUid)', 'Feature'),
(@mw_release_id, 'Add username domain stripping for Synology LDAP compatibility', 'Feature'),
(@mw_release_id, 'Merge JWT group claims as fallback when LDAP lookup returns no groups', 'Feature'),
(@mw_release_id, 'Fix admin role not granted after successful OAuth login on Synology NAS', 'Bug Fix'),
(@mw_release_id, 'Add comprehensive unit tests for role resolution logic', 'QA');

-- Create releases and changelog entries for FE (Frontend)
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description) 
VALUES ('1.1.0', NOW(), 'OAuth state persistence improvements for HTTP and cross-domain redirects');

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType) VALUES
(@fe_release_id, 'Use SameSite=None;Secure for HTTPS cookies (production NAS)', 'Feature'),
(@fe_release_id, 'Prioritize localStorage over cookies for HTTP (local dev)', 'Feature'),
(@fe_release_id, 'Fix OAuth state loss during Synology SSO redirect', 'Bug Fix'),
(@fe_release_id, 'Support both domain-consistent and domain-mismatched OAuth flows', 'Feature');

-- Summary log
SELECT 
    'Familiez Updated' as Status,
    NOW() as UpdateTime,
    '1.1.0' as Version,
    'LDAP & OAuth fixes deployed' as Summary;
