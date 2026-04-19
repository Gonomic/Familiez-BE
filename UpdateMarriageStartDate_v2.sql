DELIMITER $$
DROP PROCEDURE IF EXISTS `UpdateMarriageStartDate_v2`$$
CREATE PROCEDURE `UpdateMarriageStartDate_v2`(
    IN MarriageIdIn INT(11),
    IN PersonAIdIn INT(11),
    IN PersonBIdIn INT(11),
    IN StartDateIn DATE,
    IN MarriagePlaceIn VARCHAR(100)
)
    SQL SECURITY INVOKER
    COMMENT 'Update start date and optional place of active marriage for a pair with overlap validation against all other marriages for both persons'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE Result INT DEFAULT 0;
    DECLARE UpdatedMarriageID INT DEFAULT NULL;
    DECLARE ErrorMessage VARCHAR(255) DEFAULT NULL;

    DECLARE NewTransNo INT DEFAULT 0;
    DECLARE PartnerALocal INT;
    DECLARE PartnerBLocal INT;
    DECLARE ActiveMarriageId INT DEFAULT NULL;
    DECLARE ExistingPersons INT DEFAULT 0;
    DECLARE OverlapCount INT DEFAULT 0;
    DECLARE NormalizedMarriagePlace VARCHAR(100) DEFAULT NULL;

    DECLARE MessageText VARCHAR(255);
    DECLARE ReturnedSqlState VARCHAR(10);
    DECLARE MySQLErrNo INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET CURRENT DIAGNOSTICS CONDITION 1
            MessageText = MESSAGE_TEXT,
            ReturnedSqlState = RETURNED_SQLSTATE,
            MySQLErrNo = MYSQL_ERRNO;
        ROLLBACK;
        SET CompletedOk = 2;
        SET Result = -1;
        SET ErrorMessage = CONCAT('Database error: ', MessageText);
        INSERT INTO humans.testlog (TestLog, TestLogDateTime)
        VALUES (
            CONCAT(
                'TransNo-', IFNULL(NewTransNo, 'null'),
                ': UpdateMarriageStartDate_v2 error ',
                'State=', ReturnedSqlState,
                ', ErrNo=', MySQLErrNo,
                ', Msg=', MessageText,
                ' [ROLLBACK]'
            ),
            NOW()
        );
        SELECT CompletedOk, Result, UpdatedMarriageID AS MarriageID, ErrorMessage;
    END;

    SET NewTransNo = GetTranNo('UpdateMarriageStartDate_v2');

    main_proc: BEGIN
        IF MarriageIdIn IS NULL OR PersonAIdIn IS NULL OR PersonBIdIn IS NULL OR StartDateIn IS NULL THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'MarriageID, partner IDs en startdatum zijn verplicht';
            LEAVE main_proc;
        END IF;

        IF PersonAIdIn = PersonBIdIn THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Een persoon kan niet met zichzelf trouwen';
            LEAVE main_proc;
        END IF;

        SET PartnerALocal = LEAST(PersonAIdIn, PersonBIdIn);
        SET PartnerBLocal = GREATEST(PersonAIdIn, PersonBIdIn);
        SET NormalizedMarriagePlace = NULLIF(TRIM(MarriagePlaceIn), '');

        SELECT COUNT(*) INTO ExistingPersons
        FROM humans.persons
        WHERE PersonID IN (PartnerALocal, PartnerBLocal);

        IF ExistingPersons <> 2 THEN
            SET CompletedOk = 1;
            SET Result = 404;
            SET ErrorMessage = 'Een of beide partners bestaan niet';
            LEAVE main_proc;
        END IF;

        SELECT M.MarriageID
        INTO ActiveMarriageId
        FROM humans.marriages M
        WHERE M.MarriageID = MarriageIdIn
          AND M.EndDate IS NULL
        LIMIT 1;

        IF ActiveMarriageId IS NULL THEN
            SET CompletedOk = 1;
            SET Result = 404;
            SET ErrorMessage = 'Geen actief huwelijk gevonden voor dit paar';
            LEAVE main_proc;
        END IF;

        SELECT COUNT(*) INTO OverlapCount
        FROM humans.marriages M
        WHERE M.MarriageID <> ActiveMarriageId
          AND (M.PartnerAID IN (PartnerALocal, PartnerBLocal)
               OR M.PartnerBID IN (PartnerALocal, PartnerBLocal))
          AND (M.EndDate IS NULL OR M.EndDate >= StartDateIn);

        IF OverlapCount > 0 THEN
            SET CompletedOk = 1;
            SET Result = 409;
            SET ErrorMessage = 'Startdatum overlapt met een andere huwelijksperiode van een van beide partners';
            LEAVE main_proc;
        END IF;

        START TRANSACTION;

            UPDATE humans.marriages
            SET PartnerAID = PartnerALocal,
                PartnerBID = PartnerBLocal,
                StartDate = StartDateIn,
                MarriagePlace = NormalizedMarriagePlace
            WHERE humans.marriages.MarriageID = ActiveMarriageId;

            SET UpdatedMarriageID = ActiveMarriageId;

            INSERT INTO humans.testlog (TestLog, TestLogDateTime)
            VALUES (
                CONCAT(
                    'TransNo-', NewTransNo,
                    ': UpdateMarriageStartDate_v2 update MarriageID=', ActiveMarriageId,
                    ', PartnerAID=', PartnerALocal,
                    ', PartnerBID=', PartnerBLocal,
                    ', StartDate=', StartDateIn,
                    ', MarriagePlace=', IFNULL(NormalizedMarriagePlace, '(null)')
                ),
                NOW()
            );

        COMMIT;

        SET CompletedOk = 0;
        SET Result = 0;

    END main_proc;

    SELECT CompletedOk, Result, UpdatedMarriageID AS MarriageID, ErrorMessage;
END$$
DELIMITER ;
