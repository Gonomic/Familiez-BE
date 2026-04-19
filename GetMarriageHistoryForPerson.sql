DELIMITER $$
DROP PROCEDURE IF EXISTS `GetMarriageHistoryForPerson`$$
CREATE PROCEDURE `GetMarriageHistoryForPerson`(
    IN PersonIDIn INT
)
    SQL SECURITY INVOKER
    COMMENT 'Get complete marriage history for a person including active status and computed duration'
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
        M.MarriagePlace,
        M.EndDate,
        M.EndReason,
        CASE WHEN M.EndDate IS NULL THEN 1 ELSE 0 END AS IsActive,
        CASE
            WHEN M.EndDate IS NOT NULL THEN M.EndDate
            WHEN PA.PersonDateOfDeath IS NOT NULL AND PB.PersonDateOfDeath IS NOT NULL THEN LEAST(DATE(PA.PersonDateOfDeath), DATE(PB.PersonDateOfDeath))
            WHEN PA.PersonDateOfDeath IS NOT NULL THEN DATE(PA.PersonDateOfDeath)
            WHEN PB.PersonDateOfDeath IS NOT NULL THEN DATE(PB.PersonDateOfDeath)
            ELSE CURRENT_DATE()
        END AS EffectiveEndDate,
        TIMESTAMPDIFF(
            YEAR,
            M.StartDate,
            CASE
                WHEN M.EndDate IS NOT NULL THEN M.EndDate
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
    ORDER BY M.StartDate DESC, M.MarriageID DESC;
END$$
DELIMITER ;