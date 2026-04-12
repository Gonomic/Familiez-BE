DELIMITER $$
DROP PROCEDURE IF EXISTS `GetFamilyFiles`$$
CREATE PROCEDURE `GetFamilyFiles`(IN `FatherIDIn` INT, IN `MotherIDIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'Get all files linked to a parent couple'
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
    INNER JOIN family_files ff ON f.FileID = ff.FileID
    WHERE ff.FatherID = FatherIDIn
      AND ff.MotherID = MotherIDIn
    ORDER BY f.CreatedAt DESC;

END$$
DELIMITER ;
