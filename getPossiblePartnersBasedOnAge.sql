DELIMITER $$
CREATE PROCEDURE `getPossiblePartnersBasedOnAge`(IN `PersonAgeIn` DATE)
    SQL SECURITY INVOKER
    COMMENT 'To get the possible partners of a person based on the persons birth'
BEGIN

	SELECT DISTINCT

    
    P.PersonID as PossiblePartnerID, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossiblePartner,

    P.PersonDateOfBirth as PersonDateOfBirth,

    P.PersonDateOfBirth as SortDate,

    P.PersonDateOfDeath

    FROM persons P 



    WHERE YEAR(P.PersonDateOfBirth) > (YEAR(PersonAgeIn) - 60)

		

	  AND YEAR(P.PersonDateOfBirth) < (YEAR(PersonAgeIn) + 60)

        

    ORDER BY SortDate;

 END$$
DELIMITER ;
