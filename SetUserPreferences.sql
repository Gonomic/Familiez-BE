DELIMITER $$
DROP PROCEDURE IF EXISTS `SetUserPreferences`$$
CREATE PROCEDURE `SetUserPreferences`(
    IN UsernameIn VARCHAR(100),
    IN PersonIdIn INT,
    IN GenUpIn INT,
    IN GenDownIn INT,
    IN AutoShowIn TINYINT(1)
)
    SQL SECURITY INVOKER
    COMMENT 'Insert or update linked tree preferences for one username'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE Result INT DEFAULT 0;
    DECLARE ErrorMessage VARCHAR(255) DEFAULT NULL;

    DECLARE NewTransNo INT DEFAULT 0;
    DECLARE NormalizedUsername VARCHAR(100) DEFAULT NULL;
    DECLARE NormalizedPersonId INT DEFAULT NULL;
    DECLARE NormalizedGenUp INT DEFAULT 3;
    DECLARE NormalizedGenDown INT DEFAULT 3;
    DECLARE NormalizedAutoShow TINYINT(1) DEFAULT 0;
    DECLARE LinkedPersonExists INT DEFAULT 0;

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
                ': SetUserPreferences error ',
                'State=', ReturnedSqlState,
                ', ErrNo=', MySQLErrNo,
                ', Msg=', MessageText,
                ' [ROLLBACK]'
            ),
            NOW()
        );
        SELECT CompletedOk, Result, ErrorMessage;
    END;

    SET NewTransNo = GetTranNo('SetUserPreferences');

    main_proc: BEGIN
        SET NormalizedUsername = TRIM(UsernameIn);

        IF NormalizedUsername IS NULL OR NormalizedUsername = '' THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'username is verplicht';
            LEAVE main_proc;
        END IF;

        SET NormalizedGenUp = COALESCE(GenUpIn, 3);
        SET NormalizedGenDown = COALESCE(GenDownIn, 3);
        SET NormalizedAutoShow = IF(COALESCE(AutoShowIn, 0) <> 0, 1, 0);
        SET NormalizedPersonId = PersonIdIn;

        IF NormalizedGenUp < 0 OR NormalizedGenUp > 10 THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'generations_up moet tussen 0 en 10 liggen';
            LEAVE main_proc;
        END IF;

        IF NormalizedGenDown < 0 OR NormalizedGenDown > 10 THEN
            SET CompletedOk = 1;
            SET Result = 400;
            SET ErrorMessage = 'generations_down moet tussen 0 en 10 liggen';
            LEAVE main_proc;
        END IF;

        IF NormalizedPersonId IS NOT NULL THEN
            IF NormalizedPersonId <= 0 THEN
                SET CompletedOk = 1;
                SET Result = 400;
                SET ErrorMessage = 'linked_person_id moet groter zijn dan 0';
                LEAVE main_proc;
            END IF;

            SELECT COUNT(*)
            INTO LinkedPersonExists
            FROM humans.persons
            WHERE PersonID = NormalizedPersonId;

            IF LinkedPersonExists = 0 THEN
                SET CompletedOk = 1;
                SET Result = 404;
                SET ErrorMessage = 'linked_person_id bestaat niet in persons';
                LEAVE main_proc;
            END IF;
        END IF;

        START TRANSACTION;

            INSERT INTO humans.familiez_user_preferences (
                username,
                linked_person_id,
                generations_up,
                generations_down,
                auto_show_tree
            ) VALUES (
                NormalizedUsername,
                NormalizedPersonId,
                NormalizedGenUp,
                NormalizedGenDown,
                NormalizedAutoShow
            )
            ON DUPLICATE KEY UPDATE
                linked_person_id = VALUES(linked_person_id),
                generations_up = VALUES(generations_up),
                generations_down = VALUES(generations_down),
                auto_show_tree = VALUES(auto_show_tree);

            INSERT INTO humans.testlog (
                TestLog,
                TestLogDateTime
            ) VALUES (
                CONCAT(
                    'TransNo-', NewTransNo,
                    ': SetUserPreferences username=', NormalizedUsername,
                    ', linked_person_id=', IFNULL(NormalizedPersonId, '(null)'),
                    ', generations_up=', NormalizedGenUp,
                    ', generations_down=', NormalizedGenDown,
                    ', auto_show_tree=', NormalizedAutoShow
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
