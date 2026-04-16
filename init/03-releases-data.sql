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


-- ===== Release 2026-04-16: Marriage and diagnostics follow-up =====

-- Frontend Release 1.0.2
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('1.0.2', NOW(), 'Huwelijk startdatum opslaan verbeterd; geen onnodige persoonsupdate; canvas datumweergave gecorrigeerd.');

SET @fe_release_1_0_2_id = LAST_INSERT_ID();

-- Frontend Release 1.0.2 - Changes
INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
(@fe_release_1_0_2_id, 'PersonEditForm slaat bij alleen trouwdatum-wijziging geen UpdatePerson meer op (vermijdt valse foutmelding).', 'fix'),
(@fe_release_1_0_2_id, 'FamilyTreeCanvas datum parsing voor huwelijk startdatum timezone-safe gemaakt zodat canvas dezelfde datum toont als opgeslagen.', 'fix'),
(@fe_release_1_0_2_id, 'Regressietests toegevoegd/aangepast voor PersonEditForm en mogelijke ouder/partner endpoints.', 'test');

-- Middleware Release 0.9.9
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.9', NOW(), 'Marriages API uitgebreid en testdekking aangepast aan auth-middleware gedrag.');

SET @mw_release_0_9_9_id = LAST_INSERT_ID();

-- Middleware Release 0.9.9 - Changes
INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
(@mw_release_0_9_9_id, 'Nieuwe/uitgebreide marriage endpoints gebruikt voor actief huwelijk, historie, aanmaken, beëindigen en startdatum wijzigen.', 'feature'),
(@mw_release_0_9_9_id, 'API tests geactualiseerd voor auth-verplichte endpoints (Authorization header + verify_sso_token mocks).', 'test');

-- Backend Release 1.0.0
INSERT INTO be_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('1.0.0', NOW(), 'Stored procedure diagnostics verbeterd en huwelijksfunctionaliteit (MVP) afgerond.');

SET @be_release_1_0_0_id = LAST_INSERT_ID();

-- Backend Release 1.0.0 - Changes
INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
(@be_release_1_0_0_id, 'EXIT HANDLER diagnostics (SQLSTATE, errno, message) gehard in prioritaire sprocs zodat testlog echte SQL-fouten toont.', 'fix'),
(@be_release_1_0_0_id, 'Marriages tabel en sprocs toegevoegd voor expliciete huwelijken (start/einde/reden, actief huwelijk, historie).', 'feature');
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
(@fe_release_01_000_0003_id, 'Improved error handling consistency across all API methods with proper response status checking', 'Enhancement'),
(@fe_release_01_000_0003_id, 'Changed cancel button label from "Afbreken" to "Annuleren" in PersonAddForm and PersonDeleteForm for UI consistency', 'Enhancement'),
(@fe_release_01_000_0003_id, 'Fixed RightDrawer mode switching: ensure personToAdd state is consistently undefined or object, never null', 'Bug Fix'),
(@fe_release_01_000_0003_id, 'Fixed issue where menu button in top bar was showing PersonAddForm instead of tree building mode', 'Bug Fix');

-- Middleware Release 01.000.0003
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0003', NOW(), 'Enhanced auth logging for debugging token validation failures');

SET @mw_release_01_000_0003_id = LAST_INSERT_ID();

-- Middleware Release 01.000.0003 - Changes
INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@mw_release_01_000_0003_id, 'Added auth header validation logging when Bearer token is missing or invalid', 'Enhancement'),
(@mw_release_01_000_0003_id, 'Added token validation failure logging with path and failure reason', 'Enhancement');

-- ===== Release 01.000.0004: Display authenticated username in TopBar =====

-- Frontend Release 01.000.0004
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0004', NOW(), 'Display authenticated username in TopBar after SSO login');

SET @fe_release_01_000_0004_id = LAST_INSERT_ID();

-- Frontend Release 01.000.0004 - Changes
INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@fe_release_01_000_0004_id, 'Added JWT token decoding to extract user information from ID token', 'Feature'),
(@fe_release_01_000_0004_id, 'Added getUserInfo() function in authService.js to extract username from token claims', 'Feature'),
(@fe_release_01_000_0004_id, 'Updated TopBar to display username in format: Familiez (username)', 'Feature'),
(@fe_release_01_000_0004_id, 'Updated OAuth scope to include "profile" scope for user claim access', 'Enhancement'),
(@fe_release_01_000_0004_id, 'Added username extraction from preferred_username or sub claim with domain stripping', 'Enhancement'),
(@fe_release_01_000_0004_id, 'TopBar updates username when authentication state changes (login/logout)', 'Enhancement');

-- Middleware Release 01.000.0004
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0004', NOW(), 'Support profile scope in OAuth token exchange');

SET @mw_release_01_000_0004_id = LAST_INSERT_ID();

-- Middleware Release 01.000.0004 - Changes
INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@mw_release_01_000_0004_id, 'OAuth token exchange endpoint now properly handles "profile" scope requests from frontend', 'Enhancement'),
(@mw_release_01_000_0004_id, 'Improved JWT decoding to support all OIDC standard claims (given_name, family_name, name, email, preferred_username)', 'Enhancement');

-- ===== Release 01.000.0005: User authenticatie met LDAP groepen - role-based access control =====

-- Frontend Release 01.000.0005
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0005', NOW(), 'User authenticatie met LDAP groepen - Users kunnen alleen kijken, Admins kunnen ook wijzigen, toevoegen en verwijderen');

SET @fe_release_01_000_0005_id = LAST_INSERT_ID();

-- Frontend Release 01.000.0005 - Changes
INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@fe_release_01_000_0005_id, 'Added role-based access control with LDAP group integration (Familiez_Users, Familiez_Admins)', 'Feature'),
(@fe_release_01_000_0005_id, 'Created PersonViewForm component for read-only person data viewing (available to all users)', 'Feature'),
(@fe_release_01_000_0005_id, 'Added "Persoon inzien" option to PersonContextMenu for all users', 'Feature'),
(@fe_release_01_000_0005_id, 'Restricted edit/delete/add operations to admin users only in PersonContextMenu', 'Feature'),
(@fe_release_01_000_0005_id, 'Updated RightDrawer to hide "Persoon toevoegen" button for non-admin users', 'Feature'),
(@fe_release_01_000_0005_id, 'Added fetchUserRole() to authService.js to retrieve user role from middleware', 'Feature'),
(@fe_release_01_000_0005_id, 'Display user role (User/Admin) next to username in TopBar', 'Feature'),
(@fe_release_01_000_0005_id, 'Fixed logout flow to clear Synology SSO session via background API call', 'Bug Fix'),
(@fe_release_01_000_0005_id, 'Added max_age=0 and prompt=login OAuth parameters to force re-authentication after logout', 'Bug Fix'),
(@fe_release_01_000_0005_id, 'Fixed OAuth state persistence with localStorage fallback for React StrictMode compatibility', 'Bug Fix'),
(@fe_release_01_000_0005_id, 'Added useRef guard in AuthCallback to prevent duplicate token exchange in development mode', 'Bug Fix'),
(@fe_release_01_000_0005_id, 'Removed all debugging console.log statements from FamilyTreeCanvas component', 'Enhancement');

-- Middleware Release 01.000.0005
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('01.000.0005', NOW(), 'User authenticatie met LDAP groepen - role-based endpoint protection');

SET @mw_release_01_000_0005_id = LAST_INSERT_ID();

-- Middleware Release 01.000.0005 - Changes
INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES 
(@mw_release_01_000_0005_id, 'Integrated LDAP authentication with Synology Directory Server (ldaps://192.168.1.10:636)', 'Feature'),
(@mw_release_01_000_0005_id, 'Added fetch_ldap_groups() function to query user group membership', 'Feature'),
(@mw_release_01_000_0005_id, 'Created require_admin() decorator to protect write endpoints (returns 403 for non-admins)', 'Feature'),
(@mw_release_01_000_0005_id, 'Added /auth/me endpoint to return user role information (admin/user/none)', 'Feature'),
(@mw_release_01_000_0005_id, 'Protected AddPerson, UpdatePerson, DeletePerson endpoints with @require_admin decorator', 'Feature'),
(@mw_release_01_000_0005_id, 'Added python-ldap dependency for LDAP queries', 'Enhancement'),
(@mw_release_01_000_0005_id, 'Enhanced require_auth() decorator to pass username to protected endpoints', 'Enhancement'),
(@mw_release_01_000_0005_id, 'Updated JWT verification with 120 seconds leeway for clock drift tolerance', 'Enhancement');

-- ===== Release 1.0.3: FE console warnings opgelost =====

-- Frontend Release 1.0.3
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('1.0.3', NOW(), 'Console warnings opgelost voor PersonTriangle, PersonContextMenu en PersonEditForm select-waarden.');

SET @fe_release_1_0_3_id = LAST_INSERT_ID();

-- Frontend Release 1.0.3 - Changes
INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
(@fe_release_1_0_3_id, 'PersonTriangle prop type voor PersonIsMale aangepast naar bool/number zodat API-waarden 0/1 geen warning geven.', 'fix'),
(@fe_release_1_0_3_id, 'PersonContextMenu aangepast zodat Menu geen Fragment als direct child ontvangt (MUI warning opgelost).', 'fix'),
(@fe_release_1_0_3_id, 'PersonEditForm select-lijsten voorzien van fallback-opties voor huidige IDs buiten de dynamische picklist (out-of-range warning opgelost).', 'fix');

