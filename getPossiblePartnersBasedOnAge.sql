DELIMITER $$
CREATE PROCEDURE `getPossiblePartnersBasedOnAge`(IN `PersonAgeIn` DATE)
    SQL SECURITY INVOKER
    COMMENT 'To get the possible partners of a person based on the persons birth'
BEGIN

	SELECT DISTINCT

    

    P.PersonID as PossiblePartnerID, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossiblePartner

    

    FROM persons P 



    WHERE YEAR(P.PersonDateOfBirth) > (YEAR(PersonAgeIn) - 15)

		

		  AND YEAR(P.PersonDateOfBirth) < (YEAR(PersonAgeIn) + 15)

        

    ORDER BY P.PersonDateOfBirth;

 END$$
DELIMITER ;
