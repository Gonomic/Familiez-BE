# Database Initialization Guide

## Overview
This repository contains SQL source files for the `humans` database schema, stored procedures, and functions. These files are automatically processed and deployed to a MariaDB 10.6 container using Docker Compose.

## Directory Structure
```
BE/
├── scripts/
│   ├── prepare-schema.sh     # Generates 01-schema.sql from humans*.sql files
│   └── prepare-init.sh       # Generates 02-stored-procedures.sql from f*.sql and get*.sql files
├── init/                     # Generated files (gitignored)
│   ├── 01-schema.sql         # Combined schema (11 tables)
│   └── 02-stored-procedures.sql  # Combined routines (10 functions + 8 procedures)
├── humans*.sql               # Source: table definitions
├── f*.sql                    # Source: function definitions
└── get*.sql                  # Source: procedure definitions
```

## Quick Start

### 1. Generate Init Files
```bash
cd /home/frans/Documenten/dev/Familiez/BE
./scripts/prepare-schema.sh
./scripts/prepare-init.sh
```

### 2. Start Database
```bash
cd /home/frans/Documenten/dev/Familiez/MW
docker compose up -d
```

The database will automatically initialize with:
- ✓ 11 Tables
- ✓ 10 Functions
- ✓ 8 Procedures

### 3. Verify Initialization
```bash
docker compose exec mysql mysql -uHumansService -pXHHxECL54EjvhhPSBLMU humans -e "
SELECT 'Tables' AS Type, COUNT(*) AS Count FROM information_schema.TABLES WHERE TABLE_SCHEMA='humans'
UNION ALL SELECT 'Functions', COUNT(*) FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA='humans' AND ROUTINE_TYPE='FUNCTION'
UNION ALL SELECT 'Procedures', COUNT(*) FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA='humans' AND ROUTINE_TYPE='PROCEDURE';
"
```

## Script Details

### prepare-schema.sh
- Combines all `humans*.sql` files into `init/01-schema.sql`
- Replaces MySQL 8.0 collations with MariaDB-compatible equivalents
  - `utf8mb4_0900_ai_ci` → `utf8mb4_unicode_ci`

### prepare-init.sh
- Processes `f*.sql` (functions) and `get*.sql` (procedures)
- Ensures `getTranNo.sql` loads first (dependency ordering)
- Applies MariaDB compatibility fixes:
  - Removes `DEFINER` clauses (incompatible with `root@localhost`)
  - Strips individual `DELIMITER` statements
  - Adds single `DELIMITER $$` wrapper for entire file
  - Intelligently converts only the final `END` or `END;` to `END$$` per routine
  - Preserves nested `BEGIN...END;` blocks within procedures

## Database Schema

### Tables (11)
- `humans` - Main person data
- `persons` - Person details
- `relations` - Family relationships
- `relationnames` - Relationship type names
- `relationtypes` - Relationship type definitions
- `adresses` - Address information
- `APItoDB` - API mapping
- `transnos` - Transaction number tracking
- `testlog` - Debug logging
- `test` - Test data
- `archive` - Archived records

### Functions (10)
- `GetTranNo` - Generate transaction numbers
- `fGetFather` - Get father's PersonID
- `fGetMother` - Get mother's PersonID
- `fGetPartner` - Get partner's PersonID
- `fGetGenderOfPerson` - Get person's gender
- `fGetRelationId` - Get relation ID between two persons
- `fGetParmNamesAndTypes` - Get parameter metadata
- `fPersonExists` - Check if person exists
- `fPersonsArePartners` - Check if two persons are partners
- `fRelationExists` - Check if relation exists

### Procedures (8)
- `getPossibleChildren` - Find possible children for a person
- `getPossibleFathersBasedOnDate` - Find possible fathers by date
- `getPossibleMothers` - Find possible mothers
- `getPossibleMothersBasedOnAge` - Find possible mothers by age
- `getPossibleMothersBasedOnDate` - Find possible mothers by date
- `getPossiblePartners` - Find possible partners
- `getPossiblePartnersBasedOnAge` - Find possible partners by age
- `getPossiblePartnersBasedOnDate` - Find possible partners by date

## Troubleshooting

### Reinitialize Database
If you need to start fresh:
```bash
cd /home/frans/Documenten/dev/Familiez/MW
docker compose down -v  # Delete volume
docker compose up -d    # Recreate and reinitialize
```

### Check Initialization Errors
```bash
docker compose logs mysql | grep ERROR
```

### Verify Container Health
```bash
docker compose ps
docker compose exec mysql mysql -uroot -prootpassword -e "SELECT VERSION();"
```

## Notes
- The database uses MariaDB 10.6 (not MySQL 8.0)
- Init scripts run only on first container startup
- Generated `init/*.sql` files are excluded from version control (see `.gitignore`)
- Always regenerate init files after modifying source SQL files
- `prepare-init.sh` uses `tac` (reverse cat) to intelligently handle nested blocks

## Connection Details
- Host: localhost
- Port: 3306
- Database: humans
- Users:
  - root / rootpassword (admin)
  - HumansService / XHHxECL54EjvhhPSBLMU (application)
