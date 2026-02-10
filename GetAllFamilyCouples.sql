DELIMITER $$
CREATE PROCEDURE `GetAllFamilyCouples`(IN `YearFrom` INT(4), IN `FamilyName` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To get all couples or couples with a specific familyname'
BEGIN

SELECT DISTINCT

    CONCAT(Person.PersonGivvenName, ' ', Person.PersonFamilyName) AS 'Person',

    Person.PersonID AS 'PersonID',

    CONCAT(Partner.PersonGivvenName, ' ', Partner.PersonFamilyName) AS 'Partner',

    Partner.PersonID AS 'PartnerID'

  FROM relations AllRelations

    #   Get all records from relations which define partnership

    INNER JOIN relationnames IsPartner

      ON AllRelations.RelationName = IsPartner.RelationNameID

      AND IsPartner.RelationnameName = 'Partner'

    #   Get the first partner 

    INNER JOIN persons Person

      ON AllRelations.RelationPerson = Person.PersonID

  # Get the second partner

    INNER JOIN persons Partner

      ON AllRelations.RelationWithPerson = Partner.PersonID  

  WHERE Person.PersonFamilyName LIKE CONCAT(FamilyName, '%')

  AND YEAR(Person.PersonDateOfBirth) >= YearFrom

  ORDER BY Person.PersonFamilyName, Person.PersonDateOfBirth;

END$$
DELIMITER ;
