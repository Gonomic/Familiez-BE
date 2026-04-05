DELIMITER $$
DROP PROCEDURE IF EXISTS `GetFileMeta`$$
CREATE PROCEDURE `GetFileMeta`(IN `FileIDIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'Get file metadata for download and thumbnail endpoints'
BEGIN

    SELECT
        FileID,
        FilePath,
        FileName,
        OriginalFileName,
        MimeType,
        DocumentType,
        Year,
        FileSize,
        CreatedAt,
        UploadedBy
    FROM files
    WHERE FileID = FileIDIn;

END$$
DELIMITER ;
