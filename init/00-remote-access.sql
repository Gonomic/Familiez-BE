-- ===================================================================
-- Remote Access Configuration for Production Database
-- Created: 2026-03-06
-- Purpose: Grant remote root access from development machine
-- ===================================================================

-- Note: This file executes FIRST (00-prefix) before schema creation

-- Create root user with access from local network (192.168.1.x)
-- This allows database management from your dev machine
CREATE USER IF NOT EXISTS 'root'@'192.168.1.%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.1.%' WITH GRANT OPTION;

-- Also ensure localhost root exists with all privileges
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

-- Apply changes immediately
FLUSH PRIVILEGES;

-- Log the configuration
SELECT 'Remote root access configured for 192.168.1.% network' AS Status;
