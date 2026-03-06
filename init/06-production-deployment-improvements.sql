-- ===================================================================
-- Release Information for Production Deployment Improvements
-- Date: 2026-03-06
-- ===================================================================

USE humans;

-- BE Release: Database configuration improvements
INSERT INTO be_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.1', NOW(), 'Database configuration improvements for production deployment');

SET @be_release_id = LAST_INSERT_ID();

INSERT INTO be_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@be_release_id, 'Reorganized init scripts with remote access configuration', 'configuration'),
    (@be_release_id, 'Improved MySQL container initialization with bind mounts', 'configuration');

-- MW Release: Production deployment configuration
INSERT INTO mw_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.1', NOW(), 'Production deployment improvements: security, port configuration, and Docker optimization');

SET @mw_release_id = LAST_INSERT_ID();

INSERT INTO mw_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@mw_release_id, 'Changed MW production port from 8000 to 18000 to avoid conflicts', 'configuration'),
    (@mw_release_id, 'Removed fallback values from sensitive environment variables for security', 'security'),
    (@mw_release_id, 'Added ALLOWED_ORIGINS environment variable for dynamic CORS configuration', 'security'),
    (@mw_release_id, 'Updated docker-compose.prod.yml to use MW-build folder structure', 'configuration'),
    (@mw_release_id, 'Updated docker-compose.prod.yml to use mysql-init folder for initialization', 'configuration'),
    (@mw_release_id, 'Added .dockerignore for cleaner Docker builds', 'optimization'),
    (@mw_release_id, 'Fixed LDAP URL to use NAS host IP (192.168.1.10:636) for container networking', 'bugfix'),
    (@mw_release_id, 'Added STORAGE_HOST_PATH environment variable for flexible storage configuration', 'configuration');

-- FE Release: Production build optimization
INSERT INTO fe_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.1', NOW(), 'Frontend production deployment improvements: dist-only deployment');

SET @fe_release_id = LAST_INSERT_ID();

INSERT INTO fe_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@fe_release_id, 'Changed FE deployment to dist-only (no build on NAS)', 'optimization'),
    (@fe_release_id, 'Updated docker-compose.prod.yml to use nginx:stable-alpine with prebuilt dist', 'optimization'),
    (@fe_release_id, 'Changed FE production port from 5173 to 18080', 'configuration'),
    (@fe_release_id, 'Removed dev environment variables from production compose', 'cleanup'),
    (@fe_release_id, 'Consolidated nginx configuration to single FE/nginx.conf file', 'cleanup');

-- Documentation Release
INSERT INTO doc_releases (ReleaseNumber, ReleaseDate, Description)
VALUES ('0.9.1', NOW(), 'Complete rewrite of production deployment guide');

SET @doc_release_id = LAST_INSERT_ID();

INSERT INTO doc_release_changes (ReleaseID, ChangeDescription, ChangeType)
VALUES
    (@doc_release_id, 'Created comprehensive PRODUCTION_DEPLOYMENT_GUIDE.md with first-time and update procedures', 'documentation'),
    (@doc_release_id, 'Added DATABASE_REINIT_GUIDE.md for database reset procedures', 'documentation'),
    (@doc_release_id, 'Updated .env.example with production configuration examples', 'documentation'),
    (@doc_release_id, 'Documented NAS folder structure and deployment workflow', 'documentation');
