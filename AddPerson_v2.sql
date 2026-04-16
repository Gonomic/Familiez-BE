DELIMITER $$
DROP PROCEDURE IF EXISTS `AddPerson_v2`$$
CREATE PROCEDURE `AddPerson_v2`(
    IN `PersonIdIn` INT(11),
    IN `PersonGivvenNameIn` VARCHAR(25),
    IN `PersonFamilyNameIn` VARCHAR(50),
    IN `PersonDateOfBirthIn` DATE,
    IN `PersonPlaceOfBirthIn` VARCHAR(50),
    IN `PersonDateOfDeathIn` DATE,
    IN `PersonPlaceOfDeathIn` VARCHAR(50),
    IN `PersonIsMaleIn` TINYINT(1),
    IN `PersonMotherIdIn` INT(11),
    IN `PersonFatherIdIn` INT(11),
    IN `PersonPartnerIdIn` INT(11),
    IN `PersonDateOfBirthStatusIn` INT(11),
    IN `PersonDateOfDeathStatusIn` INT(11)
)
    SQL SECURITY INVOKER
    COMMENT 'Add person and return the new PersonID in the first result set'
BEGIN
    DECLARE CompletedOk int;
    DECLARE NewTransNo int;
    DECLARE TransResult int;
    DECLARE RecCount int;
    DECLARE IdOfInsertedPerson INT;
    DECLARE MessageText VARCHAR(1024);
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
        INSERT INTO humans.testlog
            SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC AddPerson_v2(). Error occured()=",
                                 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySQLErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),
                TestLogDateTime = NOW();
        SELECT CompletedOk AS CompletedOk, NULL AS PersonID;
    END;

main_proc:
BEGIN
    SET CompletedOk = 0;
    SET TransResult = 0;
    SET NewTransNo = GetTranNo("AddPerson_v2");

    INSERT INTO humans.testlog
        SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ", SPROC AddPerson_v2(). TransResult= ", IFNULL(transResult, null), '. Start add record for person with name ', PersonGivvenNameIn, ' ', PersonFamilyNameIn),
            TestLogDateTime = NOW();

transactionBody:BEGIN
    START TRANSACTION;

        INSERT INTO humans.persons
            (PersonGivvenName,
             PersonFamilyName,
             PersonDateOfBirth,
             PersonPlaceOfBirth,
             PersonDateOfDeath,
             PersonPlaceOfDeath,
             PersonIsMale,
             PersonDateOfBirthStatus,
             PersonDateOfDeathStatus,
             Timestamp)
        VALUES
            (PersonGivvenNameIn,
             PersonFamilyNameIn,
             PersonDateOfBirthIn,
             PersonPlaceOfBirthIn,
             PersonDateOfDeathIn,
             PersonPlaceOfDeathIn,
             PersonIsMaleIn,
             PersonDateOfBirthStatusIn,
             PersonDateOfDeathStatusIn,
             NOW());

        SET IdOfInsertedPerson = LAST_INSERT_ID();
        SET TransResult = 1;
        SET RecCount = 0;

        INSERT INTO humans.testlog
            SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Gegevens zijn toegevoegd van Persoon met naam= ', PersonGivvenNameIn, ' ', PersonFamilyNameIn, '. Assigned autoincrement id= ', IFNULL(IdOfInsertedPerson, null)),
                TestLogDateTime = NOW();

        IF PersonMotherIdIn <=> '' OR PersonMotherIdIn <=> null THEN
            INSERT INTO humans.testlog
            SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Moeder NIET in transactie aanwezig, moeder wordt niet toegevoegd'),
                TestLogDateTime = NOW();
        ELSE
            SET @RelNameID = fGetRelationId("Moeder");
            INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson)
            VALUES (@RelNameID, IdOfInsertedPerson, PersonMotherIdIn);
            SET TransResult = TransResult + 1;
        END IF;

        IF PersonFatherIdIn <=> '' OR PersonFatherIdIn <=> null THEN
            INSERT INTO humans.testlog
            SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Vader NIET in transactie aanwezig, vader wordt niet toegevoegd'),
                TestLogDateTime = NOW();
        ELSE
            SET @RelNameID = fGetRelationId("Vader");
            INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson)
            VALUES (@RelNameID, IdOfInsertedPerson, PersonFatherIdIn);
            SET TransResult = TransResult + 1;
        END IF;

        IF PersonPartnerIdIn <=> '' OR PersonPartnerIdIn <=> null THEN
            INSERT INTO humans.testlog
            SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partner NIET in transactie aanwezig, er wordt geen partner toegevoegd'),
                TestLogDateTime = NOW();
        ELSE
            SET @RelNameID = fGetRelationId("Partner");
            IF fCheckPersonAlreadyExistsAsPartner(PersonPartnerIdIn) THEN
                INSERT INTO humans.testlog
                SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Dubbele registratie! Opgegeven partner was al als partner geregistreerd en wordt NIET opnieuw geregistreerd als partner. Partner ID= ', IFNULL(PersonPartnerIdIn, 'null')),
                    TestLogDateTime = NOW();
            ELSE
                INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson)
                VALUES (@RelNameID, IdOfInsertedPerson, PersonPartnerIdIn);
                SET TransResult = TransResult + 1;
                INSERT INTO humans.relations (RelationName, RelationPerson, RelationWithPerson)
                VALUES (@RelNameID, PersonPartnerIdIn, IdOfInsertedPerson);
                SET TransResult = TransResult + 1;
            END IF;
        END IF;

    COMMIT;
END transactionBody;

    INSERT INTO humans.testlog
        SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Transactie afgerond, alle wijzigingen zijn comitted. Assigned PersonID=', IFNULL(IdOfInsertedPerson, 'null')),
            TestLogDateTime = NOW();

    SELECT CompletedOk AS CompletedOk, IdOfInsertedPerson AS PersonID;
    CALL GetPersonDetails(IdOfInsertedPerson);
END;

END$$
DELIMITER ;
