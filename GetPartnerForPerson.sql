DELIMITER $$
DROP PROCEDURE IF EXISTS `GetPartnerForPerson`$$
CREATE PROCEDURE `GetPartnerForPerson`(IN `PersonIDIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'Get one partner for a person, interpreting partner relation in both directions'
BEGIN

    SELECT DISTINCT
        P.PersonID,
        P.PersonGivvenName,
        P.PersonFamilyName,
        P.PersonDateOfBirth,
        P.PersonDateOfDeath
    FROM relations R
    JOIN relationnames RN
        ON R.RelationName = RN.RelationnameID
    JOIN persons P
        ON P.PersonID = CASE
            WHEN R.RelationPerson = PersonIDIn THEN R.RelationWithPerson
            ELSE R.RelationPerson
        END
    WHERE (R.RelationPerson = PersonIDIn OR R.RelationWithPerson = PersonIDIn)
      AND RN.RelationnameName IN ('Partner', 'Echtgenoot', 'Echtgenote')
    ORDER BY P.PersonID
    LIMIT 1;

END$$
DELIMITER ;
