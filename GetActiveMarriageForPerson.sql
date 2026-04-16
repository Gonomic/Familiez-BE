DELIMITER $$
DROP PROCEDURE IF EXISTS `GetActiveMarriageForPerson`$$
CREATE PROCEDURE `GetActiveMarriageForPerson`(
    IN PersonIDIn INT
)
    SQL SECURITY INVOKER
    COMMENT 'Get the single active marriage for a person including partner details and computed duration'
BEGIN
    SELECT
        M.MarriageID,
        M.PartnerAID,
        M.PartnerBID,
        CASE
            WHEN M.PartnerAID = PersonIDIn THEN M.PartnerBID
            ELSE M.PartnerAID
        END AS PartnerID,
        P.PersonGivvenName AS PartnerGivvenName,
        P.PersonFamilyName AS PartnerFamilyName,
        P.PersonDateOfBirth AS PartnerDateOfBirth,
        P.PersonDateOfDeath AS PartnerDateOfDeath,
        M.StartDate,
        M.EndDate,
        M.EndReason,
        1 AS IsActive,
        CASE
            WHEN PA.PersonDateOfDeath IS NOT NULL AND PB.PersonDateOfDeath IS NOT NULL THEN LEAST(DATE(PA.PersonDateOfDeath), DATE(PB.PersonDateOfDeath))
            WHEN PA.PersonDateOfDeath IS NOT NULL THEN DATE(PA.PersonDateOfDeath)
            WHEN PB.PersonDateOfDeath IS NOT NULL THEN DATE(PB.PersonDateOfDeath)
            ELSE CURRENT_DATE()
        END AS EffectiveEndDate,
        TIMESTAMPDIFF(
            YEAR,
            M.StartDate,
            CASE
                WHEN PA.PersonDateOfDeath IS NOT NULL AND PB.PersonDateOfDeath IS NOT NULL THEN LEAST(DATE(PA.PersonDateOfDeath), DATE(PB.PersonDateOfDeath))
                WHEN PA.PersonDateOfDeath IS NOT NULL THEN DATE(PA.PersonDateOfDeath)
                WHEN PB.PersonDateOfDeath IS NOT NULL THEN DATE(PB.PersonDateOfDeath)
                ELSE CURRENT_DATE()
            END
        ) AS DurationYears,
        M.CreatedAt,
        M.UpdatedAt,
        M.Timestamp
    FROM humans.marriages M
    JOIN humans.persons PA ON PA.PersonID = M.PartnerAID
    JOIN humans.persons PB ON PB.PersonID = M.PartnerBID
    JOIN humans.persons P
        ON P.PersonID = CASE
            WHEN M.PartnerAID = PersonIDIn THEN M.PartnerBID
            ELSE M.PartnerAID
        END
    WHERE PersonIDIn IN (M.PartnerAID, M.PartnerBID)
      AND M.EndDate IS NULL
    ORDER BY M.StartDate DESC
    LIMIT 1;
END$$
DELIMITER ;