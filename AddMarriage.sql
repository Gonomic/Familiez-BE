DELIMITER $$
DROP PROCEDURE IF EXISTS `AddMarriage`$$
CREATE PROCEDURE `AddMarriage`(
    IN PersonAIdIn INT(11),
    IN PersonBIdIn INT(11),
    IN StartDateIn DATE
)
    SQL SECURITY INVOKER
    COMMENT 'Add a new marriage record when both persons are valid and have no overlapping marriage periods'
BEGIN
    -- Input/Output variables
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE Result INT DEFAULT 0;
    DECLARE MarriageID INT DEFAULT NULL;
    DECLARE ErrorMessage VARCHAR(255) DEFAULT NULL;
    
    -- Process variables
    DECLARE NewTransNo INT DEFAULT 0;
    DECLARE PartnerALocal INT;
    DECLARE PartnerBLocal INT;
    DECLARE ExistingPersons INT DEFAULT 0;
    DECLARE OverlapCount INT DEFAULT 0;
    DECLARE PartnerRelationOverlapA INT DEFAULT 0;
    DECLARE PartnerRelationOverlapB INT DEFAULT 0;
    DECLARE PartnerRelationTypeId INT DEFAULT 0;
    DECLARE InsertedMarriageId INT DEFAULT NULL;
    
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
                ': AddMarriage error ',
                'State=', ReturnedSqlState,
                ', ErrNo=', MySQLErrNo,
                ', Msg=', MessageText,
                ' [ROLLBACK]'
            ),
            NOW()
        );
        SELECT CompletedOk, Result, MarriageID, ErrorMessage;
    END;
    
    SET NewTransNo = GetTranNo('AddMarriage');

    main_proc: BEGIN
        -- Validate input parameters
        IF PersonAIdIn IS NULL OR PersonBIdIn IS NULL OR StartDateIn IS NULL THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Partner IDs en startdatum zijn verplicht';
            LEAVE main_proc;
        END IF;
        
        IF PersonAIdIn = PersonBIdIn THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Een persoon kan niet met zichzelf trouwen';
            LEAVE main_proc;
        END IF;
        
        -- Normalize partner IDs (lower ID = PartnerA, higher ID = PartnerB)
        SET PartnerALocal = LEAST(PersonAIdIn, PersonBIdIn);
        SET PartnerBLocal = GREATEST(PersonAIdIn, PersonBIdIn);
        
        -- Verify both persons exist
        SELECT COUNT(*) INTO ExistingPersons
        FROM humans.persons
        WHERE PersonID IN (PartnerALocal, PartnerBLocal);
        
        IF ExistingPersons <> 2 THEN
            SET CompletedOk = 1;
            SET Result = 404;
            SET ErrorMessage = 'Een of beide partners bestaan niet';
            LEAVE main_proc;
        END IF;
        
                -- Resolve relation type id for 'Partner'
                SELECT RelationtypeID
                INTO PartnerRelationTypeId
                FROM humans.relationtypes
                WHERE RelationTypeName = 'Partner'
                LIMIT 1;

                IF PartnerRelationTypeId IS NULL OR PartnerRelationTypeId = 0 THEN
                        SET PartnerRelationTypeId = 3;
                END IF;

                -- Check for conflicting partner relations in legacy relations table.
                -- Same-pair partner links are allowed; partner links with someone else are blocked.
        SELECT COUNT(*) INTO PartnerRelationOverlapA
        FROM humans.relations
                WHERE RelationName = PartnerRelationTypeId
                    AND (RelationPerson = PartnerALocal OR RelationWithPerson = PartnerALocal)
                    AND NOT (
                                (RelationPerson = PartnerALocal AND RelationWithPerson = PartnerBLocal)
                         OR (RelationPerson = PartnerBLocal AND RelationWithPerson = PartnerALocal)
                    );
        
        SELECT COUNT(*) INTO PartnerRelationOverlapB
        FROM humans.relations
                WHERE RelationName = PartnerRelationTypeId
                    AND (RelationPerson = PartnerBLocal OR RelationWithPerson = PartnerBLocal)
                    AND NOT (
                                (RelationPerson = PartnerALocal AND RelationWithPerson = PartnerBLocal)
                         OR (RelationPerson = PartnerBLocal AND RelationWithPerson = PartnerALocal)
                    );
        
        IF PartnerRelationOverlapA > 0 THEN
            SET CompletedOk = 1;
            SET Result = 409;
            SET ErrorMessage = 'Partner A heeft al een partnerrelatie met iemand anders';
            LEAVE main_proc;
        END IF;
        
        IF PartnerRelationOverlapB > 0 THEN
            SET CompletedOk = 1;
            SET Result = 409;
            SET ErrorMessage = 'Partner B heeft al een partnerrelatie met iemand anders';
            LEAVE main_proc;
        END IF;
        
        -- Check for overlapping active marriages for either person (marriage table)
        SELECT COUNT(*) INTO OverlapCount
        FROM humans.marriages M
        WHERE (M.PartnerAID IN (PartnerALocal, PartnerBLocal)
               OR M.PartnerBID IN (PartnerALocal, PartnerBLocal))
          AND M.EndDate IS NULL;
        
        IF OverlapCount > 0 THEN
            SET CompletedOk = 1;
            SET Result = 409;
            SET ErrorMessage = 'Een van beide personen heeft al een actief huwelijk';
            LEAVE main_proc;
        END IF;
        
        -- Insert new marriage record
        START TRANSACTION;
        
            INSERT INTO humans.marriages (
                PartnerAID,
                PartnerBID,
                StartDate,
                EndDate,
                EndReason
            ) VALUES (
                PartnerALocal,
                PartnerBLocal,
                StartDateIn,
                NULL,
                NULL
            );
            
            SET InsertedMarriageId = LAST_INSERT_ID();
            SET MarriageID = InsertedMarriageId;
            
            INSERT INTO humans.testlog (
                TestLog,
                TestLogDateTime
            ) VALUES (
                CONCAT(
                    'TransNo-', NewTransNo, 
                    ': AddMarriage insert MarriageID=', MarriageID,
                    ', PartnerAID=', PartnerALocal,
                    ', PartnerBID=', PartnerBLocal,
                    ', StartDate=', StartDateIn
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
        MarriageID,
        ErrorMessage;
END$$
DELIMITER ;