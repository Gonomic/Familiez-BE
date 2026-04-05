DELIMITER $$
DROP PROCEDURE IF EXISTS `GetReleasesByComponent`$$
CREATE PROCEDURE `GetReleasesByComponent`(IN `ComponentIn` VARCHAR(10))
    SQL SECURITY INVOKER
    COMMENT 'Get releases and release changes for component fe, mw, or be'
BEGIN

    DECLARE Cmp VARCHAR(10);
    SET Cmp = LOWER(TRIM(ComponentIn));

    IF Cmp = 'fe' THEN
        SELECT
            r.ReleaseID,
            r.ReleaseNumber,
            DATE_FORMAT(r.ReleaseDate, '%Y-%m-%d %H:%i:%s') AS ReleaseDate,
            r.Description,
            c.ChangeID,
            c.ChangeDescription,
            c.ChangeType
        FROM fe_releases r
        LEFT JOIN fe_release_changes c ON c.ReleaseID = r.ReleaseID
        ORDER BY r.ReleaseDate DESC, r.ReleaseID DESC, c.ChangeID ASC;
    ELSEIF Cmp = 'mw' THEN
        SELECT
            r.ReleaseID,
            r.ReleaseNumber,
            DATE_FORMAT(r.ReleaseDate, '%Y-%m-%d %H:%i:%s') AS ReleaseDate,
            r.Description,
            c.ChangeID,
            c.ChangeDescription,
            c.ChangeType
        FROM mw_releases r
        LEFT JOIN mw_release_changes c ON c.ReleaseID = r.ReleaseID
        ORDER BY r.ReleaseDate DESC, r.ReleaseID DESC, c.ChangeID ASC;
    ELSEIF Cmp = 'be' THEN
        SELECT
            r.ReleaseID,
            r.ReleaseNumber,
            DATE_FORMAT(r.ReleaseDate, '%Y-%m-%d %H:%i:%s') AS ReleaseDate,
            r.Description,
            c.ChangeID,
            c.ChangeDescription,
            c.ChangeType
        FROM be_releases r
        LEFT JOIN be_release_changes c ON c.ReleaseID = r.ReleaseID
        ORDER BY r.ReleaseDate DESC, r.ReleaseID DESC, c.ChangeID ASC;
    ELSE
        SELECT
            NULL AS ReleaseID,
            NULL AS ReleaseNumber,
            NULL AS ReleaseDate,
            NULL AS Description,
            NULL AS ChangeID,
            NULL AS ChangeDescription,
            NULL AS ChangeType
        WHERE 1 = 0;
    END IF;

END$$
DELIMITER ;
