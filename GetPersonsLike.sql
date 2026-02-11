-- Get persons with names like the search string
DELIMITER $$
DROP PROCEDURE IF EXISTS `GetPersonsLike`$$
CREATE PROCEDURE `GetPersonsLike`(
    IN stringToSearchFor VARCHAR(100)
)
    SQL SECURITY INVOKER
    COMMENT 'Returns persons whose names contain the search string'
BEGIN
    SELECT 
        PersonID,
        CONCAT_WS(' ', PersonGivvenName, PersonFamilyName) AS FullName,
        PersonGivvenName,
        PersonFamilyName,
        PersonDateOfBirth,
        PersonDateOfDeath,
        PersonIsMale
    FROM 
        humans.persons
    WHERE 
        CONCAT_WS(' ', PersonGivvenName, PersonFamilyName) LIKE CONCAT('%', stringToSearchFor, '%')
        OR PersonGivvenName LIKE CONCAT('%', stringToSearchFor, '%')
        OR PersonFamilyName LIKE CONCAT('%', stringToSearchFor, '%')
    ORDER BY 
        PersonFamilyName, PersonGivvenName
    LIMIT 50;
END$$
DELIMITER ;
