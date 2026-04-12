DELIMITER $$
DROP PROCEDURE IF EXISTS `GetPersonDetails_v2`$$
CREATE PROCEDURE `GetPersonDetails_v2`(IN `PersonIDin` INT(11))
    SQL SECURITY INVOKER
    COMMENT 'Get person details including parents and partner, with partner relation interpreted in both directions'
BEGIN

SELECT
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
    DATE_FORMAT(P.Timestamp, '%Y-%m-%d %T') AS Timestamp,
    M.MotherID,
    M.MotherName,
    F.FatherID,
    F.FatherName,
    PA.PartnerID,
    PA.PartnerName
FROM persons P
LEFT JOIN (
    SELECT
        RM.RelationPerson AS RelationToChild,
        M.PersonID AS MotherID,
        CONCAT(M.PersonGivvenName, ' ', M.PersonFamilyName) AS MotherName
    FROM relations RM
    JOIN relationnames RNM
        ON RM.RelationName = RNM.RelationnameID
       AND RNM.RelationnameName = 'Moeder'
    JOIN persons M
        ON RM.RelationWithPerson = M.PersonID
) AS M
    ON M.RelationToChild = P.PersonID
LEFT JOIN (
    SELECT
        RF.RelationPerson AS RelationToChild,
        F.PersonID AS FatherID,
        CONCAT(F.PersonGivvenName, ' ', F.PersonFamilyName) AS FatherName
    FROM relations RF
    JOIN relationnames RNF
        ON RF.RelationName = RNF.RelationnameID
       AND RNF.RelationnameName = 'Vader'
    JOIN persons F
        ON RF.RelationWithPerson = F.PersonID
) AS F
    ON F.RelationToChild = P.PersonID
LEFT JOIN (
    SELECT
        PairScope.PersonID,
        Partner.PersonID AS PartnerID,
        CONCAT(Partner.PersonGivvenName, ' ', Partner.PersonFamilyName) AS PartnerName
    FROM (
        SELECT DISTINCT
            CASE
                WHEN RP.RelationPerson = PersonIDin THEN RP.RelationPerson
                WHEN RP.RelationWithPerson = PersonIDin THEN RP.RelationWithPerson
                ELSE NULL
            END AS PersonID,
            CASE
                WHEN RP.RelationPerson = PersonIDin THEN RP.RelationWithPerson
                WHEN RP.RelationWithPerson = PersonIDin THEN RP.RelationPerson
                ELSE NULL
            END AS PartnerPersonID
        FROM relations RP
        JOIN relationnames RNP
            ON RP.RelationName = RNP.RelationnameID
           AND RNP.RelationnameName IN ('Partner', 'Echtgenoot', 'Echtgenote')
        WHERE RP.RelationPerson = PersonIDin OR RP.RelationWithPerson = PersonIDin
    ) AS PairScope
    JOIN persons Partner
        ON Partner.PersonID = PairScope.PartnerPersonID
    WHERE PairScope.PersonID IS NOT NULL
    ORDER BY Partner.PersonID
    LIMIT 1
) AS PA
    ON PA.PersonID = P.PersonID
WHERE P.PersonID = PersonIDin;

END$$
DELIMITER ;
