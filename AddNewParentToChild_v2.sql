DELIMITER $$
DROP PROCEDURE IF EXISTS `AddNewParentToChild_v2`$$
CREATE PROCEDURE `AddNewParentToChild_v2`(
    IN KindIdIn INT(11),
    IN GeslachtIn TINYINT(1),
    IN VoornaamIn VARCHAR(25),
    IN AchternaamIn VARCHAR(50),
    IN GeboortedatumIn DATE,
    IN GeboorteplaatsIn VARCHAR(50),
    IN OverlijdensdatumIn DATE,
    IN OverlijdensplaatsIn VARCHAR(80),
    IN PartnerIdIn INT(11),
    IN HuwelijksdatumIn DATE,
    IN HuwelijksplaatsIn VARCHAR(100),
    IN GeboortedatumStatusIn TINYINT,
    IN OverlijdensdatumStatusIn TINYINT,
    IN HuwelijksdatumStatusIn TINYINT
)
    SQL SECURITY INVOKER
    COMMENT 'Add a parent and optional marriage while preserving exact or estimated date status'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE Result INT DEFAULT 0;
    DECLARE NewPersonID INT DEFAULT NULL;
    DECLARE ErrorMessage VARCHAR(255) DEFAULT NULL;
    DECLARE NewTransNo INT DEFAULT 0;
    DECLARE ParentRelationType INT DEFAULT 0;
    DECLARE PartnerParentRelationType INT DEFAULT 0;
    DECLARE PartnerIsMaleLocal TINYINT(1) DEFAULT NULL;
    DECLARE PartnerHasOtherPartnerLocal TINYINT(1) DEFAULT 0;
    DECLARE NormalizedGivenName VARCHAR(25);
    DECLARE NormalizedFamilyName VARCHAR(50);
    DECLARE NormalizedBirthPlace VARCHAR(50);
    DECLARE NormalizedDeathPlace VARCHAR(80) DEFAULT NULL;
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
        SET Result = 500;
        SET ErrorMessage = CONCAT('Databasefout: ', IFNULL(MessageText, 'onbekende fout'));
        INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
            CONCAT('TransNo-', IFNULL(NewTransNo, 'null'), ': AddNewParentToChild_v2 error State=',
                   IFNULL(ReturnedSqlState, 'null'), ', ErrNo=', IFNULL(MySQLErrNo, 'null'),
                   ', Msg=', IFNULL(MessageText, 'null'), ' [ROLLBACK]'),
            NOW()
        );
        SELECT CompletedOk, Result, NewPersonID, ErrorMessage;
    END;

    SET NewTransNo = GetTranNo('AddNewParentToChild_v2');
    INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
        CONCAT('TransNo-', IFNULL(NewTransNo, 'null'), ': AddNewParentToChild_v2 start'),
        NOW()
    );

    main_proc: BEGIN
        IF KindIdIn IS NULL OR KindIdIn <= 0 THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'KindId is verplicht';
            LEAVE main_proc;
        END IF;

        IF GeslachtIn IS NULL OR GeslachtIn NOT IN (0, 1) THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Geslacht moet 0 (vrouwelijk) of 1 (mannelijk) zijn';
            LEAVE main_proc;
        END IF;

        IF NULLIF(TRIM(VoornaamIn), '') IS NULL
           OR NULLIF(TRIM(AchternaamIn), '') IS NULL
           OR GeboortedatumIn IS NULL
           OR NULLIF(TRIM(GeboorteplaatsIn), '') IS NULL THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'Voornaam, achternaam, geboortedatum en geboorteplaats zijn verplicht';
            LEAVE main_proc;
        END IF;

        IF GeboortedatumStatusIn IS NULL OR GeboortedatumStatusIn NOT IN (1, 2) THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'GeboortedatumStatus moet 1 (exact) of 2 (geschat) zijn';
            LEAVE main_proc;
        END IF;

        IF (OverlijdensdatumIn IS NULL AND OverlijdensdatumStatusIn IS NOT NULL)
           OR (OverlijdensdatumIn IS NOT NULL
               AND (OverlijdensdatumStatusIn IS NULL OR OverlijdensdatumStatusIn NOT IN (1, 2))) THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'OverlijdensdatumStatus moet leeg zijn zonder datum, anders 1 (exact) of 2 (geschat)';
            LEAVE main_proc;
        END IF;

        IF (HuwelijksdatumIn IS NULL AND HuwelijksdatumStatusIn IS NOT NULL)
           OR (HuwelijksdatumIn IS NOT NULL
               AND (HuwelijksdatumStatusIn IS NULL OR HuwelijksdatumStatusIn NOT IN (1, 2))) THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'HuwelijksdatumStatus moet leeg zijn zonder datum, anders 1 (exact) of 2 (geschat)';
            LEAVE main_proc;
        END IF;

        IF PartnerIdIn IS NOT NULL AND PartnerIdIn <= 0 THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'PartnerId moet groter zijn dan 0';
            LEAVE main_proc;
        END IF;

        SET NormalizedGivenName = TRIM(VoornaamIn);
        SET NormalizedFamilyName = TRIM(AchternaamIn);
        SET NormalizedBirthPlace = TRIM(GeboorteplaatsIn);
        SET NormalizedDeathPlace = NULLIF(TRIM(OverlijdensplaatsIn), '');
        SET NormalizedMarriagePlace = NULLIF(TRIM(HuwelijksplaatsIn), '');

        START TRANSACTION;

        IF fPersonExists(KindIdIn) = 0 THEN
            ROLLBACK;
            SET CompletedOk = 1;
            SET Result = 404;
            SET ErrorMessage = 'KindId bestaat niet';
            LEAVE main_proc;
        END IF;

        IF PartnerIdIn IS NOT NULL AND PartnerIdIn = KindIdIn THEN
            ROLLBACK;
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'KindId en PartnerId mogen niet hetzelfde zijn';
            LEAVE main_proc;
        END IF;

        IF PartnerIdIn IS NOT NULL AND fPersonExists(PartnerIdIn) = 0 THEN
            ROLLBACK;
            SET CompletedOk = 1;
            SET Result = 404;
            SET ErrorMessage = 'PartnerId bestaat niet';
            LEAVE main_proc;
        END IF;

        IF fPersonExistsByIdentity(
            GeslachtIn,
            NormalizedGivenName,
            NormalizedFamilyName,
            GeboortedatumIn
        ) = 1 THEN
            ROLLBACK;
            SET CompletedOk = 1;
            SET Result = 409;
            SET ErrorMessage = CONCAT(
                'De toe te voegen ', IF(GeslachtIn = 1, 'Vader', 'Moeder'),
                ' bestaat al als persoon in de database.'
            );
            INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
                CONCAT('TransNo-', NewTransNo, ': duplicate parent identity; transaction rolled back'),
                NOW()
            );
            LEAVE main_proc;
        END IF;

        IF PartnerIdIn IS NOT NULL THEN
            SET PartnerHasOtherPartnerLocal = fPersonHasOtherPartner(PartnerIdIn);

            IF PartnerHasOtherPartnerLocal = 0 THEN
                SELECT PersonIsMale INTO PartnerIsMaleLocal
                FROM humans.persons
                WHERE PersonID = PartnerIdIn;

                IF PartnerIsMaleLocal IS NULL OR PartnerIsMaleLocal NOT IN (0, 1) THEN
                    ROLLBACK;
                    SET CompletedOk = 1;
                    SET Result = 409;
                    SET ErrorMessage = 'Geslacht van de opgegeven partner is onbekend';
                    LEAVE main_proc;
                END IF;
            END IF;
        END IF;

        INSERT INTO humans.persons (
            PersonGivvenName,
            PersonFamilyName,
            PersonDateOfBirth,
            PersonPlaceOfBirth,
            PersonDateOfDeath,
            PersonPlaceOfDeath,
            PersonIsMale,
            PersonDateOfBirthStatus,
            PersonDateOfDeathStatus,
            Timestamp
        ) VALUES (
            NormalizedGivenName,
            NormalizedFamilyName,
            GeboortedatumIn,
            NormalizedBirthPlace,
            OverlijdensdatumIn,
            NormalizedDeathPlace,
            GeslachtIn,
            GeboortedatumStatusIn,
            OverlijdensdatumStatusIn,
            NOW()
        );

        SET NewPersonID = LAST_INSERT_ID();
        SET ParentRelationType = IF(GeslachtIn = 1, 1, 2);
        INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson)
        VALUES (ParentRelationType, KindIdIn, NewPersonID);

        IF PartnerIdIn IS NOT NULL THEN
            IF PartnerHasOtherPartnerLocal = 1 THEN
                SET ErrorMessage = 'Het opgegeven PartnerId heeft al een partnerrelatie met een andere persoon. Het partnerschap is niet aangemaakt.';
                INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
                    CONCAT('TransNo-', NewTransNo, ': partner already has another partner; optional relations skipped'),
                    NOW()
                );
            ELSE
                INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson)
                VALUES (3, NewPersonID, PartnerIdIn);
                INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson)
                VALUES (3, PartnerIdIn, NewPersonID);

                SET PartnerParentRelationType = IF(PartnerIsMaleLocal = 1, 1, 2);
                IF fRelationExists(KindIdIn, PartnerParentRelationType, PartnerIdIn) = 0 THEN
                    INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson)
                    VALUES (PartnerParentRelationType, KindIdIn, PartnerIdIn);
                END IF;

                IF HuwelijksdatumIn IS NOT NULL THEN
                    INSERT INTO humans.marriages (
                        PartnerAID,
                        PartnerBID,
                        StartDate,
                        StartDateStatus,
                        MarriagePlace,
                        EndDate,
                        EndDateStatus,
                        EndReason
                    ) VALUES (
                        LEAST(NewPersonID, PartnerIdIn),
                        GREATEST(NewPersonID, PartnerIdIn),
                        HuwelijksdatumIn,
                        HuwelijksdatumStatusIn,
                        NormalizedMarriagePlace,
                        NULL,
                        NULL,
                        NULL
                    );
                END IF;
            END IF;
        END IF;

        SET CompletedOk = 0;
        SET Result = 200;
        INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
            CONCAT('TransNo-', NewTransNo, ': AddNewParentToChild_v2 committed PersonID=', NewPersonID),
            NOW()
        );
        COMMIT;
    END main_proc;

    SELECT CompletedOk, Result, NewPersonID, ErrorMessage;
END$$
DELIMITER ;
