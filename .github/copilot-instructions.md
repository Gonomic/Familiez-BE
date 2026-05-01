# Copilot Instructions — Familiez Backend (BE)

## Technologie
- MariaDB stored procedures, functies en views
- Database: `humans`
- DB-gebruiker: `HumansService` — geen SUPER-rechten

## Sproc-structuur (standaard patroon)

Nieuwe sprocs volgen altijd dit vaste patroon:

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS `SprocNaam`$$
CREATE PROCEDURE `SprocNaam`(
    IN ParamNaamIn TYPE,
    ...
)
    SQL SECURITY INVOKER
    COMMENT 'Korte omschrijving van het doel'
BEGIN
    -- Statusvariabelen
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE NewTransNo INT DEFAULT 0;
    DECLARE Result INT DEFAULT 0;
    DECLARE ErrorMessage VARCHAR(255) DEFAULT NULL;

    -- Foutafhandeling diagnostics
    DECLARE MessageText VARCHAR(255);
    DECLARE ReturnedSqlState VARCHAR(10);
    DECLARE MySQLErrNo INT;

    -- EXIT HANDLER voor SQL-fouten: altijd rollback + log + return
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET CURRENT DIAGNOSTICS CONDITION 1
            MessageText = MESSAGE_TEXT,
            ReturnedSqlState = RETURNED_SQLSTATE,
            MySQLErrNo = MYSQL_ERRNO;
        ROLLBACK;
        SET CompletedOk = 2;
        INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
            CONCAT('TransNo-', IFNULL(NewTransNo, 'null'),
                   ': SprocNaam error State=', ReturnedSqlState,
                   ', ErrNo=', MySQLErrNo,
                   ', Msg=', MessageText, ' [ROLLBACK]'),
            NOW()
        );
        SELECT CompletedOk, Result, ErrorMessage;
    END;

    -- Transactienummer ophalen via helper-functie
    SET NewTransNo = GetTranNo('SprocNaam');

    main_proc: BEGIN
        -- Validaties bovenaan met LEAVE main_proc bij fouten
        IF ParamNaamIn IS NULL THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Parameter mag niet leeg zijn';
            LEAVE main_proc;
        END IF;

        -- Startlog
        INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
            CONCAT('TransNo-', NewTransNo, ': SprocNaam start. Param=', IFNULL(ParamNaamIn, 'null')),
            NOW()
        );

        transactionBody: BEGIN
            START TRANSACTION;
                -- Hoofdlogica hier
            COMMIT;
        END transactionBody;

        SET CompletedOk = 0;
        SET Result = 200;
    END main_proc;

    -- Altijd één SELECT als laatste statement (resultset voor MW)
    SELECT CompletedOk, Result, ErrorMessage;
END$$
DELIMITER ;
```

## Belangrijke conventies

### Parameters
- Input-parameters eindigen op `In`: `PersonIdIn`, `StartDateIn`
- Lokale variabelen zijn descriptief zonder suffix: `PartnerALocal`, `ExistingPersons`

### Transacties & logging
- Elke sproc logt start en fouten naar `humans.testlog`
- Transactienummer altijd via `GetTranNo('SprocNaam')`
- Bij fout: altijd `ROLLBACK` + log + `SELECT CompletedOk=2`
- Bij validatiefout (geen DB-fout): `CompletedOk=1`, geen rollback nodig

### Resultsets
- Altijd exact één `SELECT` als laatste statement — dit is wat MW terugleest
- Returnvelden: minimaal `CompletedOk` (0=ok, 1=validatiefout, 2=DB-fout) en `Result` (HTTP-achtige code)

### Schema & tabellen
- `relations`-tabel: kolommen `RelationPerson`, `RelationWithPerson`, `RelationName` (numeriek)
  - RelationName waarden: 1=Father, 2=Mother, 3=Partner (geen `EndDate`-kolom)
- Gebruik `NULLIF(TRIM(value), '')` voor optionele string-inputs normaliseren
- Partners opslaan als `LEAST(A,B)` / `GREATEST(A,B)` voor consistente volgorde

## Valkuilen
- **Nooit** `DEFINER=...` gebruiken — scripts draaien als `HumansService` zonder SUPER-rechten
- **Altijd** `SQL SECURITY INVOKER`
- Release-scripts met `SOURCE`-statements uitvoeren vanuit de BE-map
- Bestaande sprocs altijd beginnen met `DROP PROCEDURE IF EXISTS` voor idempotente deployments
