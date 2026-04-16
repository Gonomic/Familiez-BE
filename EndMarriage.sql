DELIMITER $$
DROP PROCEDURE IF EXISTS `EndMarriage`$$
CREATE PROCEDURE `EndMarriage`(
    IN PersonAIdIn INT(11),
    IN PersonBIdIn INT(11),
    IN EndDateIn DATE,
    IN EndReasonIn VARCHAR(50)
)
    SQL SECURITY INVOKER
    COMMENT 'End the active marriage for a normalized pair by setting EndDate and EndReason'
BEGIN
    -- Input/Output variables
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE Result INT DEFAULT 0;
    DECLARE ErrorMessage VARCHAR(255) DEFAULT NULL;
    
    -- Process variables
    DECLARE NewTransNo INT DEFAULT 0;
    DECLARE PartnerALocal INT;
    DECLARE PartnerBLocal INT;
    DECLARE ActiveMarriageId INT DEFAULT NULL;
    DECLARE MarriageStartDate DATE DEFAULT NULL;
    DECLARE NormalizedEndReason VARCHAR(50);
    
    -- Error handler variables
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
        INSERT INTO humans.testlog (
            TestLog,
            TestLogDateTime
        ) VALUES (
            CONCAT(
                'TransNo-', IFNULL(NewTransNo, 'null'),
                ': EndMarriage error ',
                'State=', ReturnedSqlState,
                ', ErrNo=', MySQLErrNo,
                ', Msg=', MessageText,
                ' [ROLLBACK]'
            ),
            NOW()
        );
        SELECT CompletedOk, Result, ErrorMessage;
    END;
    
    SET NewTransNo = GetTranNo('EndMarriage');
    SET NormalizedEndReason = LOWER(TRIM(IFNULL(EndReasonIn, '')));
    
    main_proc: BEGIN
        IF PersonAIdIn IS NULL OR PersonBIdIn IS NULL OR EndDateIn IS NULL OR NormalizedEndReason = '' THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Partner IDs, einddatum en eindreden zijn verplicht';
            LEAVE main_proc;
        END IF;
        
        IF PersonAIdIn = PersonBIdIn THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Een persoon kan niet met zichzelf gehuwd zijn';
            LEAVE main_proc;
        END IF;
        
        IF NormalizedEndReason NOT IN ('scheiding', 'overlijden_een_partner', 'overlijden_beide_partners', 'onbekend') THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Ongeldige eindreden';
            LEAVE main_proc;
        END IF;
        
        -- Normalize partner IDs
        SET PartnerALocal = LEAST(PersonAIdIn, PersonBIdIn);
        SET PartnerBLocal = GREATEST(PersonAIdIn, PersonBIdIn);
        
        -- Find active marriage for the pair
        SELECT MarriageID, StartDate
        INTO ActiveMarriageId, MarriageStartDate
        FROM humans.marriages
        WHERE PartnerAID = PartnerALocal
          AND PartnerBID = PartnerBLocal
          AND EndDate IS NULL
        ORDER BY StartDate DESC
        LIMIT 1;
        
        IF ActiveMarriageId IS NULL THEN
            SET CompletedOk = 1;
            SET Result = 404;
            SET ErrorMessage = 'Geen actief huwelijk gevonden voor dit paar';
            LEAVE main_proc;
        END IF;
        
        IF EndDateIn < MarriageStartDate THEN
            SET CompletedOk = 1;
            SET Result = 422;
            SET ErrorMessage = 'Einddatum kan niet voor de startdatum liggen';
            LEAVE main_proc;
        END IF;
        
        -- Update marriage record with end date and reason
        START TRANSACTION;
        
            UPDATE humans.marriages
            SET EndDate = EndDateIn,
                EndReason = NormalizedEndReason
            WHERE MarriageID = ActiveMarriageId;
            
            INSERT INTO humans.testlog (
                TestLog,
                TestLogDateTime
            ) VALUES (
                CONCAT(
                    'TransNo-', NewTransNo,
                    ': EndMarriage update MarriageID=', ActiveMarriageId,
                    ', EndDate=', EndDateIn,
                    ', EndReason=', NormalizedEndReason
                ),
                NOW()
            );
            
        COMMIT;
        SET CompletedOk = 0;
        SET Result = 0;
        
    END main_proc;
    
    SELECT 
        CompletedOk,
        Result,
        ErrorMessage;
END$$
DELIMITER ;