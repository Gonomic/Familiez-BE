DELIMITER $$
DROP FUNCTION IF EXISTS `fPersonHasOtherPartner`$$
CREATE FUNCTION `fPersonHasOtherPartner`(PersonIdIn INT(11))
    RETURNS TINYINT(1)
    SQL SECURITY INVOKER
    READS SQL DATA
    COMMENT 'Returns true when a person has a partner relation with another person'
BEGIN
    DECLARE ExistingPartnerCount INT DEFAULT 0;

    SELECT COUNT(*) INTO ExistingPartnerCount
    FROM humans.relations
    WHERE RelationName = 3
      AND (
            (RelationPerson = PersonIdIn AND RelationWithPerson <> PersonIdIn)
         OR (RelationWithPerson = PersonIdIn AND RelationPerson <> PersonIdIn)
      );

    RETURN IF(ExistingPartnerCount > 0, 1, 0);
END$$
DELIMITER ;