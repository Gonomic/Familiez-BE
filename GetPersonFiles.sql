DELIMITER $$
DROP PROCEDURE IF EXISTS `GetPersonFiles`$$
CREATE PROCEDURE `GetPersonFiles`(IN `PersonIDIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'Get all files linked to a person'
BEGIN

    SELECT
        f.FileID,
        f.FileName,
        f.OriginalFileName,
        f.DocumentType,
        f.Year,
        f.FileSize,
        f.MimeType,
        f.CreatedAt,
        f.UploadedBy
    FROM files f
    INNER JOIN person_files pf ON f.FileID = pf.FileID
    WHERE pf.PersonID = PersonIDIn
    ORDER BY f.CreatedAt DESC;

END$$
DELIMITER ;
