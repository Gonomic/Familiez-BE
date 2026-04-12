DELIMITER $$
DROP PROCEDURE IF EXISTS `AddFileForFamily`$$
CREATE PROCEDURE `AddFileForFamily`(
    IN `FilePathIn` VARCHAR(500),
    IN `FileNameIn` VARCHAR(255),
    IN `OriginalFileNameIn` VARCHAR(255),
    IN `DocumentTypeIn` VARCHAR(50),
    IN `YearIn` INT,
    IN `FileSizeIn` BIGINT,
    IN `MimeTypeIn` VARCHAR(100),
    IN `UploadedByIn` VARCHAR(100),
    IN `FatherIDIn` INT,
    IN `MotherIDIn` INT
)
    SQL SECURITY INVOKER
    COMMENT 'Atomically add file metadata and link it to a family'
BEGIN
    DECLARE CompletedOk INT;
    DECLARE NewTransNo INT;
    DECLARE TransResult INT;
    DECLARE FileIDOut INT;

    DECLARE MessageText VARCHAR(1024);
    DECLARE ReturnedSqlState VARCHAR(5);
    DECLARE MySqlErrNo INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET CURRENT DIAGNOSTICS CONDITION 1
            MessageText = MESSAGE_TEXT,
            ReturnedSqlState = RETURNED_SQLSTATE,
            MySqlErrNo = MYSQL_ERRNO;

        ROLLBACK;
        SET CompletedOk = 2;
        SET TransResult = -1;

        INSERT INTO humans.testlog
            SET TestLog = CONCAT(
                'TransAction-', IFNULL(NewTransNo, 'null'),
                '. SPROC AddFileForFamily() failed. State=', IFNULL(ReturnedSqlState, 'null'),
                ', ErrNo=', IFNULL(MySqlErrNo, 'null'),
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
    SET NewTransNo = GetTranNo('AddFileForFamily');

    INSERT INTO humans.testlog
        SET TestLog = CONCAT(
            'TransAction-', IFNULL(NewTransNo, 'null'),
            '. Start SPROC AddFileForFamily(). FatherID=', IFNULL(FatherIDIn, 'null'),
            ', MotherID=', IFNULL(MotherIDIn, 'null')
        ),
            TestLogDateTime = NOW();

    IF FatherIDIn IS NULL OR MotherIDIn IS NULL OR FilePathIn IS NULL OR FileNameIn IS NULL OR DocumentTypeIn IS NULL THEN
        SET CompletedOk = 1;
        SET TransResult = -10;

        INSERT INTO humans.testlog
            SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Invalid input in AddFileForFamily(). CompletedOk=', CompletedOk),
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

    INSERT INTO family_files (FatherID, MotherID, FileID)
    VALUES (FatherIDIn, MotherIDIn, FileIDOut);

    SET TransResult = TransResult + 1;

    COMMIT;

    INSERT INTO humans.testlog
        SET TestLog = CONCAT(
            'TransAction-', IFNULL(NewTransNo, 'null'),
            '. End SPROC AddFileForFamily(). CompletedOk=', CompletedOk,
            ', Result=', TransResult,
            ', FileID=', IFNULL(FileIDOut, 'null')
        ),
            TestLogDateTime = NOW();

    SELECT CompletedOk AS CompletedOk, TransResult AS Result, FileIDOut AS FileID;
END;

END$$
DELIMITER ;
