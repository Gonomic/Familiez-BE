CREATE PROCEDURE `getPossibleChildren`(IN `ParentId` INT)
    SQL SECURITY INVOKER
    COMMENT 'To get the possible children for a person '
BEGIN

	DECLARE BirthDateOfParent date;
    
    SET BirthDateOfParent = fGetBirthDateOfPerson(ParentId);

	SELECT DISTINCT

		P.PersonID as PossibleChildID, 

		concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossibleChild,
        
        P.PersonDateOfBirth as BirthDate,
        
        P.PersonDateOfDeath 
        
    FROM persons P 

		WHERE P.PersonID <> ParentId

		AND YEAR(P.PersonDateOfBirth) > (YEAR(BirthDateOfParent) + 10)

		AND YEAR(P.PersonDateOfBirth) < (YEAR(BirthDateOfParent) + 65)
        
        and P.PersonID NOT in
        
			(SELECT RelationPerson
            FROM relations
            WHERE RelationPerson = P.PersonID
            AND RelationName = 1
            OR RelationName = 2)

       ORDER BY P.PersonDateOfBirth;

 END