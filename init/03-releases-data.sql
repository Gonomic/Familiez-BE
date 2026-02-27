-- =====================================================
-- Release history data for Familiez application
-- =====================================================

-- ===== Release 01.000.0001: Authentication working, moved Login to left menu =====

-- Frontend Release 01.000.0001
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0001', NOW(), 'Authentication working, moved Login to left menu');

SET @fe_release_01_000_0001_id = LAST_INSERT_ID();

-- Frontend Release 01.000.0001 - Changes
INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@fe_release_01_000_0001_id, 'Implemented OAuth 2.0 SSO authentication with Synology', 'Feature'),
(@fe_release_01_000_0001_id, 'Fixed auth token handling - use id_token (JWT) instead of opaque access_token', 'Bug Fix'),
(@fe_release_01_000_0001_id, 'Moved logout button from top bar to bottom of left drawer menu', 'Enhancement'),
(@fe_release_01_000_0001_id, 'Fixed RightDrawer form mode switching logic - proper priority for delete/edit/add', 'Bug Fix'),
(@fe_release_01_000_0001_id, 'Fixed cancel handlers to properly close drawer and clear all form states', 'Bug Fix'),
(@fe_release_01_000_0001_id, 'Fixed VITE_API_URL env variable to VITE_API_BASE for API base URL', 'Bug Fix');

-- Middleware Release 01.000.0001
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0001', NOW(), 'Authentication working, moved Login to left menu');

SET @mw_release_01_000_0001_id = LAST_INSERT_ID();

-- Middleware Release 01.000.0001 - Changes
INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@mw_release_01_000_0001_id, 'Implemented OAuth 2.0 token exchange endpoint /auth/callback', 'Feature'),
(@mw_release_01_000_0001_id, 'Fixed auth.py to use id_token from Synology SSO response', 'Bug Fix'),
(@mw_release_01_000_0001_id, 'Added CORS error response handler for proper header injection on 401', 'Enhancement'),
(@mw_release_01_000_0001_id, 'Added /GetReleases endpoint with LEFT JOIN to release changes', 'Feature');

-- ===== Release 01.000.0002: Fixed system health check endpoints =====

-- Frontend Release 01.000.0002
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0002', NOW(), 'Fixed system health check endpoints - use configured API URL and auth headers, added error messages');

SET @fe_release_01_000_0002_id = LAST_INSERT_ID();

-- Frontend Release 01.000.0002 - Changes
INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@fe_release_01_000_0002_id, 'Fixed FamiliezSysteem.jsx ping endpoints to use getMwBaseUrl() instead of hardcoded localhost', 'Bug Fix'),
(@fe_release_01_000_0002_id, 'Updated ping endpoints to use fetchWithAuthHeaders() for authenticated requests', 'Bug Fix'),
(@fe_release_01_000_0002_id, 'Added error signal states (pingMwError, pingDbError) for user feedback', 'Enhancement'),
(@fe_release_01_000_0002_id, 'Added response validation and safe data access in ping handlers', 'Enhancement'),
(@fe_release_01_000_0002_id, 'Exposed getMwBaseUrl() and fetchWithAuthHeaders exports from familyDataService', 'Feature');

-- Middleware Release 01.000.0002
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0002', NOW(), 'Added pingAPI and pingDB to PUBLIC_PATHS for system diagnostics');

SET @mw_release_01_000_0002_id = LAST_INSERT_ID();

-- Middleware Release 01.000.0002 - Changes
INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@mw_release_01_000_0002_id, 'Added /pingAPI endpoint to PUBLIC_PATHS to allow health checks without authentication', 'Enhancement'),
(@mw_release_01_000_0002_id, 'Added /pingDB endpoint to PUBLIC_PATHS to allow database diagnostics without authentication', 'Enhancement');

-- ===== Release 01.000.0003: Session expiration handling with graceful 401 error UX =====

-- Frontend Release 01.000.0003
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0003', NOW(), 'Session expiration handling with graceful 401 error notifications and auto-redirect to login');

SET @fe_release_01_000_0003_id = LAST_INSERT_ID();

-- Frontend Release 01.000.0003 - Changes
INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@fe_release_01_000_0003_id, 'Added notifyAuthError() function in authService.js to dispatch session expiration events', 'Feature'),
(@fe_release_01_000_0003_id, 'Enhanced RequireAuth component with Material-UI Snackbar alert for auth errors', 'Feature'),
(@fe_release_01_000_0003_id, 'Added 401 token expiration checks to 8 API methods (getPersonsLike, getPersonDetails, getFather, getMother, getSiblings, getPartners, getChildren, and getReleases)', 'Feature'),
(@fe_release_01_000_0003_id, 'Implemented auto-redirect to login page after 3 seconds when token expires', 'Enhancement'),
(@fe_release_01_000_0003_id, 'Added Dutch language error message for session expiration: "Uw sessie is verlopen. Meld u alstublieft opnieuw aan."', 'Enhancement'),
(@fe_release_01_000_0003_id, 'Improved error handling consistency across all API methods with proper response status checking', 'Enhancement');

-- Middleware Release 01.000.0003
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0003', NOW(), 'Enhanced auth logging for debugging token validation failures');

SET @mw_release_01_000_0003_id = LAST_INSERT_ID();

-- Middleware Release 01.000.0003 - Changes
INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@mw_release_01_000_0003_id, 'Added auth header validation logging when Bearer token is missing or invalid', 'Enhancement'),
(@mw_release_01_000_0003_id, 'Added token validation failure logging with path and failure reason', 'Enhancement');

-- Note: Backend (BE) release entries are typically updated separately in BE releases table
-- This file focuses on FE and MW changes that affect the overall system architecture
