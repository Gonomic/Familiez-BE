DELIMITER $$
DROP PROCEDURE IF EXISTS `AddFileForPerson`$$
CREATE PROCEDURE `AddFileForPerson`(
    IN `FilePathIn` VARCHAR(500),
    IN `FileNameIn` VARCHAR(255),
    IN `OriginalFileNameIn` VARCHAR(255),
    IN `DocumentTypeIn` VARCHAR(50),
    IN `YearIn` INT,
    IN `FileSizeIn` BIGINT,
    IN `MimeTypeIn` VARCHAR(100),
    IN `UploadedByIn` VARCHAR(100),
    IN `PersonIDIn` INT
)
    SQL SECURITY INVOKER
    COMMENT 'Atomically add file metadata and link it to a person'
BEGIN
    DECLARE CompletedOk INT;
    DECLARE NewTransNo INT;
    DECLARE TransResult INT;
    DECLARE FileIDOut INT;

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
        SET TransResult = -1;

        INSERT INTO humans.testlog
            SET TestLog = CONCAT(
                'TransAction-', IFNULL(NewTransNo, 'null'),
                '. SPROC AddFileForPerson() failed. State=', IFNULL(ReturnedSqlState, 'null'),
                ', ErrNo=', IFNULL(MySQLErrNo, 'null'),
                ', Msg=', IFNULL(MessageText, 'null'),
                '. Rollback executed. CompletedOk=', CompletedOk
            ),
                TestLogDateTime = NOW();

        SELECT CompletedOk AS CompletedOk, TransResult AS Result, NULL AS FileID;
    END;

main_proc:
BEGIN
    SET CompletedOk = 0;
    SET TransResult = 0;
    SET FileIDOut = NULL;
    SET NewTransNo = GetTranNo('AddFileForPerson');

    INSERT INTO humans.testlog
        SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Start SPROC AddFileForPerson(). PersonID=', IFNULL(PersonIDIn, 'null')),
            TestLogDateTime = NOW();

    IF PersonIDIn IS NULL OR FilePathIn IS NULL OR FileNameIn IS NULL OR DocumentTypeIn IS NULL THEN
        SET CompletedOk = 1;
        SET TransResult = -10;

        INSERT INTO humans.testlog
            SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Invalid input in AddFileForPerson(). CompletedOk=', CompletedOk),
                TestLogDateTime = NOW();

        SELECT CompletedOk AS CompletedOk, TransResult AS Result, NULL AS FileID;
        LEAVE main_proc;
    END IF;

    START TRANSACTION;

    INSERT INTO files
        (FilePath, FileName, OriginalFileName, DocumentType, Year, FileSize, MimeType, UploadedBy)
    VALUES
        (FilePathIn, FileNameIn, OriginalFileNameIn, DocumentTypeIn, YearIn, FileSizeIn, MimeTypeIn, UploadedByIn);

    SET FileIDOut = LAST_INSERT_ID();
    SET TransResult = TransResult + 1;

    INSERT INTO person_files (PersonID, FileID)
    VALUES (PersonIDIn, FileIDOut);

    SET TransResult = TransResult + 1;

    COMMIT;

    INSERT INTO humans.testlog
        SET TestLog = CONCAT(
            'TransAction-', IFNULL(NewTransNo, 'null'),
            '. End SPROC AddFileForPerson(). CompletedOk=', CompletedOk,
            ', Result=', TransResult,
            ', FileID=', IFNULL(FileIDOut, 'null')
        ),
            TestLogDateTime = NOW();

    SELECT CompletedOk AS CompletedOk, TransResult AS Result, FileIDOut AS FileID;
END;

END$$
DELIMITER ;
