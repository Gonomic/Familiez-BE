DELIMITER $$
CREATE PROCEDURE `GetPersonDetails`(IN `PersonIDin` INT(11))
    SQL SECURITY INVOKER
    COMMENT 'To get the details of a specific person'
BEGIN

SELECT DISTINCT

    

    P.PersonID, 

    P.PersonGivvenName,

    P.PersonFamilyName,

    P.PersonDateOfBirth,

    P.PersonPlaceOfBirth,

    P.PersonDateOfDeath,

    P.PersonPlaceOfDeath,

    P.PersonIsMale,
    
    P.PersonDateOfBirthStatus,
    
    P.PersonDateOfDeathStatus,

    DATE_FORMAT(P.Timestamp,'%Y-%m-%d %T') as Timestamp, 

	M.MotherID,

    M.MotherName,

    F.FatherID,

    F.FatherName,

    PA.PartnerID,

    PA.PartnerName



	FROM relations R



	RIGHT JOIN (SELECT DISTINCT

		  *

          FROM persons P

          WHERE P.PersonID = PersonIDin) as P

          ON R.RelationPerson = P.PersonID    

   

	LEFT JOIN (SELECT DISTINCT

		  M.PersonID as MotherID,

          concat(M.PersonGivvenName, ' ', M.PersonFamilyName) as MotherName,

          RM.RelationPerson as RelationToChild 

		  FROM relations RM

          JOIN relationnames RNM ON RM.RelationName = RNM.RelationnameID AND RNM.RelationnameName = "Moeder"

          JOIN persons M ON RM.RelationWithPerson = M.PersonID

		  WHERE RM.RelationPerson = PersonIDin) as M

		  ON R.RelationPerson = M.RelationToChild

    

	LEFT JOIN (SELECT DISTINCT

		  F.PersonID as FatherID,

          concat(F.PersonGivvenName, ' ', F.PersonFamilyName) as FatherName,

          RF.RelationPerson as RelationToChild 

		  FROM relations RF

          JOIN relationnames RNF ON RF.RelationName = RNF.RelationnameID AND RNF.RelationnameName = "Vader"

          JOIN persons F ON RF.RelationWithPerson = F.PersonID

		  WHERE RF.RelationPerson = PersonIDin) as F

		  ON R.RelationPerson = F.RelationToChild   

    

	LEFT JOIN (SELECT DISTINCT

		  PA.PersonID as PartnerID,

          concat(PA.PersonGivvenName, ' ', PA.PersonFamilyName) as PartnerName,

          RP.RelationPerson as RelationToPartner 

		  FROM relations RP

          JOIN relationnames RNP ON RP.RelationName = RNP.RelationnameID AND RNP.RelationnameName = "Partner"

          JOIN persons PA ON RP.RelationWithPerson = PA.PersonID

		  WHERE RP.RelationPerson = PersonIDin) as PA

		  ON R.RelationPerson = PA.RelationToPartner   

          

    WHERE PersonID = PersonIDin;

 END$$
DELIMITER ;
