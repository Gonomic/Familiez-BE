DELIMITER $$
DROP PROCEDURE IF EXISTS `GetActiveMarriageForPair`$$
CREATE PROCEDURE `GetActiveMarriageForPair`(
    IN PersonAIdIn INT(11),
    IN PersonBIdIn INT(11)
)
    SQL SECURITY INVOKER
    COMMENT 'Get the active marriage for a normalized pair including both partner details and computed duration'
BEGIN
    -- Process variables
    DECLARE PartnerALocal INT;
    DECLARE PartnerBLocal INT;
    
    -- Normalize partner IDs (lower ID = PartnerA, higher ID = PartnerB)
    SET PartnerALocal = LEAST(PersonAIdIn, PersonBIdIn);
    SET PartnerBLocal = GREATEST(PersonAIdIn, PersonBIdIn);

    SELECT
        M.MarriageID,
        M.PartnerAID,
        PA.PersonGivvenName AS PartnerAGivvenName,
        PA.PersonFamilyName AS PartnerAFamilyName,
        PA.PersonDateOfDeath AS PartnerADateOfDeath,
        M.PartnerBID,
        PB.PersonGivvenName AS PartnerBGivvenName,
        PB.PersonFamilyName AS PartnerBFamilyName,
        PB.PersonDateOfDeath AS PartnerBDateOfDeath,
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
    WHERE M.PartnerAID = PartnerALocal
      AND M.PartnerBID = PartnerBLocal
      AND M.EndDate IS NULL
    ORDER BY M.StartDate DESC
    LIMIT 1;
END$$
DELIMITER ;